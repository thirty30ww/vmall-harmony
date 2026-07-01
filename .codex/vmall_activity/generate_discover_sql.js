const fs = require('fs');
const path = require('path');

const baseDir = __dirname;
const pageIds = ['101151623', '101151080', '101151077', '101151081', '101151082'];
const pageSort = new Map(pageIds.map((id, index) => [id, index]));

function readJson(file) {
  return JSON.parse(fs.readFileSync(path.join(baseDir, file), 'utf8').replace(/^\uFEFF/, ''));
}
function sqlStr(value) {
  if (value === null || value === undefined) return 'NULL';
  return `'${String(value).replace(/'/g, "''")}'`;
}
function sqlNum(value) {
  if (value === null || value === undefined || value === '') return 'NULL';
  return String(value);
}
function fullUrl(value) {
  if (!value) return '';
  const text = String(value);
  if (/^(https?:\/\/|vmall:\/\/)/.test(text)) return text;
  if (text.startsWith('/')) return `https://res.vmallres.com${text}`;
  return text;
}
function firstLink(item) {
  for (const key of ['actionUrlWap', 'actonUrl', 'actionUrl', 'actionUrlWeb', 'actionUrlMp']) {
    if (item && item[key]) return item[key];
  }
  return '';
}
function cardConfig(card) {
  if (!card || !card.configInfo) return {};
  return JSON.parse(card.configInfo);
}
function sourceUrl(pageId) {
  return `https://m.vmall.com/portal/activity/index.html?pageId=${pageId}&showNavigation=true&callapp=no`;
}

const contentSource = readJson('datasource_contentBig_all.json');
const tabs = [];
const navIcons = [];
const sections = [];
const items = [];
const pageNameMap = new Map([['101151623', '\\u53d1\\u73b0']]);

const main = readJson('pageinfo_101151623.json');
const subTab = (main.pageInfos?.[0]?.cards || []).find(card => card.cardType === 'subTab');
if (subTab) {
  const cfg = cardConfig(subTab);
  for (const tab of cfg.cards || []) {
    const tabCfg = JSON.parse(tab.configInfo);
    const relatedPageId = String(tabCfg.relatedPageId || '');
    tabs.push({
      tabKey: tab.cardId,
      tabName: tab.cardName,
      relatedPageId,
      sortOrder: Number(tab.orderNum || 0)
    });
    if (relatedPageId) pageNameMap.set(relatedPageId, tab.cardName);
  }

  let iconOrder = 0;
  for (const source of subTab.dataSourceList || []) {
    for (const icon of source.icon?.dataInfos || []) {
      navIcons.push({ pageId: '101151623', position: 'left', title: icon.title, iconAttribute: icon.iconAttribute, imageUrl: fullUrl(icon.imgUrl), linkUrl: firstLink(icon), sortOrder: iconOrder++ });
    }
  }
  for (const source of subTab.rightDataSourceList || []) {
    for (const icon of source.icon?.dataInfos || []) {
      navIcons.push({ pageId: '101151623', position: 'right', title: icon.title, iconAttribute: icon.iconAttribute, imageUrl: fullUrl(icon.imgUrl), linkUrl: firstLink(icon), sortOrder: iconOrder++ });
    }
  }
}

