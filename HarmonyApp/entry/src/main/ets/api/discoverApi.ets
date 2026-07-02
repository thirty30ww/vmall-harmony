// discoverApi.ets
import { http } from '@kit.NetworkKit';

const API_BASE_URL: string = 'http://10.162.106.18:8080/api';

export interface DiscoverPage {
  id: number;
  pageId: string | null;
  pageName: string | null;
  sourceUrl: string | null;
  sortOrder: number | null;
  createdAt: string | null;
}

export interface DiscoverTab {
  id: number;
  tabKey: string | null;
  tabName: string | null;
  relatedPageId: string | null;
  sortOrder: number | null;
  createdAt: string | null;
}

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

export interface DiscoverSectionGroup {
  section: DiscoverSection;
  items: DiscoverItem[];
}

export interface DiscoverData {
  pages: DiscoverPage[];
  tabs: DiscoverTab[];
  navIcons: DiscoverNavIcon[];
  sections: DiscoverSectionGroup[];
}

export function createEmptyDiscoverData(): DiscoverData {
  const data: DiscoverData = {
    pages: [],
    tabs: [],
    navIcons: [],
    sections: []
  };
  return data;
}

function normalizeDiscoverData(data: DiscoverData): DiscoverData {
  const result: DiscoverData = {
    pages: data.pages ?? [],
    tabs: data.tabs ?? [],
    navIcons: data.navIcons ?? [],
    sections: data.sections ?? []
  };
  return result;
}

function appendQuery(path: string, key: string, value?: string): string {
  if (value === undefined || value.trim().length === 0) {
    return path;
  }
  const separator: string = path.indexOf('?') >= 0 ? '&' : '?';
  return `${path}${separator}${key}=${encodeURIComponent(value.trim())}`;
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

export async function getDiscoverData(pageId?: string, tabName?: string): Promise<DiscoverData> {
  let path: string = '/discover';
  path = appendQuery(path, 'pageId', pageId);
  path = appendQuery(path, 'tabName', tabName);
  const data = await requestJson<DiscoverData>(path);
  return normalizeDiscoverData(data);
}