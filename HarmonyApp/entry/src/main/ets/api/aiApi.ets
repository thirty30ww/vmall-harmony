import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

export interface ChatMessage {
  role: string;
  content: string;
}

export interface RecommendedProduct {
  productId: number;
  productName: string;
  imageUrl: string | null;
  price: number | null;
  feature: string | null;
}

export interface ChatResponse {
  reply: string;
  conversationId: number;
  recommendedProducts: RecommendedProduct[] | null;
}

export interface Conversation {
  id: number;
  userId: number;
  title: string;
  status: number;
  createdAt: string;
  updatedAt: string;
}

export interface ConversationDetail {
  conversation: Conversation;
  messages: ChatMessage[];
}

function getToken(): string {
  return AppStorage.get<string>('token') ?? '';
}

function getAuthHeaders(): Record<string, string> {
  const token = getToken();
  const headers: Record<string, string> = { 'Content-Type': 'application/json' };
  if (token.length > 0) {
    headers['Authorization'] = 'Bearer ' + token;
  }
  return headers;
}

export async function chatWithAI(
  message: string,
  history: ChatMessage[],
  conversationId: number | null
): Promise<ChatResponse> {
  const request = http.createHttp();
  try {
    const response = await request.request(API_BASE_URL + '/ai/chat', {
      method: http.RequestMethod.POST,
      connectTimeout: 30000,
      readTimeout: 60000,
      header: getAuthHeaders(),
      extraData: JSON.stringify({ message, history, conversationId })
    });
    if (response.responseCode < 200 || response.responseCode >= 300) {
      throw new Error('AI chat failed: ' + response.responseCode);
    }
    return JSON.parse(response.result as string) as ChatResponse;
  } finally {
    request.destroy();
  }
}

export async function listConversations(): Promise<Conversation[]> {
  const request = http.createHttp();
  try {
    const response = await request.request(API_BASE_URL + '/ai/conversations', {
      method: http.RequestMethod.GET,
      connectTimeout: 10000,
      readTimeout: 10000,
      header: getAuthHeaders()
    });
    if (response.responseCode < 200 || response.responseCode >= 300) {
      return [];
    }
    return JSON.parse(response.result as string) as Conversation[];
  } finally {
    request.destroy();
  }
}

export async function getConversation(id: number): Promise<ConversationDetail> {
  const request = http.createHttp();
  try {
    const response = await request.request(API_BASE_URL + '/ai/conversations/' + id, {
      method: http.RequestMethod.GET,
      connectTimeout: 10000,
      readTimeout: 10000,
      header: getAuthHeaders()
    });
    if (response.responseCode < 200 || response.responseCode >= 300) {
      throw new Error('Failed to get conversation');
    }
    return JSON.parse(response.result as string);
  } finally {
    request.destroy();
  }
}

export async function deleteConversation(id: number): Promise<void> {
  const request = http.createHttp();
  try {
    await request.request(API_BASE_URL + '/ai/conversations/' + id, {
      method: http.RequestMethod.DELETE,
      connectTimeout: 10000,
      readTimeout: 10000,
      header: getAuthHeaders()
    });
  } finally {
    request.destroy();
  }
}