for (const pageId of pageIds) {
  const page = readJson(`pageinfo_${pageId}.json`);
  const tabName = pageNameMap.get(pageId) || pageId;
  const cards = page.pageInfos?.[0]?.cards || [];

  cards.forEach((card, cardIndex) => {
    const cfg = cardConfig(card);
    const dsList = card.dataSourceList || [];
    const cfgSource = cfg.dataSourceList?.[0] || {};
    const cardSource = dsList[0] || {};

    sections.push({
      pageId,
      tabName,
      cardId: card.cardId,
      cardType: card.cardType,
      cardName: cfg.cardName || card.resSiteName || '',
      layoutType: cfg.layoutType || card.layout?.layoutType || '',
      dataSourceCode: cfgSource.dataSourceCode || cardSource.dataSourceCode || '',
      dataSourceType: cfgSource.dataSourceType || cardSource.dataSourceType || '',
      imgProportion: cfg.imgProportion || card.attribute?.imgProportion || '',
      sortOrder: cardIndex
    });

    if (card.cardType === 'ad') {
      let itemOrder = 0;
      for (const ds of dsList) {
        for (const ad of ds.ads?.dataInfos || []) {
          items.push({
            pageId,
            tabName,
            cardId: card.cardId,
            dataSourceCode: ds.dataSourceCode || '',
            itemType: 'ad',
            title: ad.title || cfg.cardName || card.resSiteName || '',
            subtitle: ad.subTitle || '',
            authorName: '',
            imageUrl: fullUrl(ad.imgUrl),
            linkUrl: firstLink(ad),
            contentId: '',
            contentType: null,
            productName: '',
            productPrice: null,
            likeCount: null,
            viewCount: null,
            sortOrder: itemOrder++
          });
        }
      }
    }

    if (card.cardType === 'contentBig') {
      for (const ds of dsList) {
        const code = ds.dataSourceCode || '';
        let itemOrder = 0;
        for (const content of contentSource.pageData?.[code] || []) {
          const product = content.recommendProduct?.[0] || {};
          items.push({
            pageId,
            tabName,
            cardId: card.cardId,
            dataSourceCode: code,
            itemType: 'content',
            title: content.title || '',
            subtitle: content.summary || '',
            authorName: content.user?.nickname || '',
            imageUrl: fullUrl(content.coverUri),
            linkUrl: `https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=${content.contentId || ''}`,
            contentId: content.contentId || '',
            contentType: content.contentType ?? null,
            productName: product.productName || '',
            productPrice: product.displayPrice ?? null,
            likeCount: content.likeCount ?? null,
            viewCount: content.viewCount ?? null,
            sortOrder: itemOrder++
          });
        }
      }
    }
  });
}

const lines = [];
lines.push('-- Huawei VMall Discover page seed data');
lines.push('-- Source: https://m.vmall.com/portal/activity/index.html?pageId=101151623&showNavigation=true&callapp=no');
lines.push('-- Crawl time: 2026-07-01');
lines.push('SET NAMES utf8mb4;');
lines.push('SET FOREIGN_KEY_CHECKS = 0;');
lines.push('');
lines.push('DROP TABLE IF EXISTS vmall_discover_items;');
lines.push('DROP TABLE IF EXISTS vmall_discover_sections;');
lines.push('DROP TABLE IF EXISTS vmall_discover_nav_icons;');
lines.push('DROP TABLE IF EXISTS vmall_discover_tabs;');
lines.push('DROP TABLE IF EXISTS vmall_discover_pages;');
lines.push('');
lines.push(`CREATE TABLE vmall_discover_pages (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  page_id VARCHAR(32) NOT NULL UNIQUE,
  page_name VARCHAR(64) NOT NULL,
  source_url VARCHAR(500) DEFAULT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`);
lines.push('');
lines.push(`CREATE TABLE vmall_discover_tabs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  tab_key VARCHAR(64) NOT NULL UNIQUE,
  tab_name VARCHAR(64) NOT NULL,
  related_page_id VARCHAR(32) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`);
lines.push('');
lines.push(`CREATE TABLE vmall_discover_nav_icons (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  page_id VARCHAR(32) NOT NULL,
  position VARCHAR(16) NOT NULL,
  title VARCHAR(128) NOT NULL,
  icon_attribute VARCHAR(64) DEFAULT NULL,
  image_url VARCHAR(1000) DEFAULT NULL,
  link_url VARCHAR(1000) DEFAULT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`);
lines.push('');
lines.push(`CREATE TABLE vmall_discover_sections (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  page_id VARCHAR(32) NOT NULL,
  tab_name VARCHAR(64) NOT NULL,
  card_id VARCHAR(64) NOT NULL,
  card_type VARCHAR(64) NOT NULL,
  card_name VARCHAR(255) DEFAULT NULL,
  layout_type VARCHAR(128) DEFAULT NULL,
  data_source_code VARCHAR(64) DEFAULT NULL,
  data_source_type VARCHAR(64) DEFAULT NULL,
  img_proportion VARCHAR(32) DEFAULT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uk_card_id (card_id),
  KEY idx_page_sort (page_id, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`);
