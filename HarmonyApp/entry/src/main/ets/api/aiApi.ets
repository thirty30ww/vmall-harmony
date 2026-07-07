// AI 智能导购 API —— 提供 AI 对话、商品推荐、对话历史管理
import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

// 对话消息类型
export interface ChatMessage {
  role: string;
  content: string;
  metadata?: string | null;
}

// AI 推荐的商品数据类型
export interface RecommendedProduct {
  productId: number;
  productName: string;
  imageUrl: string | null;
  price: number | null;
  feature: string | null;
}

// AI 对话响应类型
export interface ChatResponse {
  reply: string;
  conversationId: number;
  recommendedProducts: RecommendedProduct[] | null;
}

// 对话列表项
export interface Conversation {
  id: number;
  userId: number;
  title: string;
  status: number;
  createdAt: string;
  updatedAt: string;
}

// 对话详情（包含消息列表）
export interface ConversationDetail {
  conversation: Conversation;
  messages: ChatMessage[];
}

// 从全局存储获取 Token
function getToken(): string {
  return AppStorage.get<string>('token') ?? '';
}

// 获取认证请求头，已登录时自动添加 Bearer Token
function getAuthHeaders(): Record<string, string> {
  const token = getToken();
  const headers: Record<string, string> = { 'Content-Type': 'application/json' };
  if (token.length > 0) {
    headers['Authorization'] = 'Bearer ' + token;
  }
  return headers;
}

// 向 AI 发送消息，携带历史记录和会话 ID
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
      throw new Error('AI 对话失败: ' + response.responseCode);
    }
    return JSON.parse(response.result as string) as ChatResponse;
  } finally {
    request.destroy();
  }
}

// 获取对话历史列表
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

// 获取单个对话的详情（包含消息内容）
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
      throw new Error('获取对话失败');
    }
    return JSON.parse(response.result as string);
  } finally {
    request.destroy();
  }
}

// 删除指定对话
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
