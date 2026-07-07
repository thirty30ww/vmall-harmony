// 购物车 API —— 提供购物车的增删改查网络请求
import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

// 购物车商品项数据类型
export interface CartItem {
  id: number;
  productId: number;
  productSource: string;
  productName: string;
  productImage: string | null;
  productPrice: number;
  productFeature: string | null;
  quantity: number;
  selected: boolean;
}

// 购物车汇总数据类型
export interface CartSummary {
  items: CartItem[];
  totalAmount: number;
}

// 添加到购物车的请求体
export interface AddCartItemRequest {
  productId: number;
  productSource: string;
  productName: string;
  productImage: string | null;
  productPrice: number;
  productFeature: string | null;
}

// 全选/取消全选的请求体
interface SelectAllCartRequest {
  selected: boolean;
}

type CartRequestBody = AddCartItemRequest | SelectAllCartRequest | null;

// 规范化购物车汇总数据，确保空字段有默认值
function normalizeCartSummary(data: CartSummary): CartSummary {
  return {
    items: data.items ?? [],
    totalAmount: data.totalAmount ?? 0
  };
}

// 通用购物车请求封装，自动携带认证 Token
async function requestCart<T>(path: string, method: http.RequestMethod, body: CartRequestBody): Promise<T> {
  const token = AppStorage.get<string>('token') ?? '';
  if (token.length === 0) {
    throw new Error('需要先登录');
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
      throw new Error(`请求失败: ${response.responseCode}`);
    }

    return JSON.parse(response.result as string) as T;
  } finally {
    request.destroy();
  }
}

// 获取购物车列表
export async function getCart(): Promise<CartSummary> {
  const data = await requestCart<CartSummary>('/cart', http.RequestMethod.GET, null);
  return normalizeCartSummary(data);
}

// 添加商品到购物车
export async function addCartItem(item: AddCartItemRequest): Promise<CartSummary> {
  const data = await requestCart<CartSummary>('/cart/items', http.RequestMethod.POST, item);
  return normalizeCartSummary(data);
}

// 从购物车删除指定商品
export async function deleteCartItem(itemId: number): Promise<CartSummary> {
  const data = await requestCart<CartSummary>(`/cart/items/${itemId}`, http.RequestMethod.POST, null);
  return normalizeCartSummary(data);
}

// 全选或取消全选购物车商品
export async function selectAllCartItems(selected: boolean): Promise<CartSummary> {
  const requestBody: SelectAllCartRequest = { selected: selected };
  const data = await requestCart<CartSummary>('/cart/select-all', http.RequestMethod.PUT, requestBody);
  return normalizeCartSummary(data);
}
