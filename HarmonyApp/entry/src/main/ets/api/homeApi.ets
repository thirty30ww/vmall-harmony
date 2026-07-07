// 首页 API —— 提供首页数据、商品列表和商品详情的网络请求
import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

// 分类数据类型
export interface Category {
  id: number;
  name: string | null;
  scrapedAt: string | null;
}

// 搜索建议数据类型
export interface SearchSuggestion {
  id: number;
  keyword: string | null;
  scrapedAt: string | null;
}

// 活动数据类型
export interface Activity {
  id: number;
  title: string | null;
  activityUrl: string | null;
  scrapedAt: string | null;
}

// 商品数据类型
export interface Product {
  id: number;
  prdId: string | null;
  sbomCode: string | null;
  name: string | null;
  feature: string | null;
  price: number | null;
  imageUrl: string | null;
  productUrl: string | null;
  rawText: string | null;
  scrapedAt: string | null;
}

// 首页数据结构，包含分类、搜索建议、活动和商品列表
export interface HomeData {
  categories: Category[];
  suggestions: SearchSuggestion[];
  activities: Activity[];
  products: Product[];
}

// 规范化首页数据，确保空字段有默认值
function normalizeHomeData(data: HomeData): HomeData {
  return {
    categories: data.categories ?? [],
    suggestions: data.suggestions ?? [],
    activities: data.activities ?? [],
    products: data.products ?? []
  };
}

// 通用 GET 请求封装，发起 HTTP 请求并返回解析后的 JSON 数据
async function requestJson<T>(path: string): Promise<T> {
  const request = http.createHttp();
  try {
    const response = await request.request(`${API_BASE_URL}${path}`, {
      method: http.RequestMethod.GET,
      connectTimeout: 10000,
      readTimeout: 10000,
      header: {
        'Content-Type': 'application/json'
      }
    });

    if (response.responseCode < 200 || response.responseCode >= 300) {
      throw new Error(`请求失败: ${response.responseCode}`);
    }

    return JSON.parse(response.result as string) as T;
  } finally {
    request.destroy();
  }
}

// 获取首页数据（分类、搜索建议、活动、商品）
export async function getHomeData(): Promise<HomeData> {
  const data = await requestJson<HomeData>('/home');
  return normalizeHomeData(data);
}

// 根据关键字搜索商品，无关键字时返回所有商品
export async function getProducts(keyword?: string): Promise<Product[]> {
  const query = keyword && keyword.trim().length > 0
    ? `?keyword=${encodeURIComponent(keyword.trim())}`
    : '';
  return requestJson<Product[]>(`/products${query}`);
}

// 根据 ID 获取单个商品详情
export async function getProductById(id: number): Promise<Product> {
  return requestJson<Product>(`/products/${id}`);
}
