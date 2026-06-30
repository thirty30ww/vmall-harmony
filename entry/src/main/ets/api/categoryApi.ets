import { http } from '@kit.NetworkKit';

const API_BASE_URL: string = 'http://10.162.106.18:8080/api';

export interface CategoryPageProduct {
  id: number;
  categoryId: number;
  name: string | null;
  imageUrl: string | null;
  productUrl: string | null;
  sortOrder: number | null;
}

export interface CategoryPageCategory {
  id: number;
  name: string | null;
  sortOrder: number | null;
  products: CategoryPageProduct[];
}

export interface CategoryPageData {
  categories: CategoryPageCategory[];
}

function normalizeCategoryPage(data: CategoryPageData): CategoryPageData {
  const categories = data.categories ?? [];
  categories.forEach((item: CategoryPageCategory) => {
    item.products = item.products ?? [];
  });
  return {
    categories: categories
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

export async function getCategoryPage(): Promise<CategoryPageData> {
  const data = await requestJson<CategoryPageData>('/category-page');
  return normalizeCategoryPage(data);
}