lines.push('');
lines.push(`CREATE TABLE vmall_discover_items (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  page_id VARCHAR(32) NOT NULL,
  tab_name VARCHAR(64) NOT NULL,
  card_id VARCHAR(64) NOT NULL,
  data_source_code VARCHAR(64) DEFAULT NULL,
  item_type VARCHAR(32) NOT NULL,
  title VARCHAR(255) NOT NULL,
  subtitle VARCHAR(1000) DEFAULT NULL,
  author_name VARCHAR(128) DEFAULT NULL,
  image_url VARCHAR(1000) DEFAULT NULL,
  link_url VARCHAR(1000) DEFAULT NULL,
  content_id VARCHAR(64) DEFAULT NULL,
  content_type INT DEFAULT NULL,
  product_name VARCHAR(255) DEFAULT NULL,
  product_price DECIMAL(10,2) DEFAULT NULL,
  like_count INT DEFAULT NULL,
  view_count INT DEFAULT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_page_card_sort (page_id, card_id, sort_order),
  KEY idx_content_id (content_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;`);
lines.push('');

function addInsert(table, columns, rows, mapper) {
  if (!rows.length) return;
  lines.push(`INSERT INTO ${table} (${columns.join(', ')}) VALUES`);
  lines.push(rows.map(row => `  (${mapper(row).join(', ')})`).join(',\n') + ';');
  lines.push('');
}

addInsert('vmall_discover_pages', ['page_id', 'page_name', 'source_url', 'sort_order'], pageIds, pageId => [sqlStr(pageId), sqlStr(pageNameMap.get(pageId) || pageId), sqlStr(sourceUrl(pageId)), sqlNum(pageSort.get(pageId))]);
addInsert('vmall_discover_tabs', ['tab_key', 'tab_name', 'related_page_id', 'sort_order'], tabs, tab => [sqlStr(tab.tabKey), sqlStr(tab.tabName), sqlStr(tab.relatedPageId), sqlNum(tab.sortOrder)]);
addInsert('vmall_discover_nav_icons', ['page_id', 'position', 'title', 'icon_attribute', 'image_url', 'link_url', 'sort_order'], navIcons, icon => [sqlStr(icon.pageId), sqlStr(icon.position), sqlStr(icon.title), sqlStr(icon.iconAttribute), sqlStr(icon.imageUrl), sqlStr(icon.linkUrl), sqlNum(icon.sortOrder)]);
addInsert('vmall_discover_sections', ['page_id', 'tab_name', 'card_id', 'card_type', 'card_name', 'layout_type', 'data_source_code', 'data_source_type', 'img_proportion', 'sort_order'], sections, section => [sqlStr(section.pageId), sqlStr(section.tabName), sqlStr(section.cardId), sqlStr(section.cardType), sqlStr(section.cardName), sqlStr(section.layoutType), sqlStr(section.dataSourceCode), sqlStr(section.dataSourceType), sqlStr(section.imgProportion), sqlNum(section.sortOrder)]);
addInsert('vmall_discover_items', ['page_id', 'tab_name', 'card_id', 'data_source_code', 'item_type', 'title', 'subtitle', 'author_name', 'image_url', 'link_url', 'content_id', 'content_type', 'product_name', 'product_price', 'like_count', 'view_count', 'sort_order'], items, item => [sqlStr(item.pageId), sqlStr(item.tabName), sqlStr(item.cardId), sqlStr(item.dataSourceCode), sqlStr(item.itemType), sqlStr(item.title), sqlStr(item.subtitle), sqlStr(item.authorName), sqlStr(item.imageUrl), sqlStr(item.linkUrl), sqlStr(item.contentId), sqlNum(item.contentType), sqlStr(item.productName), sqlNum(item.productPrice), sqlNum(item.likeCount), sqlNum(item.viewCount), sqlNum(item.sortOrder)]);

lines.push('SET FOREIGN_KEY_CHECKS = 1;');

const outFile = path.join(baseDir, 'vmall_discover_seed.sql');
fs.writeFileSync(outFile, lines.join('\n'), 'utf8');
console.log(JSON.stringify({ pages: pageIds.length, tabs: tabs.length, navIcons: navIcons.length, sections: sections.length, items: items.length, outFile }, null, 2));

