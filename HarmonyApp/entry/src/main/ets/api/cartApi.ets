import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

export interface CartItem {
  id: number;
  productId: number;
  productSource: string;
  productName: string;
  productImage: string | null;
  productPrice: number;
  productFeature: string | null;
  quantity: number;
  lineAmount: number;
}

export interface CartSummary {
  items: CartItem[];
  totalAmount: number;
}

export interface AddCartItemRequest {
  productId: number;
  productSource: string;
  productName: string;
  productImage: string | null;
  productPrice: number;
  productFeature: string | null;
  quantity: number;
}

interface UpdateCartItemRequest {
  quantity?: number;
}

type CartRequestBody = AddCartItemRequest | UpdateCartItemRequest | null;

function normalizeCartSummary(data: CartSummary): CartSummary {
  return {
    items: data.items ?? [],
    totalAmount: data.totalAmount ?? 0
  };
}

async function requestCart<T>(path: string, method: http.RequestMethod, body: CartRequestBody): Promise<T> {
  const token = AppStorage.get<string>('token') ?? '';
  if (token.length === 0) {
    throw new Error('login required');
  }

  const request = http.createHttp();
  try {
    const url: string = `${API_BASE_URL}${path}`;
    const response = body === null
      ? await request.request(url, {
          method: method,
          connectTimeout: 10000,
          readTimeout: 10000,
          header: {
            'Authorization': `Bearer ${token}`
          }
        })
      : await request.request(url, {
          method: method,
          connectTimeout: 10000,
          readTimeout: 10000,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          extraData: JSON.stringify(body)
        });

    if (response.responseCode < 200 || response.responseCode >= 300) {
      throw new Error(`Request failed: ${response.responseCode}`);
    }

    return JSON.parse(response.result as string) as T;
  } finally {
    request.destroy();
  }
}

export async function getCart(): Promise<CartSummary> {
  const data = await requestCart<CartSummary>('/cart', http.RequestMethod.GET, null);
  return normalizeCartSummary(data);
}

export async function addCartItem(item: AddCartItemRequest): Promise<CartSummary> {
  const data = await requestCart<CartSummary>('/cart/items', http.RequestMethod.POST, item);
  return normalizeCartSummary(data);
}

export async function updateCartItem(itemId: number, quantity: number | null): Promise<CartSummary> {
  const requestBody: UpdateCartItemRequest = {};
  if (quantity !== null) {
    requestBody.quantity = quantity;
  }
  const data = await requestCart<CartSummary>(`/cart/items/${itemId}`, http.RequestMethod.PUT, requestBody);
  return normalizeCartSummary(data);
}

export async function deleteCartItem(itemId: number): Promise<CartSummary> {
  const data = await requestCart<CartSummary>(`/cart/items/${itemId}`, http.RequestMethod.POST, null);
  return normalizeCartSummary(data);
}
