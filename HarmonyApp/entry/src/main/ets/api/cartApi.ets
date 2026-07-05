// cartApi.ts
import { http } from '@kit.NetworkKit';

const API_BASE_URL: string = 'http://10.162.106.18:8080/api';

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
  lineAmount: number;
}

export interface CartSummary {
  items: CartItem[];
  selectedCount: number;
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
  selected?: boolean;
}

interface SelectAllCartRequest {
  selected: boolean;
}

type CartRequestBody = AddCartItemRequest | UpdateCartItemRequest | SelectAllCartRequest | null;

function normalizeCartSummary(data: CartSummary): CartSummary {
  const items: CartItem[] = data.items ?? [];
  return {
    items: items,
    selectedCount: data.selectedCount ?? 0,
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
    const response = await request.request(`${API_BASE_URL}${path}`, {
      method: method,
      connectTimeout: 10000,
      readTimeout: 10000,
      header: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${token}`
      },
      extraData: body === null ? '' : JSON.stringify(body)
    });

    if (response.responseCode < 200 || response.responseCode >= 300) {
      throw new Error(`Request failed: ${response.responseCode}`);
    }

    return JSON.parse(response.result as string) as T;
  } finally {
    request.destroy();
  }
}

// ============ 购物车 API（匹配后端接口） ============

/**
 * 获取购物车列表
 * GET /api/cart
 */
export async function getCart(): Promise<CartSummary> {
  const data = await requestCart<CartSummary>('/cart', http.RequestMethod.GET, null);
  return normalizeCartSummary(data);
}

/**
 * 添加商品到购物车
 * POST /api/cart/items
 */
export async function addCartItem(item: AddCartItemRequest): Promise<CartSummary> {
  const data = await requestCart<CartSummary>('/cart/items', http.RequestMethod.POST, item);
  return normalizeCartSummary(data);
}

/**
 * 更新购物车商品（数量或选中状态）
 * PUT /api/cart/items/{id}
 * @param itemId 购物车项ID
 * @param quantity 数量（可选）
 * @param selected 是否选中（可选）
 */
export async function updateCartItem(itemId: number, quantity: number | null, selected: boolean | null): Promise<CartSummary> {
  const requestBody: UpdateCartItemRequest = {};
  if (quantity !== null) {
    requestBody.quantity = quantity;
  }
  if (selected !== null) {
    requestBody.selected = selected;
  }
  const data = await requestCart<CartSummary>(`/cart/items/${itemId}`, http.RequestMethod.PUT, requestBody);
  return normalizeCartSummary(data);
}

/**
 * 删除购物车商品
 * DELETE /api/cart/items/{id}
 * @param itemId 购物车项ID
 */
export async function deleteCartItem(itemId: number): Promise<CartSummary> {
  const data = await requestCart<CartSummary>(`/cart/items/${itemId}`, http.RequestMethod.DELETE, null);
  return normalizeCartSummary(data);
}

/**
 * 全选/取消全选购物车
 * PUT /api/cart/select-all
 * @param selected 是否全选
 */
export async function selectAllCartItems(selected: boolean): Promise<CartSummary> {
  const requestBody: SelectAllCartRequest = {
    selected: selected
  };
  const data = await requestCart<CartSummary>('/cart/select-all', http.RequestMethod.PUT, requestBody);
  return normalizeCartSummary(data);
}