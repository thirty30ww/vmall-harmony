import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

export interface ChatResponse {
  reply: string;
}

export async function chatWithAI(message: string): Promise<ChatResponse> {
  const request = http.createHttp();
  try {
    const url: string = API_BASE_URL + '/ai/chat';
    const response = await request.request(url, {
      method: http.RequestMethod.POST,
      connectTimeout: 30000,
      readTimeout: 60000,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify({ message })
    });

    if (response.responseCode < 200 || response.responseCode >= 300) {
      throw new Error(`AI chat failed: ${response.responseCode}`);
    }

    return JSON.parse(response.result as string) as ChatResponse;
  } finally {
    request.destroy();
  }
}
