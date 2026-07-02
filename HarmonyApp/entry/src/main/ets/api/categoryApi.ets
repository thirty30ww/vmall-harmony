import { http } from '@kit.NetworkKit';

const API_BASE_URL: string = 'http://10.162.106.18:8080/api';

export interface CategoryPageRawItem {
  id: number;
  name: string | null;
  groupName: string | null;
  productName: string | null;
  imageUrl: string | null;
  productUrl?: string | null;
  feature?: string | null;
  price?: number | null;
  scrapedAt?: string | null;
}

export interface CategoryPageProduct {
  id: number;
  categoryId: number;
  categoryName: string;
  groupName: string;
  name: string;
  imageUrl: string | null;
  productUrl: string | null;
  feature: string | null;
  price: number | null;
  sortOrder: number | null;
}

export interface CategoryPageGroup {
  groupName: string;
  products: CategoryPageProduct[];
}

export interface CategoryPageCategory {
  id: number;
  name: string | null;
  sortOrder: number | null;
  groups: CategoryPageGroup[];
  products: CategoryPageProduct[];
}

export interface CategoryPageData {
  categories: CategoryPageCategory[];
}

function findCategoryIndex(categories: CategoryPageCategory[], categoryName: string): number {
  for (let index = 0; index < categories.length; index++) {
    if (categories[index].name === categoryName) {
      return index;
    }
  }
  return -1;
}

function findGroupIndex(groups: CategoryPageGroup[], groupName: string): number {
  for (let index = 0; index < groups.length; index++) {
    if (groups[index].groupName === groupName) {
      return index;
    }
  }
  return -1;
}

function normalizeFlatCategoryItems(items: CategoryPageRawItem[]): CategoryPageData {
  const categories: CategoryPageCategory[] = [];

  items.forEach((item: CategoryPageRawItem) => {
    const categoryName: string = item.name ?? '';
    const groupName: string = item.groupName ?? '';
    const productName: string = item.productName ?? '';
    if (categoryName.length === 0 || groupName.length === 0 || productName.length === 0) {
      return;
    }

    let categoryIndex: number = findCategoryIndex(categories, categoryName);
    if (categoryIndex < 0) {
      const categoryId: number = categories.length + 1;
      const newCategory: CategoryPageCategory = {
        id: categoryId,
        name: categoryName,
        sortOrder: categoryId,
        groups: [],
        products: []
      };
      categories.push(newCategory);
      categoryIndex = categories.length - 1;
    }

    const category: CategoryPageCategory = categories[categoryIndex];
    let groupIndex: number = findGroupIndex(category.groups, groupName);
    if (groupIndex < 0) {
      const newGroup: CategoryPageGroup = {
        groupName: groupName,
        products: []
      };
      category.groups.push(newGroup);
      groupIndex = category.groups.length - 1;
    }

    const productUrl: string | null = item.productUrl === undefined ? null : item.productUrl;
    const product: CategoryPageProduct = {
      id: item.id,
      categoryId: category.id,
      categoryName: categoryName,
      groupName: groupName,
      name: productName,
      imageUrl: item.imageUrl,
      productUrl: productUrl,
      feature: item.feature === undefined ? null : item.feature,
      price: item.price === undefined ? null : item.price,
      sortOrder: item.id
    };
    category.groups[groupIndex].products.push(product);
    category.products.push(product);
  });

  const result: CategoryPageData = {
    categories: categories
  };
  return result;
}

function normalizeTreeCategoryData(data: CategoryPageData): CategoryPageData {
  const categories: CategoryPageCategory[] = data.categories ?? [];
  categories.forEach((category: CategoryPageCategory) => {
    category.products = category.products ?? [];
    category.groups = category.groups ?? [];

    if (category.groups.length === 0 && category.products.length > 0) {
      const groups: CategoryPageGroup[] = [];
      category.products.forEach((product: CategoryPageProduct) => {
        product.feature = product.feature ?? null;
        product.price = product.price ?? null;
        const groupName: string = product.groupName ?? '商品推荐';
        let groupIndex: number = findGroupIndex(groups, groupName);
        if (groupIndex < 0) {
          const group: CategoryPageGroup = {
            groupName: groupName,
            products: []
          };
          groups.push(group);
          groupIndex = groups.length - 1;
        }
        groups[groupIndex].products.push(product);
      });
      category.groups = groups;
    }
  });

  const result: CategoryPageData = {
    categories: categories
  };
  return result;
}

function normalizeCategoryPage(data: CategoryPageData | CategoryPageRawItem[]): CategoryPageData {
  if (Array.isArray(data)) {
    return normalizeFlatCategoryItems(data as CategoryPageRawItem[]);
  }
  return normalizeTreeCategoryData(data as CategoryPageData);
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
  const data = await requestJson<CategoryPageData | CategoryPageRawItem[]>('/categories');
  return normalizeCategoryPage(data);
}
