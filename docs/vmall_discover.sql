DROP TABLE IF EXISTS vmall_discover_items;
DROP TABLE IF EXISTS vmall_discover_sections;
DROP TABLE IF EXISTS vmall_discover_nav_icons;
DROP TABLE IF EXISTS vmall_discover_tabs;
DROP TABLE IF EXISTS vmall_discover_pages;

CREATE TABLE vmall_discover_pages (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  page_id VARCHAR(32) NOT NULL UNIQUE,
  page_name VARCHAR(64) NOT NULL,
  source_url VARCHAR(500) DEFAULT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vmall_discover_tabs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  tab_key VARCHAR(64) NOT NULL UNIQUE,
  tab_name VARCHAR(64) NOT NULL,
  related_page_id VARCHAR(32) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vmall_discover_nav_icons (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  page_id VARCHAR(32) NOT NULL,
  position VARCHAR(16) NOT NULL,
  title VARCHAR(128) NOT NULL,
  icon_attribute VARCHAR(64) DEFAULT NULL,
  image_url VARCHAR(1000) DEFAULT NULL,
  link_url VARCHAR(1000) DEFAULT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vmall_discover_sections (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vmall_discover_items (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO vmall_discover_pages (page_id, page_name, source_url, sort_order) VALUES
  ('101151623', '\u53d1\u73b0', 'https://m.vmall.com/portal/activity/index.html?pageId=101151623&showNavigation=true&callapp=no', 0),
  ('101151080', '推荐', 'https://m.vmall.com/portal/activity/index.html?pageId=101151080&showNavigation=true&callapp=no', 1),
  ('101151077', '发布会', 'https://m.vmall.com/portal/activity/index.html?pageId=101151077&showNavigation=true&callapp=no', 2),
  ('101151081', '选购攻略', 'https://m.vmall.com/portal/activity/index.html?pageId=101151081&showNavigation=true&callapp=no', 3),
  ('101151082', '玩机技巧', 'https://m.vmall.com/portal/activity/index.html?pageId=101151082&showNavigation=true&callapp=no', 4);

INSERT INTO vmall_discover_tabs (tab_key, tab_name, related_page_id, sort_order) VALUES
  ('11953342#0', '推荐', '101151080', 0),
  ('11953342#1', '发布会', '101151077', 1),
  ('11953342#2', '选购攻略', '101151081', 2),
  ('11953342#3', '玩机技巧', '101151082', 3);

INSERT INTO vmall_discover_nav_icons (page_id, position, title, icon_attribute, image_url, link_url, sort_order) VALUES
  ('101151623', 'left', '个人中心', 'personalCenter', '', 'vmall://com.vmall.client/discoverNew/account', 0),
  ('101151623', 'right', '消息中心', 'message', '', 'vmall://com.vmall.client/shop/message', 1);

INSERT INTO vmall_discover_sections (page_id, tab_name, card_id, card_type, card_name, layout_type, data_source_code, data_source_type, img_proportion, sort_order) VALUES
  ('101151623', '\u53d1\u73b0', '11953663', 'ad', '头图', 'BannerLayout', 'DB070523', 'ad', '3:4', 0),
  ('101151623', '\u53d1\u73b0', '11953342', 'subTab', '发现频道子页签', 'sideSlipCapsule', 'DE001883', 'icon_text', '', 1),
  ('101151080', '推荐', '12008220', 'contentBig', '1', 'Adaptive', 'DK0001199', 'contentBig', '', 0),
  ('101151080', '推荐', '11953096', 'contentBig', '2', 'Adaptive', 'DK0001200', 'contentBig', '', 1),
  ('101151080', '推荐', '11953097', 'contentBig', '3', 'Adaptive', 'DK0001201', 'contentBig', '', 2),
  ('101151080', '推荐', '11953098', 'contentBig', '4', 'Adaptive', 'DK0001202', 'contentBig', '', 3),
  ('101151080', '推荐', '11949205', 'contentBig', '5', 'Adaptive', 'DK0001157', 'contentBig', '', 4),
  ('101151080', '推荐', '11949207', 'contentBig', '6', 'Adaptive', 'DK0001159', 'contentBig', '', 5),
  ('101151080', '推荐', '11949210', 'contentBig', '7', 'Adaptive', 'DK0001162', 'contentBig', '', 6),
  ('101151080', '推荐', '11949211', 'contentBig', '8', 'Adaptive', 'DK0001163', 'contentBig', '', 7),
  ('101151080', '推荐', '12010480', 'contentBig', '9', 'Adaptive', 'DK0001451', 'contentBig', '', 8),
  ('101151080', '推荐', '12011066', 'contentBig', '10', 'Adaptive', 'DK0001453', 'contentBig', '', 9),
  ('101151080', '推荐', '11962206', 'ad', '问卷', 'OneColumnLayout', 'DB071477', 'ad', '984:246', 10),
  ('101151077', '发布会', '11963948', 'contentBig', '鸿蒙智行尊界品牌盛典发布会', 'OneColumnLayout', 'DB080622', 'contentBig', '984:555', 0),
  ('101151077', '发布会', '12010433', 'contentBig', 'nova 16系列及全场景新品发布会全程回顾', 'OneColumnLayout', 'DB079073', 'contentBig', '984:555', 1),
  ('101151077', '发布会', '12006059', 'contentBig', '鸿蒙智行 问界M9系列新品发布会全程回顾', 'OneColumnLayout', 'DB079010', 'contentBig', '984:555', 2),
  ('101151077', '发布会', '12004362', 'contentBig', '鸿蒙智行 智界 V9发布会全程回顾', 'OneColumnLayout', 'DB078705', 'contentBig', '984:555', 3),
  ('101151077', '发布会', '12002201', 'contentBig', '华为Pura系列及全场景新品发布会 全程回顾', 'OneColumnLayout', 'DB077330', 'contentBig', '984:555', 4),
  ('101151077', '发布会', '11994935', 'contentBig', '华为春季全场景新品发布会全程回顾', 'OneColumnLayout', 'DB076401', 'contentBig', '984:555', 5),
  ('101151077', '发布会', '11987816', 'contentBig', '3.4鸿蒙智行技术焕新发布会', 'OneColumnLayout', 'DB075255', 'contentBig', '984:555', 6),
  ('101151077', '发布会', '11981768', 'contentBig', 'nova 15系列及全场景新品发布会 全程回顾', 'OneColumnLayout', 'DB071713', 'contentBig', '984:555', 7),
  ('101151077', '发布会', '11953103', 'contentBig', '华为新品发布会全程回顾', 'OneColumnLayout', 'DB070701', 'contentBig', '984:555', 8),
  ('101151077', '发布会', '11954857', 'contentBig', '鸿蒙智行 享界S9新品发布会全程回顾', 'OneColumnLayout', 'DB070472', 'contentBig', '984:555', 9),
  ('101151077', '发布会', '11953139', 'contentBig', '鸿蒙操作系统 6特别发布全程回顾', 'OneColumnLayout', 'DB070423', 'contentBig', '984:555', 10),
  ('101151077', '发布会', '11953104', 'contentBig', '华为穿戴音频新品线上发布会全程回顾', 'OneColumnLayout', 'DB070426', 'contentBig', '984:555', 11),
  ('101151077', '发布会', '11953105', 'contentBig', '鸿蒙智行秋季新品发布会全程回顾', 'OneColumnLayout', 'DB070429', 'contentBig', '984:555', 12),
  ('101151077', '发布会', '11953123', 'contentBig', '鸿蒙智行享界 S9T新品发布会全程回顾', 'OneColumnLayout', 'DB070432', 'contentBig', '984:555', 13),
  ('101151077', '发布会', '11953124', 'contentBig', '华为Mate XTs 非凡大师新品发布会全程回顾', 'OneColumnLayout', 'DB070435', 'contentBig', '984:555', 14),
  ('101151077', '发布会', '11953125', 'contentBig', '智界及问界秋季新品发布会全程回顾', 'OneColumnLayout', 'DB070438', 'contentBig', '984:555', 15),
  ('101151077', '发布会', '11953126', 'contentBig', '华为平板旗舰新品发布', 'OneColumnLayout', 'DB070441', 'contentBig', '984:555', 16),
  ('101151077', '发布会', '11953127', 'contentBig', '华为开发者大会（HDC 2025）主题演讲全程回顾', 'OneColumnLayout', 'DB070444', 'contentBig', '984:555', 17),
  ('101151077', '发布会', '11953128', 'contentBig', '华为Pura新品发布会全程回顾', 'OneColumnLayout', 'DB070447', 'contentBig', '984:555', 18),
  ('101151077', '发布会', '11953130', 'contentBig', 'nova14系列及鸿蒙电脑新品发布会全程回顾', 'OneColumnLayout', 'DB070453', 'contentBig', '984:555', 19),
  ('101151081', '选购攻略', '11949216', 'contentBig', '大卡1', 'Adaptive', 'DK0001203', 'contentBig', '', 0),
  ('101151081', '选购攻略', '11953141', 'contentBig', '大卡2', 'Adaptive', 'DK0001204', 'contentBig', '', 1),
  ('101151081', '选购攻略', '11953142', 'contentBig', '大卡3', 'Adaptive', 'DK0001205', 'contentBig', '', 2),
  ('101151081', '选购攻略', '11949217', 'contentBig', '大卡4', 'Adaptive', 'DK0001166', 'contentBig', '', 3),
  ('101151081', '选购攻略', '11949221', 'contentBig', '大卡5', 'Adaptive', 'DK0001170', 'contentBig', '', 4),
  ('101151081', '选购攻略', '11949218', 'contentBig', '大卡6', 'Adaptive', 'DK0001167', 'contentBig', '', 5),
  ('101151081', '选购攻略', '11949219', 'contentBig', '大卡7', 'Adaptive', 'DK0001168', 'contentBig', '', 6),
  ('101151081', '选购攻略', '11949223', 'contentBig', '大卡8', 'Adaptive', 'DK0001172', 'contentBig', '', 7),
  ('101151082', '玩机技巧', '11949224', 'contentBig', '大卡1', 'Adaptive', 'DK0001174', 'contentBig', '', 0),
  ('101151082', '玩机技巧', '11949225', 'contentBig', '大卡2', 'Adaptive', 'DK0001175', 'contentBig', '', 1),
  ('101151082', '玩机技巧', '11949226', 'contentBig', '大卡3', 'Adaptive', 'DK0001176', 'contentBig', '', 2),
  ('101151082', '玩机技巧', '11949227', 'contentBig', '大卡4', 'Adaptive', 'DK0001177', 'contentBig', '', 3),
  ('101151082', '玩机技巧', '11949228', 'contentBig', '大卡5', 'Adaptive', 'DK0001178', 'contentBig', '', 4),
  ('101151082', '玩机技巧', '11949238', 'contentBig', '大卡6', 'Adaptive', 'DK0001182', 'contentBig', '', 5),
  ('101151082', '玩机技巧', '11949229', 'contentBig', '大卡7', 'Adaptive', 'DK0001180', 'contentBig', '', 6),
  ('101151082', '玩机技巧', '11949230', 'contentBig', '大卡8', 'Adaptive', 'DK0001181', 'contentBig', '', 7),
  ('101151082', '玩机技巧', '11957002', 'contentBig', '大卡9', 'Adaptive', 'DK0001239', 'contentBig', '', 8),
  ('101151082', '玩机技巧', '11957003', 'contentBig', '大卡10', 'Adaptive', 'DK0001240', 'contentBig', '', 9);

INSERT INTO vmall_discover_items (page_id, tab_name, card_id, data_source_code, item_type, title, subtitle, author_name, image_url, link_url, content_id, content_type, product_name, product_price, like_count, view_count, sort_order) VALUES
  ('101151623', '\u53d1\u73b0', '11953663', 'DB070523', 'ad', '2026年6月25日发布会精彩回顾', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202606/e0c03ce9166d45139db6bd78270ce0e2.jpg', 'https://m.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101159753', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151623', '\u53d1\u73b0', '11953663', 'DB070523', 'ad', '华为学堂摄影课', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/b5bf9f50787b4e489b44ba25a33f71ac.jpg', 'https://m.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101158527', '', NULL, '', NULL, NULL, NULL, 1),
  ('101151623', '\u53d1\u73b0', '11953663', 'DB070523', 'ad', '26年最新国补使用攻略', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202606/ccd05d747a0f4ca3ac7de413b8ab7537.jpg', 'https://m.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101155321', '', NULL, '', NULL, NULL, NULL, 2),
  ('101151623', '\u53d1\u73b0', '11953663', 'DB070523', 'ad', '鸿蒙智行', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202606/a1b453a3ff354dffbfc01602977b43d8.jpg', 'https://m.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101156022', '', NULL, '', NULL, NULL, NULL, 3),
  ('101151080', '推荐', '12008220', 'DK0001199', 'content', '尊界 S800 Grand Design 典藏大观丨黛金相映，锦绣交辉', '远山青黛内藏浩瀚，旭日曜金万象生辉，于巅峰之境 ，遇锦绣之盛。', '鸿蒙智行', 'https://download-bds.vmall.com/irs/pgc/img/large/000000001d619e5effffffffd3e75570.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a3d1931d4b1e630a3c58a69', '6a3d1931d4b1e630a3c58a69', 2, '尊界 S800 Grand Design  典藏大观 新品关注', 0, 160, 26155, 0),
  ('101151080', '推荐', '11953096', 'DK0001200', 'content', '尊界 V800丨浩瀚格局，曜启天地', '以匠心大成，启豪华新章。', '鸿蒙智行', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffff81c7b77b000000006f009681.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a3d0ea0a8b8ecb43cab11c5', '6a3d0ea0a8b8ecb43cab11c5', 2, '尊界 V800丨V680 新品关注', 0, 68, 13261, 0),
  ('101151080', '推荐', '11953097', 'DK0001201', 'content', '华为Mate 80 Pro Max｜设计，从未如此出圈', '全金属设计，搭配光绘微纹，精雕细琢，质美双全。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/original/0000000027591809fffffffff74fe544.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=692556d2cdc9e60bd8c7701b', '692556d2cdc9e60bd8c7701b', 2, 'HUAWEI Mate 80 Pro Max', 7499, 894, 250134, 0),
  ('101151080', '推荐', '11953098', 'DK0001202', 'content', '华为Pura 90 Pro Max丨出发！一起去看橘子海', '把心情调成假日模式，与华为Pura 90 Pro Max 一起去看橘子海！', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffff8fe1a577000000002c76bd61.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69d85c42946288424a98ad67', '69d85c42946288424a98ad67', 2, 'HUAWEI Pura 90 Pro Max', 6499, 698, 174365, 0),
  ('101151080', '推荐', '11949205', 'DK0001157', 'content', '华为Mate X7｜焕新设计，云锦天章', '华为Mate X7探启新境。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/original/ffffffffe6be5fad00000000169fedc9.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69255bfc1c973b69832233a0', '69255bfc1c973b69832233a0', 2, 'HUAWEI Mate X7', 11999, 635, 161763, 0),
  ('101151080', '推荐', '11949207', 'DK0001159', 'content', '华为Pura 90 Pro丨元气色彩，揣进口袋', '华为Pura 90 Pro带来粉红芭乐、橘子汽水、椰青白、桑果黑四款假日特调配色。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/0000000004629d7dffffffff9e20ba13.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69d8b589219ba0c00e86bb7b', '69d8b589219ba0c00e86bb7b', 2, 'HUAWEI Pura 90 Pro', 5499, 294, 84877, 0),
  ('101151080', '推荐', '11949210', 'DK0001162', 'content', '华为畅享 90 Plus ｜纤薄出众，一眼心动', '三款经典配色，硬朗灵动兼备，多种场景都百搭。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffffabf5a036ffffffff9aad8e27.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69c0ee91337add0895a27481', '69c0ee91337add0895a27481', 2, '华为畅享 90 Plus', 1499, 290, 72089, 0),
  ('101151080', '推荐', '11949211', 'DK0001163', 'content', '华为Pura X Max｜双面阔屏，阔型登场', '阔折叠开创者，再创阔折叠！', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/000000003e28e060ffffffffc339d7e1.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69dc558570c0f125b3fe3c76', '69dc558570c0f125b3fe3c76', 2, 'HUAWEI Pura X Max', 10999, 262, 86034, 0),
  ('101151080', '推荐', '12010480', 'DK0001451', 'content', '华为FreeClip 2 典藏版 耳夹耳机丨鎏光璀璨，自成焦点', '全新设计风格，尽显优雅与深邃！', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/00000000337624000000000053f59401.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a1d4c894af03a7f8e44a91b', '6a1d4c894af03a7f8e44a91b', 2, 'HUAWEI FreeClip 2 典藏版', 1499, 133, 43309, 0),
  ('101151080', '推荐', '12011066', 'DK0001453', 'content', '华为MateBook 14 鸿蒙版丨鸿蒙小圆本超有AI', '波点键盘，尽显新锐本色，三色美学，一眼心动！', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffffdee3bf3b000000004711f5da.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69e5f93a52f5a33575bd6c33', '69e5f93a52f5a33575bd6c33', 2, 'HUAWEI MateBook 14 鸿蒙版', 6599, 54, 18950, 0),
  ('101151077', '发布会', '11963948', 'DB080622', 'content', '鸿蒙智行尊界品牌盛典发布会', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202606/ceefc5855df04238939036ed1fc64186.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a3e25ac9a5c44e7bccb4ec9', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '12010433', 'DB079073', 'content', 'nova 16系列及全场景新品发布会全程回顾', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202606/31e4c5d578f64f588cc044f8b560c3f4.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a1d896afc723a09ac288823', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '12004362', 'DB078705', 'content', '鸿蒙智行 智界 V9发布会全程回顾', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/1323bb767dd24688ad49d6d6e656df4e.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a07139e9f21c6e6ffb8fc34', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '12002201', 'DB077330', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/c10be6562498458b9014d5ede19eaf64.jpg', 'https://m.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101157370', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11994935', 'DB076401', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/07de1294f7e24db3a22d4337404a72e5.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69c2634a0f22a421727fb7b4', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11987816', 'DB075255', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/62041012edeb482e9856866bd75bd36c.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69a8f223f5dae0677a604b2b', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11981768', 'DB071713', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/3418dafea417467c9d12897ed148a249.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=694935d524d20e264d99f2f5', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953103', 'DB070701', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/60725f95b95542e3a36b169f1b3ac836.jpg', 'https://m.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101151720', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11954857', 'DB070472', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/58c4b2d359954a398fac2de4d8df3348.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69205983772da85e147c0c45', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953139', 'DB070423', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/57b307986a63404284cf37a352477643.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=68f8cb8f8978cf15423e2bad', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953104', 'DB070426', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/7bb812de34d543fcafb5a743cad4f69a.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=68d3bf2e40eabf0300d7c44e', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953105', 'DB070429', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/6fa6b321d6db484da262b80e634b87bb.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=68d3b21be15d2304ec43ec10', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953123', 'DB070432', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/a4bd09befdfa47f7aa95bd25ca5cddb7.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=68cab2d69888822f0f8f6842', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953124', 'DB070435', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/ba4dd22dd4384395aba31f1539e673c2.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=68b99f4f5568850ece248146', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953125', 'DB070438', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/1ec9f0d3de26497ab645f8d489006110.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=68ada7f90e66737ce2e69f9a', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953126', 'DB070441', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/617a1eafb3ff4bfb87352185b62e4c1b.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6881fbea089c37240a7f5e9d', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953127', 'DB070444', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/da687ab3136c401cbe324816cef37176.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=68554080514a56065131e0ba', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151077', '发布会', '11953128', 'DB070447', 'content', '1', '', '', 'https://res.vmallres.com/uomcdn/CN/cms/202605/1f87607b16194ef1ac44d66929819a00.jpg', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=684a6e867410964f8ecdbfb3', '', NULL, '', NULL, NULL, NULL, 0),
  ('101151081', '选购攻略', '11949216', 'DK0001203', 'content', '尊界 S800 Grand Design 典藏大观，全新感知系统，精准识别风险', '行业首创六激光雷达矩阵，复杂路况及时防御。', '鸿蒙智行', 'https://download-bds.vmall.com/irs/pgc/img/large/0000000070d7d991ffffffffd838fda5.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a3d269e9a5c44e7bccb4ebe', '6a3d269e9a5c44e7bccb4ebe', 2, '尊界 S800 Grand Design  典藏大观 新品关注', 0, 33, 4784, 0),
  ('101151081', '选购攻略', '11953141', 'DK0001204', 'content', '尊界 S800 Grand Design 典藏大观，精工皮纹繁而有序', '18处真木饰板以细木镶嵌工艺，超10道工序实现毫厘成画，超20道工序手工编织。', '鸿蒙智行', 'https://download-bds.vmall.com/irs/pgc/img/large/00000000153e4026ffffffff93a4726a.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a3d1cb29a5c44e7bccb4eba', '6a3d1cb29a5c44e7bccb4eba', 2, '尊界 S800 Grand Design  典藏大观 新品关注', 0, 37, 5041, 0),
  ('101151081', '选购攻略', '11953142', 'DK0001205', 'content', '华为Mate 80 Pro Max 风驰版搭载风驰散热架构，散热实力更进一步', '风驰电掣，冷静更出色，超性能体验由此开启！', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/000000006b1462220000000056454c93.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69c0e6f2cfd81b5c7c26128a', '69c0e6f2cfd81b5c7c26128a', 2, 'HUAWEI Mate 80 Pro Max 风驰版', 7999, 507, 122840, 0),
  ('101151081', '选购攻略', '11949217', 'DK0001166', 'content', '华为Pura 90 Pro Max 超大底2亿长焦，远近都有戏', '一次快门，万般精彩。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/000000001adb5be2ffffffffde66d0a4.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69e086d72e8a4303f97ea31e', '69e086d72e8a4303f97ea31e', 2, 'HUAWEI Pura 90 Pro Max', 6499, 188, 52075, 0),
  ('101151081', '选购攻略', '11949221', 'DK0001170', 'content', '华为畅享 90 Pro Max 搭载鸿蒙智慧通信，关键消息不错过', '畅快通信，弱网无忧。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/fffffffff775c64f000000005b6756aa.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69d5b040231a0008da804fe9', '69d5b040231a0008da804fe9', 2, '华为畅享 90 Pro Max', 1699, 100, 32323, 0),
  ('101151081', '选购攻略', '11949218', 'DK0001167', 'content', '华为FreeClip 2 典藏版 耳夹耳机，为你记录突发灵感，并按时播报', '日程随口记，灵感一念即成。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/0000000022f57a02000000002e851651.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6a291bc98f7e62269ab64fb7', '6a291bc98f7e62269ab64fb7', 2, 'HUAWEI FreeClip 2 典藏版', 1499, 73, 28391, 0),
  ('101151081', '选购攻略', '11949219', 'DK0001168', 'content', '华为Mate X7小艺慧记，展开听会议，自动帮你记', '小艺慧记支持AI实时录音转写，高效提炼会议重点，大屏AI轻松搞定。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/000000003c60364effffffffbddc1c2c.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=693254a6b1f7b91d8490a2eb', '693254a6b1f7b91d8490a2eb', 2, 'HUAWEI Mate X7', 11999, 35, 10557, 0),
  ('101151081', '选购攻略', '11949223', 'DK0001172', 'content', '华为Pura X Max AI灵感妙创，让奇思妙想轻松成真', '放飞想象，百般创意碰出彩。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/fffffffffd5aafd30000000017090d44.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69e5e5fd52f5a33575bd6c2f', '69e5e5fd52f5a33575bd6c2f', 2, 'HUAWEI Pura X Max', 10999, 15, 4652, 0),
  ('101151082', '玩机技巧', '11949224', 'DK0001174', 'content', '华为FreeClip 2 耳夹耳机使用指南：从佩戴、操控到保养，5分钟搞定', '想让耳夹耳机戴得舒服、用得方便？这些小技巧赶紧码住！', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffff9c4f5f46ffffffff9a2791ea.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6930e668a7b90406f436fba7', '6930e668a7b90406f436fba7', 2, 'HUAWEI FreeClip 2', 1299, 854, 243153, 0),
  ('101151082', '玩机技巧', '11949225', 'DK0001175', 'content', '华为Mate X7分屏联动，一键识屏，分屏显示', '华为Mate X7分屏联动，不用切换应用，生活工作更方便', '玩机技巧', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffffe0cabb2f000000000a8e5c1c.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=6937c12690dc7b05f960f02b', '6937c12690dc7b05f960f02b', 2, 'HUAWEI Mate X7', 11999, 579, 253523, 0),
  ('101151082', '玩机技巧', '11949226', 'DK0001176', 'content', '如何用华为Mate 80系列拍出电影级大片？看这条视频就够了', '灵活运用人像锁定追焦、虚化效果、多档防抖等模式，随手拍出电影级运镜大片！', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffffe6fddeca0000000073cfb700.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=693bc72948ba30654ccf89a9', '693bc72948ba30654ccf89a9', 2, 'HUAWEI Mate 80', 4699, 367, 100858, 0),
  ('101151082', '玩机技巧', '11949227', 'DK0001177', 'content', '启用华为Pura X Max的小艺伴随式AI，全程陪你理解屏幕内容', '默契相伴，主动为你。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffffba70b57b0000000011335cc7.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69ec2515c8ed71c4c9536809', '69ec2515c8ed71c4c9536809', 2, 'HUAWEI Pura X Max', 10999, 155, 71150, 0),
  ('101151082', '玩机技巧', '11949228', 'DK0001178', 'content', '华为Pura 90系列AI姿势推荐实时支招，让旅途的每个姿势都出片', '镜头一抬，姿势就来！ ', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffffdaae2c23ffffffffe4eb06f6.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69f1b36ce7ecbcd1bc097936', '69f1b36ce7ecbcd1bc097936', 2, 'HUAWEI Pura 90', 4699, 88, 36722, 0),
  ('101151082', '玩机技巧', '11949238', 'DK0001182', 'content', '华为Pura 90系列XMAGE智拍，姿势、构图智能加持，每一拍都出片', '灵感一现，大片即成。', '华为商城', 'https://download-bds.vmall.com/irs/pgc/img/large/0000000062f71b860000000079118cd5.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=69f1b57d98ff3b301b1e4598', '69f1b57d98ff3b301b1e4598', 2, 'HUAWEI Pura 90', 4699, 68, 35075, 0),
  ('101151082', '玩机技巧', '11949229', 'DK0001180', 'content', '华为Mate X6 小艺助手，大屏AI，帮你快速读透文档和资讯', '小艺文档资讯助手，帮你快速读透文档和资讯。', '玩机技巧', 'https://download-bds.vmall.com/irs/pgc/img/large/000000005d8f18d6000000002e7c2941.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=67501f546222bf43223a896c', '67501f546222bf43223a896c', 2, 'HUAWEI Mate X6', 9999, 35, 50676, 0),
  ('101151082', '玩机技巧', '11949230', 'DK0001181', 'content', '华为Mate XTs 非凡大师与手写笔搭配使用，给你带来高效体验', '1条视频带你了解华为Mate XTs 非凡大师与手写笔搭配使用技巧。', '玩机技巧', 'https://download-bds.vmall.com/irs/pgc/img/large/ffffffffb9aaa2eb000000006104c6d8.webp', 'https://m.vmall.com/portal/discover/index.html?targetRoute=ContentDiscovery&contentId=68c23f1f4909a67b3f9502b5', '68c23f1f4909a67b3f9502b5', 2, 'HUAWEI M-Pen 3', 599, 28, 12594, 0);

SET FOREIGN_KEY_CHECKS = 1;