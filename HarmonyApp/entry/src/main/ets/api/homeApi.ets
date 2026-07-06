import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

export interface Category {
  id: number;
  name: string | null;
  scrapedAt: string | null;
}

export interface SearchSuggestion {
  id: number;
  keyword: string | null;
  scrapedAt: string | null;
}

export interface Activity {
  id: number;
  title: string | null;
  activityUrl: string | null;
  scrapedAt: string | null;
}

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

export interface HomeData {
  categories: Category[];
  suggestions: SearchSuggestion[];
  activities: Activity[];
  products: Product[];
}

function normalizeHomeData(data: HomeData): HomeData {
  return {
    categories: data.categories ?? [],
    suggestions: data.suggestions ?? [],
    activities: data.activities ?? [],
    products: data.products ?? []
  };
}

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
      throw new Error(`Request failed: ${response.responseCode}`);
    }

    return JSON.parse(response.result as string) as T;
  } finally {
    request.destroy();
  }
}

export async function getHomeData(): Promise<HomeData> {
  const data = await requestJson<HomeData>('/home');
  return normalizeHomeData(data);
}

export async function getProducts(keyword?: string): Promise<Product[]> {
  const query = keyword && keyword.trim().length > 0
    ? `?keyword=${encodeURIComponent(keyword.trim())}`
    : '';
  return requestJson<Product[]>(`/products${query}`);
}

export async function getProductById(id: number): Promise<Product> {
  return requestJson<Product>(`/products/${id}`);
}
