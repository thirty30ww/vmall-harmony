// 发现页 API —— 提供发现页各类内容数据
import { http } from '@kit.NetworkKit';
import { API_BASE_URL } from './ApiConfig';

// 发现页数据类型
export interface DiscoverPage {
  id: number;
  pageId: string | null;
  pageName: string | null;
  sourceUrl: string | null;
  sortOrder: number | null;
  createdAt: string | null;
}

// 发现页 Tab 类型
export interface DiscoverTab {
  id: number;
  tabKey: string | null;
  tabName: string | null;
  relatedPageId: string | null;
  sortOrder: number | null;
  createdAt: string | null;
}

// 导航图标类型
export interface DiscoverNavIcon {
  id: number;
  pageId: string | null;
  position: string | null;
  title: string | null;
  iconAttribute: string | null;
  imageUrl: string | null;
  linkUrl: string | null;
  sortOrder: number | null;
  createdAt: string | null;
}

// 发现页内容区块类型
export interface DiscoverSection {
  id: number;
  pageId: string | null;
  tabName: string | null;
  cardId: string | null;
  cardType: string | null;
  cardName: string | null;
  layoutType: string | null;
  dataSourceCode: string | null;
  dataSourceType: string | null;
  imgProportion: string | null;
  sortOrder: number | null;
  createdAt: string | null;
}

// 发现页具体内容项类型
export interface DiscoverItem {
  id: number;
  pageId: string | null;
  tabName: string | null;
  cardId: string | null;
  dataSourceCode: string | null;
  itemType: string | null;
  title: string | null;
  subtitle: string | null;
  authorName: string | null;
  imageUrl: string | null;
  linkUrl: string | null;
  contentId: string | null;
  contentType: string | null;
  productName: string | null;
  productPrice: number | null;
  likeCount: number | null;
  viewCount: number | null;
  sortOrder: number | null;
  createdAt: string | null;
}

// 发现页区块及其内容项的分组
export interface DiscoverSectionGroup {
  section: DiscoverSection;
  items: DiscoverItem[];
}

// 发现页整体数据结构
export interface DiscoverData {
  pages: DiscoverPage[];
  tabs: DiscoverTab[];
  navIcons: DiscoverNavIcon[];
  sections: DiscoverSectionGroup[];
}

// 创建空白的发现页数据
export function createEmptyDiscoverData(): DiscoverData {
  const data: DiscoverData = {
    pages: [],
    tabs: [],
    navIcons: [],
    sections: []
  };
  return data;
}

// 规范化发现页数据，确保空字段有默认值
function normalizeDiscoverData(data: DiscoverData): DiscoverData {
  const result: DiscoverData = {
    pages: data.pages ?? [],
    tabs: data.tabs ?? [],
    navIcons: data.navIcons ?? [],
    sections: data.sections ?? []
  };
  return result;
}

// 向 URL 路径追加查询参数
function appendQuery(path: string, key: string, value?: string): string {
  if (value === undefined || value.trim().length === 0) {
    return path;
  }
  const separator: string = path.indexOf('?') >= 0 ? '&' : '?';
  return `${path}${separator}${key}=${encodeURIComponent(value.trim())}`;
}

// 通用 GET 请求封装
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

// 获取发现页数据，可按 PageId 和 Tab 名称过滤
export async function getDiscoverData(pageId?: string, tabName?: string): Promise<DiscoverData> {
  let path: string = '/discover';
  path = appendQuery(path, 'pageId', pageId);
  path = appendQuery(path, 'tabName', tabName);
  const data = await requestJson<DiscoverData>(path);
  return normalizeDiscoverData(data);
}
