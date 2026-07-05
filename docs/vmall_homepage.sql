CREATE TABLE IF NOT EXISTS vmall_homepage_products
(
    id          INT PRIMARY KEY,
    prd_id      VARCHAR(64),
    sbom_code   VARCHAR(64),
    name        VARCHAR(255),
    feature     TEXT,
    price       DECIMAL(12, 2) NULL,
    image_url   TEXT,
    product_url TEXT,
    raw_text    TEXT,
    scraped_at  DATETIME,
    UNIQUE KEY uk_vmall_prd (prd_id, sbom_code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS vmall_homepage_search_suggestions
(
    id         INT PRIMARY KEY,
    keyword    VARCHAR(255),
    scraped_at DATETIME
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS vmall_homepage_categories (
                                                         id INT AUTO_INCREMENT PRIMARY KEY,
                                                         category VARCHAR(128) NOT NULL COMMENT '一级分类，如：手机、穿戴',
                                                         `group` VARCHAR(128) NOT NULL COMMENT '二级分组，如：Mate 系列、WATCH GT 系列',
                                                         product_name VARCHAR(255) NOT NULL COMMENT '产品名称',
                                                         description VARCHAR(255) COMMENT '商品描述',
                                                         price DECIMAL(10, 2) COMMENT '商品价格（元）',
                                                         image_url VARCHAR(500) COMMENT '产品图片链接',
                                                         scraped_at DATETIME NOT NULL COMMENT '数据抓取时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE IF NOT EXISTS vmall_homepage_activities
(
    id           INT PRIMARY KEY,
    title        TEXT,
    activity_url TEXT,
    scraped_at   DATETIME
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4;


CREATE TABLE IF NOT EXISTS vmall_cart_items (
                                                id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '购物车项ID',

                                                user_id BIGINT NOT NULL COMMENT '用户ID',

                                                product_id BIGINT NULL COMMENT '商品ID，来源为数据库商品时保存对应ID',
                                                product_source VARCHAR(32) NOT NULL COMMENT '商品来源：home/category/homeStatic',
                                                product_name VARCHAR(255) NOT NULL COMMENT '商品名称',
                                                product_image VARCHAR(1000) NULL COMMENT '商品图片',
                                                product_price DECIMAL(10, 2) NOT NULL DEFAULT 0.00 COMMENT '商品价格',
                                                product_feature VARCHAR(1000) NULL COMMENT '商品描述',

                                                quantity INT NOT NULL DEFAULT 1 COMMENT '商品数量',
                                                selected TINYINT NOT NULL DEFAULT 1 COMMENT '是否选中：1选中，0未选中',

                                                created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                                updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

                                                UNIQUE KEY uk_user_product_source_id (user_id, product_source, product_id),
                                                KEY idx_cart_user_id (user_id),
                                                KEY idx_cart_selected (user_id, selected)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户购物车表';


INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (1, '10086724171251', NULL, NULL, NULL, NULL,
        'https://res.vmallres.com/uomcdn/CN/cms/202606/e3c4f0092a83449db98132f331e48f43.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086724171251', NULL, '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (2, '10086941643085', '2601010625815', 'nova 16 Pro', '2 亿红枫影像 | 麒麟9010S 芯片 | 7000 mAh 巨鲸电池', 3899,
        'https://res.vmallres.com/pimages/uomcdn/CN/cms/202605/e66d5b0128bc438290ce3f5165c0d2a0.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086941643085&sbomCode=2601010625815',
        'nova 16 Pro nova 16 Pro nova 16 Pro 2 亿红枫影像 | 麒麟9010S 芯片 | 7000 mAh 巨鲸电池 ¥3899',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (3, '10086907823195', '3102050085412', 'FreeClip 2',
        '全新 C 形桥 舒适稳固 | 澎湃双擎 智感聆听 | 鸿蒙 AI 耳边助手', 1249,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_667628D42EEE17D8B3CA468CC84497BC.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086907823195&sbomCode=3102050085412',
        'FreeClip 2 全新 C 形桥 舒适稳固 | 澎湃双擎 智感聆听 | 鸿蒙 AI 耳边助手 ¥1249', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (4, '10086772984616', NULL, NULL, NULL, NULL,
        'https://res.vmallres.com/uomcdn/CN/cms/202606/b3932f88a07d430f8d0bd7fa099f274e.jpg',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086772984616', NULL, '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (5, '10086001898792', '5008010055902', '尊界 S800 Grand Design 典藏大观',
        '于时代之巅 探无限可能！详情请咨询您的尊享顾问。', 1388000,
        'https://res.vmallres.com/pimages/FssCdnProxy/ms_car_uom/car/productManagement/428_428_B2C3104D1794C990ACFC0FFAF39F6FB4.png',
        'https://www.vmall.com/product/cardetail/index.html?prdId=10086001898792&sbomCode=5008010055902',
        '尊界 S800 Grand Design 典藏大观 于时代之巅 探无限可能！详情请咨询您的尊享顾问。 ¥1388000',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (6, '10086097339191', '2801010196903', 'MateBook 14 鸿蒙版',
        '2.8K OLED 触控屏 | 鸿蒙 AI 超能小艺 | 21 小时超长续航', 6199,
        'https://res.vmallres.com/pimages/uomcdn/CN/cms/202604/f76cba0579dd4e0d85372511afc9292b.jpg',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086097339191&sbomCode=2801010196903',
        'MateBook 14 鸿蒙版 MateBook 14 鸿蒙版 MateBook 14 鸿蒙版 2.8K OLED 触控屏 | 鸿蒙 AI 超能小艺 | 21 小时超长续航 ¥6199',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (7, '10086679107439', '3102060025003', 'Sound X5', '悦彰震撼听感 | 鸿蒙 AI 随时响应 | 多设备互联', 2199,
        'https://res.vmallres.com/pimages/uomcdn/CN/cms/202604/18367a90e8274106ad30546c36b85dd2.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086679107439&sbomCode=3102060025003',
        'Sound X5 Sound X5 Sound X5 悦彰震撼听感 | 鸿蒙 AI 随时响应 | 多设备互联 ¥2199', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (8, '10086329626373', '2701010122316', 'MatePad Air 12英寸 2025',
        '144 Hz 高刷高亮全面屏 | 鸿蒙 AI 潮流生产力 | 专业鸿蒙电脑软件生态', 2799,
        'https://res.vmallres.com/pimages/uomcdn/CN/cms/202512/669be602a5704d0dbe9625c1241d92ef.jpg',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086329626373&sbomCode=2701010122316',
        'MatePad Air 12英寸 2025 MatePad Air 12英寸 2025 MatePad Air 12英寸 2025 144 Hz 高刷高亮全面屏 | 鸿蒙 AI 潮流生产力 | 专业鸿蒙电脑软件生态 ¥2799',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (9, '10086252930264', '3301010099301', '华为Vision智慧屏 6 Pro',
        'Super MiniLED 黑晶屏 | 130 W 影院级音响 | 享免费安装', 6808,
        'https://res.vmallres.com/pimages/uomcdn/CN/cms/202604/d7911529155741f5bb2bfc0c4f566ef0.jpg',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086252930264&sbomCode=3301010099301',
        '华为Vision智慧屏 6 Pro 华为Vision智慧屏 6 Pro 华为Vision智慧屏 6 Pro Super MiniLED 黑晶屏 | 130 W 影院级音响 | 享免费安装 ¥6808',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (10, '10086761674807', '5008010055201', '尊界 V800', '参与盲订的用户支付尾款即可尊享 20000 元选配金专属权益',
        NULL, NULL, 'https://www.vmall.com/product/cardetail/index.html?prdId=10086761674807&sbomCode=5008010055201',
        '尊界 V800 尊界 V800 尊界 V800 参与盲订的用户支付尾款即可尊享 20000 元选配金专属权益',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (11, '10086832972917', '3001010071001', '华为凌霄子母路由 Q7 电线版', '全屋千兆免布线，插电就有高速网', 1219,
        NULL, 'https://www.vmall.com/product/comdetail/index.html?prdId=10086832972917&sbomCode=3001010071001',
        '华为凌霄子母路由 Q7 电线版 华为凌霄子母路由 Q7 电线版 华为凌霄子母路由 Q7 电线版 全屋千兆免布线，插电就有高速网 ¥1219',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (12, '10086478848011', '4405010029201', '华为智能门锁 M2', 'AI 指纹解锁 | 多重安全防护 | 18 个月长续航', 799,
        NULL, 'https://www.vmall.com/product/comdetail/index.html?prdId=10086478848011&sbomCode=4405010029201',
        '华为智能门锁 M2 华为智能门锁 M2 华为智能门锁 M2 AI 指纹解锁 | 多重安全防护 | 18 个月长续航 ¥799',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (13, '10086850799769', '2601010625916', 'nova 16', '后置红枫影像 | 麒麟9010S 芯片 | 7000 mAh 巨鲸电池', 2999,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8DF072FD771B9C8CDB7151498BDB790E.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086850799769&sbomCode=2601010625916',
        'nova 16 后置红枫影像 | 麒麟9010S 芯片 | 7000 mAh 巨鲸电池 ¥2999', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (14, '10086270081540', '2601010611525', '华为畅享 90 Pro Max', '8500 mAh 华为巨鲸大电池 | 支持 Wi-Fi 7', 1699,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_38BA83528B7548C8F0CD8FEBA437B491.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086270081540&sbomCode=2601010611525',
        '华为畅享 90 Pro Max 8500 mAh 华为巨鲸大电池 | 支持 Wi-Fi 7 ¥1699', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (15, '10086174757473', '2601010613211', '华为畅享 90', '麒麟 8 系芯片 超强性能 | 支持 Wi-Fi 7', 1599,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8D3D15B97667FAE0F74B8054B9B26677.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086174757473&sbomCode=2601010613211',
        '华为畅享 90 麒麟 8 系芯片 超强性能 | 支持 Wi-Fi 7 ¥1599', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (16, '10086838189168', '2601010588024', 'Mate X7', '超可靠折叠玄武架构 | 第二代红枫影像 | 鸿蒙大屏 AI 智能体',
        11999,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_162FFD53E0BD9BD021125F5296A50DC2.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086838189168&sbomCode=2601010588024',
        'Mate X7 超可靠折叠玄武架构 | 第二代红枫影像 | 鸿蒙大屏 AI 智能体 ¥11999', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (17, '10086352871370', '2601010599706', 'nova 15', '多焦段红枫影像 | 麒麟8020 芯片 | 鸿蒙 AI', 2899, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086352871370&sbomCode=2601010599706',
        'nova 15 多焦段红枫影像 | 麒麟8020 芯片 | 鸿蒙 AI ¥2899', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (18, '10086524794571', '2601010625712', 'nova 16 Ultra', '2 亿红枫影像 | 麒麟9010S 芯片 | 7000 mAh 巨鲸电池',
        4699, NULL, 'https://www.vmall.com/product/comdetail/index.html?prdId=10086524794571&sbomCode=2601010625712',
        'nova 16 Ultra 2 亿红枫影像 | 麒麟9010S 芯片 | 7000 mAh 巨鲸电池 ¥4699', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (19, '10086294960453', '2701010127941', 'MatePad 11.5 2026',
        '120 Hz 高刷全面屏 | 鸿蒙 AI 健康学习 | 10100 mAh 大电池', 1999,
        'https://res.vmallres.com/pimages/uomcdn/CN/cms/202512/cd431e5f8db34d46a0a94dc494358696.jpg',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086294960453&sbomCode=2701010127941',
        'MatePad 11.5 2026 MatePad 11.5 2026 MatePad 11.5 2026 120 Hz 高刷全面屏 | 鸿蒙 AI 健康学习 | 10100 mAh 大电池 ¥1999',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (20, '10086287244006', '2701010123219', 'MatePad Mini',
        '全网通通话 | 超轻薄设计 | 纸感阅读 支持全新 M-Pencil Pro 手写笔', 3299,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5B687D4EE52E998598944F3B0F9A4322.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086287244006&sbomCode=2701010123219',
        'MatePad Mini 全网通通话 | 超轻薄设计 | 纸感阅读 支持全新 M-Pencil Pro 手写笔 ¥3299', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (21, '10086518319242', '2701010122616', 'MatePad 11.5 S 2025', '144 Hz 高刷全面屏 | 华为笔记 | 鸿蒙 AI 高效学习',
        2199,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E9A180B112D5EC0CE88A7F6DB40ED494.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086518319242&sbomCode=2701010122616',
        'MatePad 11.5 S 2025 144 Hz 高刷全面屏 | 华为笔记 | 鸿蒙 AI 高效学习 ¥2199', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (22, '10086749578692', '2701010101902', 'MatePad SE 11', '高刷护眼全面屏 | 全金属一体机身 | HarmonyOS 4', 1399,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6FC0862A633927145A242ECF15AB5B63.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086749578692&sbomCode=2701010101902',
        'MatePad SE 11 高刷护眼全面屏 | 全金属一体机身 | HarmonyOS 4 ¥1399', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (23, '10086127502687', '2701010130502', 'MatePad Pro Max', '超轻超薄 | 鸿蒙专业生产力 | 音悦家 App', 5999,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_FA81548AAE165C4FF13D1F6E35D9F5C3.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086127502687&sbomCode=2701010130502',
        'MatePad Pro Max 超轻超薄 | 鸿蒙专业生产力 | 音悦家 App ¥5999', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (24, '10086590821009', '2701010126302', 'MatePad Edge',
        'X90 系列芯片首登平板 | 平板、电脑双模式 | 14.2 英寸鸿蒙二合一平板电脑', 5999, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086590821009&sbomCode=2701010126302',
        'MatePad Edge X90 系列芯片首登平板 | 平板、电脑双模式 | 14.2 英寸鸿蒙二合一平板电脑 ¥5999',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (25, '10086970913877', '2901010117102', 'WATCH 5', 'X-TAP 智感窗 | 腕上小艺 | 手势操控', 2099,
        'https://res.vmallres.com/pimages/uomcdn/CN/cms/202512/559bc3f6bfc04a54b96fb1f0dc6e496d.jpg',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086970913877&sbomCode=2901010117102',
        'WATCH 5 WATCH 5 WATCH 5 X-TAP 智感窗 | 腕上小艺 | 手势操控 ¥2099', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (26, '10086247988705', '2901030101501', '华为超新星手表 X1', '5 天关机定位 | 110° 超广角自拍 | 纯净社交', 1598,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B8E2A8DCE8829C3C7242D7AE50F25A66.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086247988705&sbomCode=2901030101501',
        '华为超新星手表 X1 5 天关机定位 | 110° 超广角自拍 | 纯净社交 ¥1598', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (27, '10086187155216', '2901010127501', 'WATCH ULTIMATE DESIGN 星钻绽放款',
        '华为首款珠宝智能腕表 | 99 颗天然钻石手工镶嵌 | X-TAP 智感窗', 29999,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AAFB1761022F1FDF8526142986FDE5BD.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086187155216&sbomCode=2901010127501',
        'WATCH ULTIMATE DESIGN 星钻绽放款 华为首款珠宝智能腕表 | 99 颗天然钻石手工镶嵌 | X-TAP 智感窗 ¥29999',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (28, '10086930244461', '2901010124703', 'WATCH ULTIMATE DESIGN 紫金款',
        '业界首创复合稀土紫色陶瓷表圈 | 星钻切割设计 古法黄金工艺 | 北斗卫星语音消息', 24999,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A700E2CA7F437A9338FB32C0ACD7BFE2.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086930244461&sbomCode=2901010124703',
        'WATCH ULTIMATE DESIGN 紫金款 业界首创复合稀土紫色陶瓷表圈 | 星钻切割设计 古法黄金工艺 | 北斗卫星语音消息 ¥24999',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (29, '10086275048704', '2901020058702', '华为手环 11 Pro',
        '1.62 英寸高亮大屏 | 独立 GNSS 五星定位 | 室外跑骑体验升级', 349,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C3EDD79503A39AAC0326FA1F05412A69.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086275048704&sbomCode=2901020058702',
        '华为手环 11 Pro 1.62 英寸高亮大屏 | 独立 GNSS 五星定位 | 室外跑骑体验升级 ¥349', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (30, '10086041056283', '2901010126704', 'WATCH GT Runner 2', '超精准定位 | 专业马拉松模式 | 超轻薄钛合金表体',
        2588, NULL, 'https://www.vmall.com/product/comdetail/index.html?prdId=10086041056283&sbomCode=2901010126704',
        'WATCH GT Runner 2 超精准定位 | 专业马拉松模式 | 超轻薄钛合金表体 ¥2588', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (31, '10086238406358', '2901020058601', '华为手环 11', '8.99 毫米超薄机身 | 专业睡眠健康监测 | 便捷生活助手',
        249, NULL, 'https://www.vmall.com/product/comdetail/index.html?prdId=10086238406358&sbomCode=2901020058601',
        '华为手环 11 8.99 毫米超薄机身 | 专业睡眠健康监测 | 便捷生活助手 ¥249', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (32, '10086428410583', '4602010018401', 'MateView GT 27英寸', '27 英寸全面屏 | 2K 200 Hz | 旋转升降支架', 999,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_244776E33CF924EAE70CFEA4A8C0D5F3.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086428410583&sbomCode=4602010018401',
        'MateView GT 27英寸 27 英寸全面屏 | 2K 200 Hz | 旋转升降支架 ¥999', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (33, '10086607543515', '3703010008009', '华为毕昇激光打印机 X1', '打印 复印 扫描 | 一碰打印 | 疾速配网', 1099,
        'https://res.vmallres.com/pimages/uomcdn/CN/pms/202408/gbom/6942103133749/428_428_9F368E737CEA9816C9DD51C62D95EDD1mp.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086607543515&sbomCode=3703010008009',
        '华为毕昇激光打印机 X1 打印 复印 扫描 | 一碰打印 | 疾速配网 ¥1099', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (34, '10086032697504', '2801010169429', 'MateBook D 14', '13 代酷睿处理器 | 14 英寸全面屏', 5999,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_96B1611F0FFB6C27E606296FF7BE2BBE.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086032697504&sbomCode=2801010169429',
        'MateBook D 14 13 代酷睿处理器 | 14 英寸全面屏 ¥5999', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (35, '10086690832694', '34020000517', 'MateView SE 23.8英寸', '90% P3 色域 | 100 Hz 高刷全面屏 | 电子书模式',
        519, NULL, 'https://www.vmall.com/product/comdetail/index.html?prdId=10086690832694&sbomCode=34020000517',
        'MateView SE 23.8英寸 90% P3 色域 | 100 Hz 高刷全面屏 | 电子书模式 ¥519', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (36, '10086627212823', '2801010174936', 'MateBook 14 酷睿 Ultra',
        '2.8K OLED 屏 | 轻薄机身 | 酷睿 Ultra 高性能处理器', 7199, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086627212823&sbomCode=2801010174936',
        'MateBook 14 酷睿 Ultra 2.8K OLED 屏 | 轻薄机身 | 酷睿 Ultra 高性能处理器 ¥7199', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (37, '10086702263930', '2801010187202', 'MateBook Pro', '鸿蒙 AI | 970 克超轻薄长续航 | 鸿蒙互联，手眼同行', 8999,
        NULL, 'https://www.vmall.com/product/comdetail/index.html?prdId=10086702263930&sbomCode=2801010187202',
        'MateBook Pro 鸿蒙 AI | 970 克超轻薄长续航 | 鸿蒙互联，手眼同行 ¥8999', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (38, '10086279570802', '3102050089601', 'FreeClip 2 典藏版', '鎏光宝盒 | AI 智能体 随问随记 | 云感 C 形桥', 1499,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_38958B79B83D41F10939810477BA23FC.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086279570802&sbomCode=3102050089601',
        'FreeClip 2 典藏版 鎏光宝盒 | AI 智能体 随问随记 | 云感 C 形桥 ¥1499', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (39, '10086787374428', '3102050084803', 'FreeBuds 7i', '智慧动态降噪 4.0 | 高清空间音频 | 鸿蒙智慧助手', 459,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_BDCF0C86FE7016E0EFAD7334A8B1C92C.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086787374428&sbomCode=3102050084803',
        'FreeBuds 7i 智慧动态降噪 4.0 | 高清空间音频 | 鸿蒙智慧助手 ¥459', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (40, '10086954112986', '3102050081302', 'FreeBuds 6', '超感知原声双单元 | 双向静谧通话 | 半开放舒适佩戴', 699,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D04DF3DACD678E3D49DF1E6ABF0E0A6B.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086954112986&sbomCode=3102050081302',
        'FreeBuds 6 超感知原声双单元 | 双向静谧通话 | 半开放舒适佩戴 ¥699', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (41, '10086533095852', '3102180007605', '华为智能眼镜 2', '全天候智慧播报 | 11 小时持久聆听 | 开放式聆听设计',
        1149, NULL, 'https://www.vmall.com/product/comdetail/index.html?prdId=10086533095852&sbomCode=3102180007605',
        '华为智能眼镜 2 全天候智慧播报 | 11 小时持久聆听 | 开放式聆听设计 ¥1149', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (42, '10086579314415', '3102050073201', 'FreeBuds 6i', '旗舰级降噪深度 | 智慧动态降噪 3.0 | 低音澎湃', 299, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086579314415&sbomCode=3102050073201',
        'FreeBuds 6i 旗舰级降噪深度 | 智慧动态降噪 3.0 | 低音澎湃 ¥299', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (43, '10086316021639', '3102180011101', '华为 AI 眼镜',
        '第一人称视角 超清晰 AI 闪拍 | 小艺看世界 | 全天候舒适佩戴', 2499, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086316021639&sbomCode=3102180011101',
        '华为 AI 眼镜 第一人称视角 超清晰 AI 闪拍 | 小艺看世界 | 全天候舒适佩戴 ¥2499', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (44, '10086896314296', '3301010094801', '华为Vision智慧屏 6 SE',
        'Super MiniLED 鸿鹄画质 | 288 Hz 流畅护眼 | 4K 超级投屏', 3149,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_35A4A66188B9B6ADFEE8427A5027885F.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086896314296&sbomCode=3301010094801',
        '华为Vision智慧屏 6 SE Super MiniLED 鸿鹄画质 | 288 Hz 流畅护眼 | 4K 超级投屏 ¥3149', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (45, '10086098826302', '4405010024201', '华为智能门锁 2 Pro',
        'AI 3D 人脸识别 3.0 | AI 掌静脉解锁 | 超清猫眼远程对讲', 2899,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_483979FC1D6F3A6CB4F8AC0DC9836631.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086098826302&sbomCode=4405010024201',
        '华为智能门锁 2 Pro AI 3D 人脸识别 3.0 | AI 掌静脉解锁 | 超清猫眼远程对讲 ¥2899', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (46, '10086199300779', '3001010071301', '华为路由 AX3 Pro 悦享版',
        'Wi-Fi 6+ 3000 Mbps | 4 颗独立信号放大器 | 智能手游加速', 219,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F265DFDDA7BFBAF06E271FA2C970E70F.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086199300779&sbomCode=3001010071301',
        '华为路由 AX3 Pro 悦享版 Wi-Fi 6+ 3000 Mbps | 4 颗独立信号放大器 | 智能手游加速 ¥219',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (47, '10086194440412', '4405010028901', '华为智能门锁 2 尊享版',
        'AI 掌静脉解锁 | 超清猫眼远程对讲 | IPX5 级生活防水', 2799, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086194440412&sbomCode=4405010028901',
        '华为智能门锁 2 尊享版 AI 掌静脉解锁 | 超清猫眼远程对讲 | IPX5 级生活防水 ¥2799', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (48, '10086052632479', '3301010097601', '华为智慧屏 S7 Pro',
        '低反护眼黑晶屏 | 鸿蒙 AI 小艺搜片看球 | 搭配华为灵犀手写笔随心写画', 7999, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086052632479&sbomCode=3301010097601',
        '华为智慧屏 S7 Pro 低反护眼黑晶屏 | 鸿蒙 AI 小艺搜片看球 | 搭配华为灵犀手写笔随心写画 ¥7999',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (49, '10086008427264', '3102010029903', '华为自带线全能充移动电源（100 W 12000）',
        '100 W 高功率超级快充 | 旗舰手机高品质电芯 | 超耐用自带线', 359,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C6199FDBBE116F6707300DF633243B69.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086008427264&sbomCode=3102010029903',
        '华为自带线全能充移动电源（100 W 12000） 100 W 高功率超级快充 | 旗舰手机高品质电芯 | 超耐用自带线 ¥359',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (50, '10086393994098', '3102030014001', '华为 6A 数据线 USB-A 转 USB-C', '支持 6A 大电流', 39,
        'https://res.vmallres.com/pimages/product/6941487201174/428_428_90FB236AE9C3AA78A44B062D6469D68D9CACD0D0A2F1B2BCmp.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086393994098&sbomCode=3102030014001',
        '华为 6A 数据线 USB-A 转 USB-C 支持 6A 大电流 ¥39', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (51, '10086826293656', '3102020059201', '华为全能充多口充电器（Max 100 W）',
        '100 W 大功率 | 双口功率动态分配 | 可折叠插脚', 229,
        'https://res.vmallres.com/pimages/uomcdn/CN/pms/202408/gbom/6942103127588/428_428_905BDF880F44A3C203B544D24005BAF8mp.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086826293656&sbomCode=3102020059201',
        '华为全能充多口充电器（Max 100 W） 100 W 大功率 | 双口功率动态分配 | 可折叠插脚 ¥229', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (52, '10086100136965', '3102010030701', '华为自带线全能充移动电源（66 W 12000）', '双向 66 W 超级快充', 289,
        'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_30CCA874B76F1E356154291301DDD553.png',
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086100136965&sbomCode=3102010030701',
        '华为自带线全能充移动电源（66 W 12000） 双向 66 W 超级快充 ¥289', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (53, '10086826276433', '3102020067001', '华为冰糖全能充电器（Max 100 W）', 'CCC认证', 209, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086826276433&sbomCode=3102020067001',
        '华为冰糖全能充电器（Max 100 W） CCC认证 ¥209', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (54, '10086167840443', '3105030004201', 'M-Pencil（第三代）平板创作笔套装', '专业写绘', 449, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086167840443&sbomCode=3105030004201',
        'M-Pencil（第三代）平板创作笔套装 专业写绘 ¥449', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (55, '10086739052336', '3102030017405', '华为 6A 数据线 USB-C 转 USB-C',
        '适用设备：华为手机/平板/笔记本/耳机等设备', 49, NULL,
        'https://www.vmall.com/product/comdetail/index.html?prdId=10086739052336&sbomCode=3102030017405',
        '华为 6A 数据线 USB-C 转 USB-C 适用设备：华为手机/平板/笔记本/耳机等设备 ¥49', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (56, '10086619397175', '5008010054302', '尚界 H5', '即刻下定可享多重购车权益', 179800,
        'https://res.vmallres.com/pimages/FssCdnProxy/ms_car_uom/car/productManagement/428_428_CA18171898688E7A4F9DE681C16398AB.png',
        'https://www.vmall.com/product/cardetail/index.html?prdId=10086619397175&sbomCode=5008010054302',
        '尚界 H5 即刻下定可享多重购车权益 ¥179800', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (57, '10086750775622', '5008010053401', '问界 M9', '即刻下定可享多重购车权益', 489800,
        'https://res.vmallres.com/pimages/FssCdnProxy/ms_car_uom/car/productManagement/428_428_C69771034327BA0D097654D26CAF0550.jpg',
        'https://www.vmall.com/product/cardetail/index.html?prdId=10086750775622&sbomCode=5008010053401',
        '问界 M9 即刻下定可享多重购车权益 ¥489800', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (58, '10086955402407', '5008010051001', '尚界 Z7', '即刻下定可享多重购车权益', 219800,
        'https://res.vmallres.com/pimages/FssCdnProxy/ms_car_uom/car/productManagement/428_428_499BBD710F01982115F04AD54D7175F1.png',
        'https://www.vmall.com/product/cardetail/index.html?prdId=10086955402407&sbomCode=5008010051001',
        '尚界 Z7 即刻下定可享多重购车权益 ¥219800', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (59, '10086361628309', '5008010051102', '尚界 Z7T', '即刻下定可享多重购车权益', 259800, NULL,
        'https://www.vmall.com/product/cardetail/index.html?prdId=10086361628309&sbomCode=5008010051102',
        '尚界 Z7T 即刻下定可享多重购车权益 ¥259800', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (60, '10086815751821', '5008010052604', '智界 V9', '即刻下定可享至高56500元购车权益', 519800, NULL,
        'https://www.vmall.com/product/cardetail/index.html?prdId=10086815751821&sbomCode=5008010052604',
        '智界 V9 即刻下定可享至高56500元购车权益 ¥519800', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_products (id, prd_id, sbom_code, name, feature, price, image_url, product_url, raw_text,
                                     scraped_at)
VALUES (61, '10086418750197', '5008010048104', '享界 S9', '即刻下定可享多重购车权益', 319800, NULL,
        'https://www.vmall.com/product/cardetail/index.html?prdId=10086418750197&sbomCode=5008010048104',
        '享界 S9 即刻下定可享多重购车权益 ¥319800', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE name=VALUES(name),
                        feature=VALUES(feature),
                        price=VALUES(price),
                        image_url=VALUES(image_url),
                        product_url=VALUES(product_url),
                        raw_text=VALUES(raw_text),
                        scraped_at=VALUES(scraped_at);

INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (1, '智慧屏', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (2, '路由存储', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (3, '华为服务', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (4, '华为手机', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (5, 'MateBook 14 鸿蒙版', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (6, 'Sound X5', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (7, 'MatePad Air 12英寸 2025', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (8, '华为Vision智慧屏 6 Pro', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (9, '华为凌霄子母路由 Q7 电线版', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (10, '华为智能门锁 M2', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (11, 'nova 16 Pro', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (12, 'nova 16', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (13, '华为畅享 90 Pro Max', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (14, '8500 mAh 华为巨鲸大电池', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (15, '华为畅享 90', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (16, 'Mate X7', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (17, 'nova 15', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (18, 'nova 16 Ultra', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (19, 'MatePad 11.5 2026', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (20, 'MatePad Mini', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (21, 'MatePad 11.5 S 2025', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (22, '华为笔记', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (23, 'MatePad SE 11', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (24, 'MatePad Pro Max', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (25, 'MatePad Edge', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (26, 'WATCH 5', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (27, '华为超新星手表 X1', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (28, 'WATCH ULTIMATE DESIGN 星钻绽放款', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (29, '华为首款珠宝智能腕表', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (30, 'WATCH ULTIMATE DESIGN 紫金款', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (31, '华为手环 11 Pro', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (32, 'WATCH GT Runner 2', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (33, '华为手环 11', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (34, 'MateView GT 27英寸', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (35, '华为毕昇激光打印机 X1', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (36, 'MateBook D 14', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (37, 'MateView SE 23.8英寸', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (38, 'MateBook 14 酷睿 Ultra', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (39, 'MateBook Pro', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (40, 'FreeClip 2', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (41, 'FreeClip 2 典藏版', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (42, '华为智能眼镜 2', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (43, '华为 AI 眼镜', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (44, '华为Vision智慧屏 6 SE', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (45, '华为智能门锁 2 Pro', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (46, '华为路由 AX3 Pro 悦享版', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (47, '华为智能门锁 2 尊享版', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (48, '华为智慧屏 S7 Pro', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (49, '搭配华为灵犀手写笔随心写画', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (50, '华为自带线全能充移动电源（100 W 12000）', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (51, '华为 6A 数据线 USB-A 转 USB-C', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (52, '华为全能充多口充电器（Max 100 W）', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (53, '华为自带线全能充移动电源（66 W 12000）', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (54, '华为冰糖全能充电器（Max 100 W）', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (55, '华为 6A 数据线 USB-C 转 USB-C', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_search_suggestions (id, keyword, scraped_at)
VALUES (56, '适用设备：华为手机/平板/笔记本/耳机等设备', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE keyword=VALUES(keyword),
                        scraped_at=VALUES(scraped_at);

-- =====================================================
-- 新品分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('新品', '手机新品', 'nova 16 Ultra', '超薄直屏设计，全能影像旗舰', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_050E117A800169E8C30565E6E43C07C9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '手机新品', 'nova 16 Pro', '专业人像摄影，潮美新拍档', 3699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5A7496B6D3DCD8EBEE48526EEE218591.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '手机新品', 'nova 16', '时尚轻薄机身，鸿蒙智慧体验', 2899.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8DF072FD771B9C8CDB7151498BDB790E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '手机新品', 'nova 16z', '千元价位段，实力均衡之选', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_2A62069271769EF152C076C2B4198DBE.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '手机新品', 'Pura X Max', '阔折叠屏手机，沉浸大屏体验', 9999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A9CEA9A28A9060FDE3ABB05B6E16681F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '手机新品', 'Pura 90 Pro Max', '超聚光影像旗舰，巅峰设计', 10999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5C9316F0B18D28A6532AF0B4703AB166.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '手机新品', 'Pura 90 Pro', '专业影像与时尚设计的完美融合', 8999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D8ED42C1C8C0634398A16DC14F74EE87.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '手机新品', 'Pura 90', '全能影像实力派，鸿蒙旗舰', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_0FC1BBDBAE15CDD0E0B55AA0E69A3E1D.png', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '穿戴新品', '非凡大师 尊界定制款', '奢华材质，尊贵定制服务', 21999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A700E2CA7F437A9338FB32C0ACD7BFE2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '穿戴新品', 'WATCH GT Runner 2', '专业跑步伴侣，科学运动指导', 2499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D8D0E17979F8DBB4E378C716CE6B13D8.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '穿戴新品', '非凡大师 星钻绽放款', '镶钻设计，璀璨夺目，极致奢华', 18999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AAFB1761022F1FDF8526142986FDE5BD.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '穿戴新品', 'WATCH FIT 5 Pro', '方屏时尚，智能健康管理', 1599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_66B24EA82C0CC387673A1547EDAA5EEA.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '穿戴新品', 'WATCH FIT 5', '轻薄时尚，全天候健康监测', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1BCE6003D8E0046B10CF4FE336CF1BFF.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '穿戴新品', '华为超新星手表 X1 Pro', '儿童智能手表，安全守护升级', 1499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E95FC11CE8ADA233257D141CD3EA031F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '穿戴新品', '华为超新星手表 X1', '儿童成长陪伴，安全定位精准', 999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B8E2A8DCE8829C3C7242D7AE50F25A66.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '穿戴新品', 'WATCH Buds 2', '智能手表与耳机二合一创新设计', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4502D42E0DF4CA20B23D7543D0E745E5.png', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '平板新品', 'MatePad Pro Max', '13.2英寸巨幕，鸿蒙专业创作平台', 8999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/d30dca2ab41d4e94b2428a1839a5e48f.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '笔记本新品', 'MateBook 14 鸿蒙版', '搭载鸿蒙OS，全场景智慧互联体验', 6999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/4051560ba7be4fae8283415a3a83d5a3.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '耳机音箱新品', 'FreeArc 耳挂耳机', '耳挂式开放设计，舒适稳固佩戴', 899.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6D0207E0DAB35A3D2E04615257B825D4.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '耳机音箱新品', 'FreeClip 2 典藏版', '耳夹式设计，时尚典雅，音质出色', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_38958B79B83D41F10939810477BA23FC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '耳机音箱新品', 'FreeBuds SE 4 ANC', '主动降噪，续航持久，性价比之选', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_7C7C92DC00E66B7CBD2B5239E556EC35.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '耳机音箱新品', 'Sound X5', '旗舰智能音箱，澎湃音质，鸿蒙加持', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B6B421462B9D1070D7344999E0B64A37.png', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '智能眼镜新品', '华为 AI 眼镜 钛银灰 钛丝方形半框光学镜', 'AI智能助手，时尚钛丝半框设计', 2499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_29530622CD4D55F4FCA0D843FC00BDB2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '智能眼镜新品', '华为 AI 眼镜 钛银灰 钛丝半框光学镜', '轻量化钛丝镜架，智能交互体验', 2399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_14C31E260A159143792FD77DC81E5D90.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '智能眼镜新品', '华为 AI 眼镜 摩登黑 经典全框光学镜', '经典全框设计，AI智慧生活助手', 2299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E6D54F2AA3125491BF80569D7F352F9D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '智能眼镜新品', '华为 AI 眼镜 流光银 经典全框太阳镜', '流光银配色，智能太阳镜二合一', 2499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_219A4DE3BF9FE234B4767D1BB7158ACD.png', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '智慧屏新品', '华为智慧屏 S7X Pro', '极致画质，旗舰音效，智慧交互', 15999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_87D9DFC251CA8905C55C17EB8B61E1A0.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '智慧屏新品', '华为Vision智慧屏 6 Pro', '鸿蒙AI，影院级视听享受', 8999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D56C910A77D0DE230D69ED72626C0B9B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '智慧屏新品', '华为智慧屏 S7', '智慧娱乐中心，AI健身与观影', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_65B26271D4CCC1AFFF9DC923AF2B195F.png', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '智能门锁新品', '华为智能门锁 M2', 'AI 3D人脸识别，金融级安全守护', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_97B868561F9980C911B0A76CFFB87971.png', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '路由存储新品', '华为凌霄子母路由 Q7 电线版', '电力线组网，全屋Wi-Fi覆盖', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_04AEE26C5DCF3B980C51862E4592C949.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '路由存储新品', '华为路由 AX3 Pro 悦享版', 'Wi-Fi 6+，高速稳定，悦享版', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F265DFDDA7BFBAF06E271FA2C970E70F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '路由存储新品', '华为路由 X1 Pro 电竞涂装版', 'Wi-Fi 7，电竞级低延迟，专属涂装', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1D9469A090C6EB24B4F24D9352DC7881.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '路由存储新品', '华为家庭存储 有盘版', '家庭数据存储中心，手机秒变16TB', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A242DB1AD14187786D7538BC0088B88E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '路由存储新品', '华为路由 X3 Pro 日照金山', '创新设计，稳定高速网络覆盖', 1099.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_01F7AE3F62201DCE7402790BD96D3407.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '路由存储新品', '华为随行WiFi X', '5G移动路由，高速网络随身行', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4E526198E29FD2D3C03A71CBCB59D4F7.png', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '鸿蒙智行新品', '尊界 S800 Grand Design 典藏大观', '尊界旗舰，极致奢华定制版', 1680000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/8077b1b7847b41658b5f90d272b16613.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '尊界 V800', '大型旗舰SUV，鸿蒙智行科技', 1380000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/81430a66db4544e1878e60ebd1b8aabb.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '尊界 V680', '中大型豪华SUV，智能驾驭', 980000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/af329901428c436ab40f82a20937370b.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '尊界 S800', '旗舰级智能轿车，鸿蒙智行标杆', 1280000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/c81396ff4e414785965cee129bc3aced.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '尚界 H5', '新生代智能轿车，年轻活力', 189800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/fdda5edf4b98438d944b1b3dbcc15797.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '问界 M6', '中型SUV，智能驾驶新选择', 259800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/bddaa909c7dd40509dc22895778044e7.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '问界 M9', '大型旗舰SUV，全场景智慧出行', 468000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/c8aacdbd381e482c923b791933396291.jpg', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '问界 M9 Ultimate 领世加长版', '旗舰加长版，极致豪华空间', 598000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/8296734ee57c43a581b2a9d6bf36acc2.jpg', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '智界 V9', '大型智能MPV，全家出行首选', 429800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/1849d22a148d48dfa3da1067d9c7cef6.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '尚界 Z7', '年轻时尚SUV，智能科技赋能', 229800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/9b241e4f8cd041c3817923695d3216ca.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '鸿蒙智行新品', '尚界 Z7T', '运动轿跑SUV，动态操控出色', 259800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/f3f7c47f3f37478989b1e24f406ebf03.png', '2026-06-30 06:53:01'),

                                                                                                                       ('新品', '配件新品', '华为超级快充充电器（Max 40 W）', '40W快充，安全高效充电体验', 129.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_62806B64B102037DF4FD3FA3D6EAE3AA.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '配件新品', '华为冰糖全能充电器（Max 66 W）', '66W全能快充，兼容多种设备', 199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_BD09AF9DEFA9AFCDF2CBCC2ACD3FF450.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '配件新品', '华为冰糖全能充电器（Max 100 W）', '100W超级快充，笔记本也能充', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D5D765E8D450A824FFD9AB6BAD0BB1FD.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '配件新品', '华为无线鼠标 3', '轻盈便携，精准操控，续航长久', 199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_BBF2547ABE9D0D9B7B2B947356EA80C5.png', '2026-06-30 06:53:01'),
                                                                                                                       ('新品', '配件新品', '华为无线鼠标 Slim 标准版', '超薄设计，舒适握感，高效办公', 169.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D3E1AF680B2C5E53B16C0DC269F9F713.png', '2026-06-30 06:53:01');

-- =====================================================
-- 手机分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('手机', 'Mate 系列', 'Mate X7', '新一代折叠旗舰，超凡视界体验', 14999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_162FFD53E0BD9BD021125F5296A50DC2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 80 RS 非凡大师', '奢华设计，非凡大师系列旗舰', 12999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C42771B009616C47F5D965927253D340.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 80 Pro Max', '超大杯旗舰，全能影像与性能', 9999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_9D125D90A8F10EF912F1712EFC470003.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 80 Pro Max 风驰版', '极速性能，风驰电掣，旗舰体验', 10999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_79C320BD140467361E32DCE7A68DC2E5.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 80 Pro', '专业影像与商务效率的完美结合', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_00ADDBB12522603D4B061E09B32ED29B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 80', '旗舰级均衡体验，商务首选', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_91223532B551EF92371D1E30D502A880.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate XTs 非凡大师', '折叠屏非凡大师，极致奢华体验', 15999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AA57970C1D3F3CA269822ED70A7132A7.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate X6', '折叠屏旗舰，轻薄与性能兼得', 13999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202507/1fa9835d4e06484dbec497de93053987.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 70 Pro+', '旗舰性能，影像系统全面升级', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6DEFA8E52CD749385860692A24DA15B9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 70 Pro', '全能旗舰，均衡实力派', 6499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_13AC0AD8717DEB5444437B46A2CF48E3.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 70 Pro 优享版', '旗舰配置，优享价格，性价比之选', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_03A6705E37EF11DBC221E8AD082B08CB.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Mate 系列', 'Mate 70 Air', '轻薄时尚设计，旗舰级体验', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_64C58FB8D8288D251CB84FEF30871DF0.png', '2026-06-30 06:53:01'),

                                                                                                                       ('手机', 'Pura 系列', 'Pura 90 Pro Max', '超聚光影像旗舰，巅峰设计', 10999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5C9316F0B18D28A6532AF0B4703AB166.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Pura 系列', 'Pura 90 Pro', '专业影像与时尚设计的完美融合', 8999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D8ED42C1C8C0634398A16DC14F74EE87.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Pura 系列', 'Pura 90', '全能影像实力派，鸿蒙旗舰', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_0FC1BBDBAE15CDD0E0B55AA0E69A3E1D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Pura 系列', 'Pura X Max', '阔折叠屏手机，沉浸大屏体验', 9999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A9CEA9A28A9060FDE3ABB05B6E16681F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Pura 系列', 'Pura 80 Ultra', '极致影像，旗舰之巅', 11999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_CF89A2B4E1BB0B768FC2B9FB2B01CB51.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Pura 系列', 'Pura 80 Pro+', '专业影像+，全面升级', 8999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E4926BAE4D357C1B28F9237B66E20D68.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Pura 系列', 'Pura 80 Pro', '全能影像，专业表现', 7499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_820F8778FD0563E614A0A5A0488E5799.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Pura 系列', 'Pura 80', '影像新标杆，实力首选', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E9E58AA2968F8D3C164B1C06F12EE7D2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'Pura 系列', 'Pura X', '阔折叠设计，创新交互体验', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_403667AF44C4A835F8F9A1A5417B01EA.png', '2026-06-30 06:53:01'),

                                                                                                                       ('手机', 'nova 系列', 'nova 16 Ultra', '超薄直屏设计，全能影像旗舰', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_050E117A800169E8C30565E6E43C07C9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'nova 系列', 'nova 16 Pro', '专业人像摄影，潮美新拍档', 3699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5A7496B6D3DCD8EBEE48526EEE218591.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'nova 系列', 'nova 16', '时尚轻薄机身，鸿蒙智慧体验', 2899.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8DF072FD771B9C8CDB7151498BDB790E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'nova 系列', 'nova 16z', '千元价位段，实力均衡之选', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_2A62069271769EF152C076C2B4198DBE.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'nova 系列', 'nova 15 Ultra', '全能影像，时尚旗舰', 4699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_57024E8B5100918A23ED23DAE1A82E24.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'nova 系列', 'nova 15 Pro', '人像摄影大师，潮流新选', 3499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_2BEFC88EE25B9E643FFC371701115502.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'nova 系列', 'nova 15', '轻薄时尚，日常使用优选', 2699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6CD3E431FC25E1DB3DA86333D1B45847.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'nova 系列', 'nova 14 Ultra', '影像实力派，鸿蒙智慧体验', 4499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_CC7415ABB6DC59AD99F50081CD016410.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', 'nova 系列', 'nova 14 活力版', '活力设计，年轻潮流之选', 2399.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/842d518a42f349eca5dfd96c13697f6d.png', '2026-06-30 06:53:01'),

                                                                                                                       ('手机', '华为畅享系列', '华为畅享 90 Pro Max', '大屏长续航，畅享体验升级', 2599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_EAC757A4AF3116C840A2073614CDFF6C.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为畅享系列', '华为畅享 90 Plus', '大屏大电量，畅快娱乐体验', 2199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8D1306E445EE23D1FB7960FE5E9D247C.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为畅享系列', '华为畅享 90', '千元价位，日常使用好选择', 1799.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8D3D15B97667FAE0F74B8054B9B26677.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为畅享系列', '华为畅享 70X 尊享版', '续航王者，尊享体验再升级', 1499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_840ACF79CA46AEEEC8730992DD05616A.png', '2026-06-30 06:53:01'),

                                                                                                                       ('手机', '华为官方翻新', 'Pocket 2 优享版', '官方翻新，品质保障，折叠美学', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_FE1BB92B100A9D2BD96FCFAE8F654ACC.jpg', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为官方翻新', 'Mate XT 非凡大师', '官方认证翻新，极致性价比', 13999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_269ACDB8721BBBD9EF3EA1F5ADA3EEC4.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为官方翻新', 'Mate X6', '折叠屏旗舰翻新，品质如新', 11999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_DDCE98439EDA2332DB18560C8A6A6326.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为官方翻新', 'Mate X5', '官方翻新，折叠体验依旧出色', 9999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6123841F607BF4141CB31AF42835BB66.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为官方翻新', 'Mate 70 RS 非凡大师', '非凡大师翻新，奢华不减', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_0B15598BC00DCBE4C2F94FED46F8D0C2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为官方翻新', 'Mate 70', '官方翻新，旗舰品质超值之选', 5499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_77A02278A70F11ACB1CF00BEF2792CAE.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为官方翻新', 'Pura 70 Pro+', '官方翻新，影像旗舰性价比之选', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_63DB5B7E5CCD2E04977DED7C342D1CC7.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '华为官方翻新', 'Pura 70', '官方认证翻新，品质无忧', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_67695C16080490550A6E958BF6BBCB42.png', '2026-06-30 06:53:01'),

                                                                                                                       ('手机', '智选手机', 'WIKO X70', '华为智选，性价比优选', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_2676ACB5A5B58C68FEB9BC55AED92275.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '智选手机', 'Hi 畅享 80 Pro', '智选手机，畅快体验更进一步', 2499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1DB5885D65CCD7BDE533F769C97AFBFF.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '智选手机', '麦芒40 5G', '智选系列，5G高速体验', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_0F5C06750A88BB5CB8B6CFF0CF7D5F92.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '智选手机', 'Hi 畅享 80', '智选新机，超值之选', 1599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1916CDC0F3047A22AA010EBD73518B07.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '智选手机', 'Hi 畅享 80S', '智选升级，畅享新体验', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5FF452100E15C1AF8C9A6B3A8188D0EF.png', '2026-06-30 06:53:01'),

                                                                                                                       ('手机', '配件周边', '手机壳/套', '多种款式，全面保护您的手机', 49.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/EC00932887DA1C83DC5738332C8F6AF4.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', '手机膜', '高清透亮，有效防刮防摔', 29.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/70DCA579D32E04D9CD87989C0191662D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', '手机充电器/数据线', '原装品质，快速充电数据传输', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/50B27B04F45EF29593C9DADDCA863B6F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', '手机支架', '稳固支撑，释放双手便捷观影', 39.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/CF6CBA0E26AE32D7DE27E0413E6881C3.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', '手机云台', '智能防抖，拍摄稳定更清晰', 599.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/9198B4FC4A3D1BB885B356E3E08D989F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', '移动电源', '大容量快充，随时续航无忧', 169.00, 'https://res.vmallres.com/uomcdn/CN/cms/202512/4c6fff8ec6464f1c8ca7c3831fcb8fb3.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', 'Tag 防丢精灵', '小巧防丢器，查找物品好帮手', 99.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_565D0ABC77171672227A74B5209494FB.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', 'M-Pen 3', '精准书写，细腻绘画体验', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_76EB0F6C7F9EB71AE2D8D2B9555367F9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', 'M-Pen 3 笔尖', '原装替换笔尖，持久精准书写', 39.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_FDE4198FF76C1CBCCFD787081399F366.png', '2026-06-30 06:53:01'),
                                                                                                                       ('手机', '配件周边', '华为手写笔收纳套', '便捷收纳，保护手写笔安全', 29.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C06AEA03173A07876BEBA0558371D3DE.png', '2026-06-30 06:53:01');

-- =====================================================
-- 穿戴分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('穿戴', 'WATCH Ultimate 系列', '非凡大师 尊界定制款', '奢华材质，尊贵定制服务', 21999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A700E2CA7F437A9338FB32C0ACD7BFE2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH Ultimate 系列', '非凡大师 星钻绽放款', '镶钻设计，璀璨夺目，极致奢华', 18999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AAFB1761022F1FDF8526142986FDE5BD.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH Ultimate 系列', 'WATCH Ultimate 2 非凡探索', '专业户外探索，极致运动体验', 9999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_9A65E63CB09D273F7C620620C06BAFD5.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH Ultimate 系列', '非凡大师 蓝宝石黄金款', '蓝宝石表镜，黄金表圈，极致奢华', 29999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_34A6A502DCBF70CFE351C9CCB39EA3F3.png', '2026-06-30 06:53:01'),

                                                                                                                       ('穿戴', 'WATCH 系列', 'WATCH Buds 2', '智能手表与耳机二合一创新设计', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4502D42E0DF4CA20B23D7543D0E745E5.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH 系列', 'WATCH 5 46mm', '经典圆形表盘，健康管理全面', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_9043E5A89FE792990783C26085B1012F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH 系列', 'WATCH 5 42mm', '精致小巧，适合优雅佩戴', 3699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1DF7063BA73B72B93BAB792928EEB6A3.png', '2026-06-30 06:53:01'),

                                                                                                                       ('穿戴', 'WATCH GT 系列', 'WATCH GT Runner 2', '专业跑步伴侣，科学运动指导', 2499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D8D0E17979F8DBB4E378C716CE6B13D8.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH GT 系列', 'WATCH GT 6 Pro', '专业运动旗舰，超长续航表现', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6056BC862F8F7936BF7E6B49D79BDACD.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH GT 系列', 'WATCH GT 6 46mm', '大屏运动手表，数据一目了然', 2199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_3EDD73AC337BB6764D68B21BA9DDF2B1.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH GT 系列', 'WATCH GT 6 41mm', '小表盘运动手表，精致轻便', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B6563E16A22FD3AEF60D57DCA8A2C935.png', '2026-06-30 06:53:01'),

                                                                                                                       ('穿戴', 'WATCH FIT 系列', 'WATCH FIT 5 Pro', '方屏时尚，智能健康管理升级', 1599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_66B24EA82C0CC387673A1547EDAA5EEA.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH FIT 系列', 'WATCH FIT 5', '轻薄时尚，全天候健康监测', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1BCE6003D8E0046B10CF4FE336CF1BFF.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH FIT 系列', 'WATCH FIT 4 Pro', '方屏设计，专业健康管理', 1499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_025811E828B43F19B1783418D1335FBB.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', 'WATCH FIT 系列', 'WATCH FIT 4', '时尚方屏，轻巧健康伴侣', 1199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1CB486AC4C78854C8CEC128E2B054BA0.png', '2026-06-30 06:53:01'),

                                                                                                                       ('穿戴', 'WATCH D 系列', 'WATCH D2', '血压监测手表，健康管理专业', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_CE7B0985EEEBA55C7AD62F9F63012238.png', '2026-06-30 06:53:01'),

                                                                                                                       ('穿戴', '手环系列', '华为手环 11 Pro', '专业健康手环，血氧心率监测', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C3EDD79503A39AAC0326FA1F05412A69.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '手环系列', '华为手环 11', '轻盈时尚手环，全天健康追踪', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AB39DF7ADDD0455C516E8DF7F0F18A97.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '手环系列', '华为手环 10', '入门级健康手环，性价比之选', 249.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_79D435006AD11B3FF4546ED1B5A337AC.png', '2026-06-30 06:53:01'),

                                                                                                                       ('穿戴', '少年儿童系列', '华为超新星手表 X1 Pro', '儿童智能手表，安全守护升级', 1499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E95FC11CE8ADA233257D141CD3EA031F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '少年儿童系列', '华为超新星手表 X1', '儿童成长陪伴，安全定位精准', 999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B8E2A8DCE8829C3C7242D7AE50F25A66.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '少年儿童系列', '华为儿童手表 5 Pro', '儿童智能手表，全面守护成长', 1199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_26E7F3176DB8ACE457CCB017AEFB29D1.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '少年儿童系列', '华为儿童手表 5 新耀版', '时尚儿童手表，新潮耀目设计', 899.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202405/gbom/6942103123146/428_428_BE32F4A9968EC2820AF4B22E9180469Amp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '少年儿童系列', '华为儿童手表 5 活力版', '活力设计，儿童安全守护', 699.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202311/gbom/6942103100840/428_428_F88468AB56C11CBC100522558B16943Cmp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '少年儿童系列', '华为儿童手表 5', '儿童安全定位，亲情通话联络', 599.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202311/gbom/6941487293964/428_428_E22847B3A211DBC7291B2AD3615D77DCmp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '少年儿童系列', '华为儿童手表 5X Pro', '可翻转双屏，儿童智能新体验', 1699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_13FEBF564EE306656A2B3CC4E6A4DD85.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '少年儿童系列', '华为儿童手表 5X', '双屏设计，安全与趣味兼备', 1499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5E258BDE128F3CF23070C858950FD11D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '少年儿童系列', '华为儿童手表 4 Pro', '经典儿童手表，安全定位可靠', 799.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_7B94689057BA346033044BF222541409.png', '2026-06-30 06:53:01'),

                                                                                                                       ('穿戴', '穿戴配件', '手表表带', '原装表带，舒适时尚多种款式', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/be464143e6094919a5e9d33be531f4ca.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '穿戴配件', '手环表带', '替换表带，个性搭配随心换', 49.00, 'https://res.vmallres.com/uomcdn/CN/cms/202506/05d1a3bec32f463a9946a935a016da47.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '穿戴配件', '儿童表带', '儿童手表专属表带，舒适安全', 39.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/34a0520cece541a2841889b3970fe429.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '穿戴配件', '专属表壳', '保护手表表壳，彰显个性品味', 79.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/48983b81d2084657a323de9acfc8e0a2.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '穿戴配件', '更多配件', '更多穿戴配件，等你来选', 19.00, 'https://res.vmallres.com/uomcdn/CN/cms/202506/f5ce632a0ac743bd8772e2530d6fb4a0.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('穿戴', '健康配件', '华为智能体脂秤 3', '精准测量，全面了解身体数据', 99.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_3DD2F36B6CC9C8A1A97BCA9BA9995207.png', '2026-06-30 06:53:01'),
                                                                                                                       ('穿戴', '健康配件', '华为智能体脂秤 3 Pro', '专业体脂测量，健康管理更科学', 199.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202312/gbom/6901443434121/428_428_1C2F2EA400E4C5407F883ABB02F0BF42mp.png', '2026-06-30 06:53:01');

-- =====================================================
-- 平板分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('平板', '平板', 'MatePad Edge', '超薄便携平板，移动办公优选', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6310699EE47323FC549BCADEF96BDDF5.png', '2026-06-30 06:53:01'),

                                                                                                                       ('平板', '系列 MatePad Edge MatePad Pro 系列', 'MatePad Pro Max', '13.2英寸巨幕，鸿蒙专业创作平台', 8999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/1dfbf2baa36d4036823695163c2acd2c.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('平板', '系列 MatePad Edge MatePad Pro 系列', 'MatePad Pro 12.2 英寸 2025', '专业创作平板，鸿蒙生产力工具', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_FB20954AF5D4E74F63BA43CB99B6D14C.png', '2026-06-30 06:53:01'),
                                                                                                                       ('平板', '系列 MatePad Edge MatePad Pro 系列', 'MatePad Pro 13.2 英寸 2025', '超大屏创作，鸿蒙专业体验', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F3D3D554979FCF0CC8B8B6CA2F02FD80.png', '2026-06-30 06:53:01'),
                                                                                                                       ('平板', '系列 MatePad Edge MatePad Pro 系列', 'MatePad Mini', '精致小巧，便携阅读与娱乐', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5B687D4EE52E998598944F3B0F9A4322.png', '2026-06-30 06:53:01'),

                                                                                                                       ('平板', '系列 MatePad Mini MatePad Air 系列', 'MatePad Air 12 英寸 2025', '轻薄时尚，高效移动办公学习', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A45DAA0819B7E7A920288CFA773FA0B4.png', '2026-06-30 06:53:01'),

                                                                                                                       ('平板', 'MatePad 系列', 'MatePad 11.5 2026', '高刷护眼屏，学习办公好帮手', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_860D07D275E366B30A048C0CEFF89B36.png', '2026-06-30 06:53:01'),
                                                                                                                       ('平板', 'MatePad 系列', 'MatePad 11.5 S 2025', '高刷护眼屏，S升级版更流畅', 2299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E9A180B112D5EC0CE88A7F6DB40ED494.png', '2026-06-30 06:53:01'),

                                                                                                                       ('平板', 'MatePad SE 系列', 'MatePad SE 11', '学习娱乐平板，性价比优选', 1499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6FC0862A633927145A242ECF15AB5B63.png', '2026-06-30 06:53:01'),

                                                                                                                       ('平板', '智选平板', 'Hi MatePad', '智选平板，鸿蒙生态体验', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_98C56E07024696CFADF564BFD738BFA4.png', '2026-06-30 06:53:01'),

                                                                                                                       ('平板', '配件周边', '平板键盘', '磁吸键盘，快速打字办公', 599.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/D59E78E517A960113D51A9CDF22D6872.png', '2026-06-30 06:53:01'),
                                                                                                                       ('平板', '配件周边', '平板保护套', '全面保护，防摔防刮耐用', 79.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/83820A52430418AA3B20F7E83813BFB9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('平板', '配件周边', '触控笔', '精准书写绘画，平板好搭档', 399.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/815B0D579449BE65B19225C99FA48862.png', '2026-06-30 06:53:01'),
                                                                                                                       ('平板', '配件周边', 'MatePad 系列保护膜', '高清防刮，保护屏幕清晰如新', 29.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_5EE4CDAB24C4CEEC297FD49183E289EB.png', '2026-06-30 06:53:01');

-- =====================================================
-- 笔记本分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('笔记本', '鸿蒙电脑', 'MateBook 14 鸿蒙版', '搭载鸿蒙OS，全场景智慧互联体验', 6999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/8b6c74154346419791ccfe9f4e861299.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '鸿蒙电脑', 'MateBook Fold 非凡大师', '折叠屏笔记本，全新形态旗舰', 19999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_EF1E1CD2B7119A1FE65EB725BD3748A9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '鸿蒙电脑', 'MateBook Pro', '旗舰性能，专业创作笔记本', 15999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_745817EBE93508087F304C955826E230.png', '2026-06-30 06:53:01'),

                                                                                                                       ('笔记本', 'MateBook D 系列', 'MateBook D 14 SE', '轻薄本，学生办公首选', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_68C0696C71A0B938D10B3B5DEDF7F4DF.png', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', 'MateBook D 系列', 'MateBook D 16 SE', '大屏轻薄本，办公更高效', 4499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8969BFAE6CC24E9AEAA5CC4CE31539DF.png', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', 'MateBook D 系列', 'MateBook D 16', '大屏性能本，生产力新选择', 5299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8CA709063084172692676D74DCA6A9C5.png', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', 'MateBook D 系列', 'MateBook D 14', '轻薄全能本，便携高效', 4699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_96B1611F0FFB6C27E606296FF7BE2BBE.png', '2026-06-30 06:53:01'),

                                                                                                                       ('笔记本', 'MateBook 系列', 'MateBook 14 酷睿 Ultra', '酷睿Ultra处理器，性能飞跃', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4B3A4B429057A20F0E2084F98A45D1F8.png', '2026-06-30 06:53:01'),

                                                                                                                       ('笔记本', 'MateBook GT 系列', 'MateBook GT 14 酷睿 Ultra', 'GT高性能轻薄本，强悍性能', 9999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_274FC79E1290C17803B7B4BBB451D872.png', '2026-06-30 06:53:01'),

                                                                                                                       ('笔记本', '智选笔记本', 'Hi MateBook 14 锐龙 200', '智选轻薄本，锐龙处理器加持', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6FFA5A8F0A95BF6A815A402629139E71.png', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '智选笔记本', 'Hi MateBook 14 2代酷睿', '智选笔记本，酷睿2代高效体验', 6699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_7E57F109553BF02A5DA3608B4BC7FAA6.png', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '智选笔记本', 'Hi Matebook D 14', '智选轻薄本，D系列经典设计', 3699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4663376DB3B5DA91E9A947F6B093F520.png', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '智选笔记本', 'Hi MateBook D 16', '智选大屏本，D系列经典大屏', 4199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B7F1B8BDAEFD5E34E7B433DC72D6F92D.png', '2026-06-30 06:53:01'),

                                                                                                                       ('笔记本', '鼠标及配件', '电脑背包', '大容量防水，电脑背包便携', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202411/bb5d8e99adec4f42a61adb858215c566.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '鼠标及配件', '鼠标/鼠标垫', '无线鼠标与鼠标垫套装', 129.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/61eafcfe298a4c7b9965ed3865e6a2be.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '鼠标及配件', '电源适配器', '原装电源适配器，稳定供电', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/501403379476150AD6C0D3BEE15839FD.png', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '鼠标及配件', '扩展坞', '多接口扩展，连接更多设备', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/57A99647F28FF46D8AADEE8C26AA31CA.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '鼠标及配件', '电脑内胆包', '柔软内胆，防摔防震保护', 89.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/fa4691ae41c9485f95922d7280eb4781.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('笔记本', '鼠标及配件', '更多配件', '更多笔记本配件，满足所需', 39.00, 'https://res.vmallres.com/uomcdn/CN/cms/2024-03/099329292cd04c4aba24d30aa4e23ba5.png.50.webp', '2026-06-30 06:53:01');

-- =====================================================
-- 台显打印分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('台显打印', '打印机', '华为毕昇激光打印机 X1', '激光打印，高效办公更清晰', 1499.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202408/gbom/6942103133749/428_428_9F368E737CEA9816C9DD51C62D95EDD1mp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('台显打印', '显示器', 'MateView GT 27英寸', '曲面电竞显示器，沉浸体验', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_244776E33CF924EAE70CFEA4A8C0D5F3.png', '2026-06-30 06:53:01'),
                                                                                                                       ('台显打印', '显示器', 'MateView SE 27英寸', '大屏办公显示器，护眼新选择', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_304C8996E4B0B563E0C160B1226B363B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('台显打印', '显示器', 'MateView SE 23.8英寸', '办公显示器，小桌面优选', 1499.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202407/gbom/6942103133329/428_428_D31B0DA95772638698B9AE85E6B77F95mp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('台显打印', '配件周边', '鼠标/鼠标垫', '办公鼠标套装，精准操控', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/2024-04/f6eeb4704fc94131a42f3da5c7a67aef.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('台显打印', '配件周边', '扩展坞', '扩展坞多接口，满足连接需求', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/5F438F17AF1B84968FCB56D3CE942679.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('台显打印', '配件周边', '华为臻彩墨水', '原装墨水，色彩真实饱满', 99.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_780799ACBFEFD83A932CC8651BDEA690.png', '2026-06-30 06:53:01'),
                                                                                                                       ('台显打印', '配件周边', '华为 F-1500 原装粉盒', '原装粉盒，打印更清晰', 199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8631E0E45FAEEACDD75154ED49E86A17.png', '2026-06-30 06:53:01'),
                                                                                                                       ('台显打印', '配件周边', '华为 X-15000 原装硒鼓', '原装硒鼓，持久耐用打印', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4A8EA8D4C2683E5850101694C2BC2B14.png', '2026-06-30 06:53:01'),
                                                                                                                       ('台显打印', '配件周边', '华为喷墨打印机 喷头', '原装喷头，保证打印质量', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_EB660466F6AD320E02E88288AE6138EC.png', '2026-06-30 06:53:01');

-- =====================================================
-- 耳机音箱分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('耳机音箱', 'FreeBuds 系列', 'FreeBuds Pro 5 悦彰耳机', '旗舰降噪，悦彰音质卓越', 1499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_3F879F41B2A15329A3361B38040DF601.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', 'FreeBuds 系列', 'FreeBuds SE 4 ANC', '主动降噪，续航持久，性价比之选', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_7C7C92DC00E66B7CBD2B5239E556EC35.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', 'FreeBuds 系列', 'FreeBuds 7i', '智能降噪，沉浸式音乐体验', 899.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_BDCF0C86FE7016E0EFAD7334A8B1C92C.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', 'FreeBuds 系列', 'FreeBuds 6 悦彰耳机', '半入耳设计，舒适佩戴悦彰音质', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D04DF3DACD678E3D49DF1E6ABF0E0A6B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', 'FreeBuds 系列', 'FreeBuds 6i', '入耳式降噪，年轻潮流之选', 699.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202407/gbom/6942103123504/428_428_94699091DAC76333D4758A5943521213mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', 'FreeBuds 系列', 'FreeBuds SE 3', '基础款耳机，日常使用好选择', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_2F9DF1B56627DD5192A2B5A9B35DA806.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', 'FreeBuds 系列', 'FreeBuds SE 2', '入门级无线耳机，经济实惠', 299.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202406/gbom/6942103122088/428_428_42B0420D9B2EC037E47B0ACE4F2E699Fmp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('耳机音箱', 'FreeClip 系列', 'FreeClip 2 典藏版', '耳夹式设计，时尚典雅，音质出色', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_38958B79B83D41F10939810477BA23FC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', 'FreeClip 系列', 'FreeClip 2 耳夹耳机', '耳夹式设计，舒适稳固，时尚之选', 1799.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_667628D42EEE17D8B3CA468CC84497BC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', 'FreeClip 系列', 'FreeClip 耳夹耳机', '经典耳夹设计，开放式聆听', 1599.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202312/gbom/6942103112201/428_428_DAE3AA929D0B389C9057F9DC4EF026A5mp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('耳机音箱', 'FreeArc 系列', 'FreeArc 耳挂耳机', '耳挂式开放设计，舒适稳固佩戴', 899.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6D0207E0DAB35A3D2E04615257B825D4.png', '2026-06-30 06:53:01'),

                                                                                                                       ('耳机音箱', 'FreeLace 系列', 'FreeLace 活力版', '颈挂式设计，运动活力之选', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F871F4D3FDB651DAE1C74F708129918C.png', '2026-06-30 06:53:01'),

                                                                                                                       ('耳机音箱', '有线耳机', '经典耳机', '经典有线耳机，稳定可靠音质', 149.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_73CBCAFB23BDC32668E190F54B9B397E.png', '2026-06-30 06:53:01'),

                                                                                                                       ('耳机音箱', '智能音箱', 'Sound X5', '旗舰智能音箱，澎湃音质，鸿蒙加持', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B6B421462B9D1070D7344999E0B64A37.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', '智能音箱', '华为悦彰家庭影院', '全景声家庭影院，沉浸视听体验', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_CD9F773A6B9D7D1786C97ED30824FCCF.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', '智能音箱', 'Sound X4', '高端智能音箱，旗舰音质表现', 2499.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202410/gbom/6942103117800/428_428_A1CA162A0504C5193EE9FACAEDA11C27mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', '智能音箱', 'Sound X', '经典智能音箱，好声音优选', 1999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202311/gbom/6941487278367/428_428_500DE8770AB587CDE091309D7DA3B684mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('耳机音箱', '智能音箱', 'Sound Joy 2', '便携户外音箱，防水长续航', 899.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202409/gbom/6942103130779/428_428_68D772C7100672BE57956793D07A77F8mp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('耳机音箱', '配件周边', '耳塞', '替换耳塞，舒适佩戴体验', 29.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/08ee545ee20e46fd82a230003f184d1b.png.50.webp', '2026-06-30 06:53:01');

-- =====================================================
-- 智能眼镜分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('智能眼镜', '智能眼镜', '华为 AI 眼镜 钛银灰 钛丝方形半框光学镜', 'AI智能助手，时尚钛丝半框设计', 2499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_29530622CD4D55F4FCA0D843FC00BDB2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为 AI 眼镜 钛银灰 钛丝半框光学镜', '轻量化钛丝镜架，智能交互体验', 2399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_14C31E260A159143792FD77DC81E5D90.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为 AI 眼镜 摩登黑 经典全框光学镜', '经典全框设计，AI智慧生活助手', 2299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E6D54F2AA3125491BF80569D7F352F9D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为 AI 眼镜 流光银 经典全框太阳镜', '流光银配色，智能太阳镜二合一', 2499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_219A4DE3BF9FE234B4767D1BB7158ACD.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为智能眼镜 2 透灰色 飞行员光学镜', '飞行员经典设计，时尚轻薄', 2199.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202309/gbom/6942103106392/428_428_082B86AE50F1B7E3DAC2C5881E45A068mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为智能眼镜 2 亮黑色 方形半框光学镜', '方形半框设计，亮黑配色更显精致', 2099.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202309/gbom/6942103106408/428_428_14E7E8987392A8915757C3D0D6A69365mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为智能眼镜 2 钛空银 钛空光学镜', '钛空银配色，科技感十足', 2299.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202309/gbom/6942103106422/428_428_2C963982778EE11E8285B03253517B2Amp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为智能眼镜 2 镜面银 无框光学镜', '无框设计，镜面银时尚前卫', 2399.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202309/gbom/6942103106439/428_428_03B2DC835C976FDF81C442C272D1B8AEmp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为智能眼镜 2 钛空银 钛空圆框光学镜', '圆框设计，复古与科技融合', 2299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5DA72A421B0B0779CB1F2BB30D46CC2B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '智能眼镜', '华为智能眼镜 2 亮黑色 方框太阳镜', '方框太阳镜设计，遮阳时尚兼备', 2599.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202405/gbom/6942103125614/428_428_261B00BC77242044A9FAE3AFB7AA510Amp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('智能眼镜', '配件周边', '耳勾&鼻托', '更换配件，佩戴更舒适', 29.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/72778fd310e541f3bfe36e619a59feb2.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('智能眼镜', '配件周边', '磁吸充电绳', '磁吸充电线，便捷充电', 69.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/403a7dcdebe646f19fe7b6a627ad0c0f.png.50.webp', '2026-06-30 06:53:01');

-- =====================================================
-- 智慧屏分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('智慧屏', '尺寸精选', '华为智慧屏 43/55英寸', '小尺寸智慧屏，适合卧室书房', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_35A4A66188B9B6ADFEE8427A5027885F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '尺寸精选', '华为智慧屏 65英寸', '主流尺寸，客厅观影首选', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_95E126DEEE7B18C7AD3938758D4BA5DC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '尺寸精选', '华为智慧屏 75英寸', '大屏沉浸，家庭影院体验', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D56C910A77D0DE230D69ED72626C0B9B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '尺寸精选', '华为智慧屏 85英寸', '巨幕影院，客厅视觉盛宴', 11999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_65B26271D4CCC1AFFF9DC923AF2B195F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '尺寸精选', '华为智慧屏 98英寸', '超大尺寸，尊享私人影院', 29999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D07019BF7CC583FB713DCF372358CEB0.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '尺寸精选', '华为智慧屏 110英寸', '巨幕旗舰，极致影音体验', 59999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AECFD006B08DDACCAD83CEE4265EA138.png', '2026-06-30 06:53:01'),

                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为Vision智慧屏 6 Pro', '鸿蒙AI，影院级视听享受', 8999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D56C910A77D0DE230D69ED72626C0B9B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为Vision智慧屏 6', '智慧先锋，年轻家庭首选', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_95E126DEEE7B18C7AD3938758D4BA5DC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为Vision智慧屏 6 SE', 'SE版，性价比智慧屏之选', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_35A4A66188B9B6ADFEE8427A5027885F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为Vision智慧屏 5 Pro', 'Pro级性能，影音体验升级', 11999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_49C835E741C9A8DC63130CAC125C73DD.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为Vision智慧屏 5', '智慧先锋系列，均衡实力', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_099F22A69655298537C728F01624EE0E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为Vision智慧屏 5 SE', 'SE性价比，智慧体验不减', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_9E4E2B920BB84453A7DE90A11630A4C7.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为Vision智慧屏 5 SE优享版', '优享版，体验更进一步', 6499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1FC8489312C5FA8D6034F672FE4AF7F2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为Vision智慧屏 4 New', 'New升级版，焕新体验', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B09D4691A7D8E8A982E28F16AA82C311.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'Vision智慧屏系列 智慧先锋', '华为智慧屏 SE43', 'SE系列，43寸精致小屏', 1999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202404/gbom/6941487264926/428_428_9313480C58763DACE8061B31DE5703E9mp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('智慧屏', 'MateTV系列 跨时代旗舰', '华为智慧屏 MateTV Max', 'MateTV旗舰，极致影音体验', 29999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AECFD006B08DDACCAD83CEE4265EA138.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'MateTV系列 跨时代旗舰', '华为智慧屏 MateTV Pro', '鸿蒙AI加持，影院级音画体验', 15999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_BC8579A5F481D2576218AB9AA05B619F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'MateTV系列 跨时代旗舰', '华为智慧屏 MateTV', '跨时代旗舰，智慧生活新定义', 12999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_732CDC83B12582246583EF5D84637220.png', '2026-06-30 06:53:01'),

                                                                                                                       ('智慧屏', 'S系列 智慧娱乐', '华为智慧屏 S7 Pro', '智慧娱乐中心，Pro版性能更强', 8999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_190E722FD4C0BA09E2B8521A5D719D1A.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'S系列 智慧娱乐', '华为智慧屏 S7X Pro', '极致画质，旗舰音效，智慧交互', 15999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_87D9DFC251CA8905C55C17EB8B61E1A0.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'S系列 智慧娱乐', '华为智慧屏 S7', '智慧娱乐中心，AI健身与观影', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_65B26271D4CCC1AFFF9DC923AF2B195F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'S系列 智慧娱乐', '华为智慧屏 S6 Pro', 'S系列Pro版，性能全面升级', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_6EDA77806076C396537B62D9E17E0EC9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'S系列 智慧娱乐', '华为智慧屏 S6', '智慧娱乐，家庭欢乐中心', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D2499E40415E4D2968D79E7FC6CB42C2.png', '2026-06-30 06:53:01'),

                                                                                                                       ('智慧屏', 'V系列 旗舰音画', '华为智慧屏 V6', '旗舰音画，极致视听享受', 19999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D07019BF7CC583FB713DCF372358CEB0.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', 'V系列 旗舰音画', '华为智慧屏 V5 Pro', 'V系列旗舰，专业影音品质', 25999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202311/gbom/6942103109232/428_428_97A55C98BAC8B94EB224BE969F3D60A8mp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('智慧屏', '配件周边', '华为灵犀手写笔', '智慧屏专属手写笔，精准输入', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_73AB1EF3AC19AF81FA27DDD3303E3C3F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', '华为灵犀悬浮触控', '悬浮操控，智慧交互新体验', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5BC7F6825066CDF6AA819E2A89EFCF6E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', '华为悦彰家庭影院', '全景声家庭影院，沉浸视听体验', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_CD9F773A6B9D7D1786C97ED30824FCCF.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', 'Sound X5', '旗舰智能音箱，澎湃音质，鸿蒙加持', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B6B421462B9D1070D7344999E0B64A37.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', 'Sound X4', '高端智能音箱，旗舰音质表现', 2499.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202410/gbom/6942103117800/428_428_A1CA162A0504C5193EE9FACAEDA11C27mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', 'Sound X', '经典智能音箱，好声音优选', 1999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202311/gbom/6941487278367/428_428_500DE8770AB587CDE091309D7DA3B684mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', '华为灵犀指向遥控', '精准指向，遥控器新体验', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_9FF5D4BC62F978D58987748066CD1C92.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', '华为智慧屏语音遥控器', '语音控制，便捷操作智慧屏', 199.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202407/gbom/6901443451388/428_428_5B22E4486F248F1E38BC287AF93BB2A3mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', 'PTAC SMART智慧屏艺术画框', '艺术画框设计，装饰智慧屏', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_B9B5B195E7118C32E9E52F15323861B7.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', 'PTAC SMART智慧屏金属底座', '金属底座，稳固支撑智慧屏', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_698B087A726B3A7FE5E892C57FC44D77.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', 'PTAC SMART智慧屏落地支架', '落地支架，自由摆放智慧屏', 699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5CE7A324871AC8E32172D04FA1540E30.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', 'PTAC SMART智慧屏超薄挂架', '超薄挂架，壁挂美观节省空间', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F025105EB81C6598E4D20AD580E2D88A.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', '艾歌P系列电视伸缩挂架', '伸缩挂架，灵活调整观看角度', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_A6138B1442F504947884A790893C76DB.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', '北通智能游戏手柄', '游戏手柄，畅玩大屏游戏', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A54326BDDC284FEB1F49B4E148BD2CFE.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智慧屏', '配件周边', '灵犀指向枪', '体感游戏，沉浸式射击体验', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_9592AEF8CF443A7A03C577E22890856A.png', '2026-06-30 06:53:01');

-- =====================================================
-- 路由存储分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('路由存储', '场景推荐', '智能路由 适用120㎡以上', '大户型组网，全屋Wi-Fi覆盖', 999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_EA0957724F897F7AA64CB1CE953D5DCB.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '场景推荐', '智能路由 适用90 ~ 120㎡', '中等户型优选，信号稳定', 799.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_EF2FF1D0D7BCE5A29B945AF7E79E4C88.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '场景推荐', '智能路由 适用60 ~ 90㎡', '小户型覆盖，性价比之选', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_540573037E34504A3EF6B01B3BA50707.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '场景推荐', '智能路由 适用60㎡以下', '迷你户型，网络够用就好', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5ACD0FE5D061573898C5219CBC2964D9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '场景推荐', '移动路由 适用移动出行', '随身移动路由，网络随身行', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4E526198E29FD2D3C03A71CBCB59D4F7.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '场景推荐', '家庭存储 手机秒变16TB', '家庭数据存储中心，大容量共享', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A242DB1AD14187786D7538BC0088B88E.png', '2026-06-30 06:53:01'),

                                                                                                                       ('路由存储', '创新旗舰 X 系列', '华为路由 X1 Pro 电竞涂装版', 'Wi-Fi 7，电竞级低延迟，专属涂装', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1D9469A090C6EB24B4F24D9352DC7881.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '创新旗舰 X 系列', '华为路由 X3 Pro 日照金山', '创新设计，稳定高速网络覆盖', 1099.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_01F7AE3F62201DCE7402790BD96D3407.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '创新旗舰 X 系列', '华为路由 X1 Pro', 'Wi-Fi 7旗舰，性能强悍', 1199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_85860C25F265BE88263F4CBD559242F8.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '创新旗舰 X 系列', '华为路由 X1', 'Wi-Fi 7体验，新一代高速网络', 999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_2151B8CD06C47FA8B6AE6D09DBA229CC.png', '2026-06-30 06:53:01'),

                                                                                                                       ('路由存储', '凌霄子母路由 Q 系列', '华为凌霄子母路由 Q7 电线版', '电力线组网，全屋Wi-Fi覆盖', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_04AEE26C5DCF3B980C51862E4592C949.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '凌霄子母路由 Q 系列', '华为凌霄子母路由 Q7 网线版', '网线组网，稳定高速覆盖', 1799.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B7F58C1B662091FC6790DF86F00DE237.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '凌霄子母路由 Q 系列', '华为凌霄子母路由 Q6 网线版 优享版', '优享版，网线组网更高效', 1599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AA924A0A567C8DDCAAD25661A9D69EC9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '凌霄子母路由 Q 系列', '华为凌霄子母路由 Q6', '经典Q系列，全屋WiFi覆盖', 1299.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202209/gbom/6941487261598/428_428_B97C55958F283CAB5922B7A5850D9ACCmp_tds.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '凌霄子母路由 Q 系列', '华为凌霄子母路由 Q6E', 'Q系列入门款，性价比覆盖', 1099.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202312/gbom/6942103101656/428_428_5110C68516EAF57AE04D48482C439778mp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('路由存储', '路由 BE 系列', '华为路由 BE7 Pro', 'Wi-Fi 7旗舰，BE系列Pro版', 1599.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202409/gbom/6942103136986/428_428_B78FE86C05C3914133AC6F17D4FA6594mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 BE 系列', '华为路由 BE7', 'Wi-Fi 7体验，BE系列旗舰', 1399.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202409/gbom/6942103136979/428_428_0308B6A9FBF1479E9A13FA2EB3420989mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 BE 系列', '华为路由 BE3 Pro+', 'BE系列Pro+版，性能升级', 1099.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_540573037E34504A3EF6B01B3BA50707.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 BE 系列', '华为路由 BE3 Pro 疾风版', '疾风版，高性能Wi-Fi 7路由', 999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_61D8C56E799B94C0A9BF114DA76D6EE8.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 BE 系列', '华为路由 BE3 Pro 雷电版', '雷电版，电竞级网络体验', 1199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_1CCFDABD48C773B00F9B929666DF12C7.png', '2026-06-30 06:53:01'),

                                                                                                                       ('路由存储', '路由 AX 系列', '华为路由 AX3 Pro 悦享版', 'Wi-Fi 6+，高速稳定，悦享版', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F265DFDDA7BFBAF06E271FA2C970E70F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 AX 系列', '华为路由 AX6 Pro', 'Wi-Fi 6+，AX系列旗舰', 699.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202402/gbom/6942103115387/428_428_6B302C29C8241F1A9A98BEBF36BE5ED7mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 AX 系列', '华为路由 AX6 new', 'AX6升级版，性能更稳定', 649.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_FD04DB8146705071AD4E19A86680733D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 AX 系列', '华为路由 AX3', 'Wi-Fi 6入门，性价比之选', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F5E85B8CC4344E4FDAE94D2D04C339AC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 AX 系列', '华为路由 AX2 Pro', 'AX系列入门，满足基本需求', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5ACD0FE5D061573898C5219CBC2964D9.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '路由 AX 系列', '华为路由 AX1', '基础款路由，简单实用', 199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_AB76AA17257A8B11F92FC77AC3CC0FA1.png', '2026-06-30 06:53:01'),

                                                                                                                       ('路由存储', '移动路由', '华为随行WiFi X', '5G移动路由，高速网络随身行', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4E526198E29FD2D3C03A71CBCB59D4F7.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '移动路由', '华为随行WiFi 3 Pro', '便携移动路由，随时随地上网', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_13B9C711F8134B096191730649DF91DC.jpg', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '移动路由', '华为移动路由 Pro', '移动路由Pro版，性能更强劲', 799.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_21709CF9D3FADD722F29FF9C6C0498D6.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '移动路由', '华为随行WiFi 5', '随行WiFi 5，轻巧便携', 499.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202404/gbom/6942103120534/428_428_3D5F51D081CE0A8431C9FC86D4ADD12Amp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '移动路由', '华为移动路由 5', '移动路由5，高速稳定', 699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_4992A4005AC332CD1D085A04FC409E21.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '移动路由', '华为移动路由 2', '移动路由2，便携高效', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_60FEB3411F5024AAE42B0E8EF0DBC90D.png', '2026-06-30 06:53:01'),

                                                                                                                       ('路由存储', '家庭存储', '华为家庭存储 无盘版', '家庭数据存储中心，无盘版灵活', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A242DB1AD14187786D7538BC0088B88E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '家庭存储', '华为家庭存储 有盘版', '家庭数据存储中心，手机秒变16TB', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A242DB1AD14187786D7538BC0088B88E.png', '2026-06-30 06:53:01'),

                                                                                                                       ('路由存储', '智选路由', 'Brovi 5G CPE Ultra 6', '智选5G路由，超高速宽带体验', 2599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_8DB6042F815E917B8671F14207168052.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '智选路由', 'Brovi 5G 随行 WiFi Pro 5', '智选随身WiFi，5G高速随身行', 1899.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_3B30D0C8F08BBAD87EEB0A375F6380AC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '智选路由', 'Brovi 5G CPE 5s', '智选CPE，稳定5G宽带接入', 2199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_DD703CDD5D50F2BE508FB21EE7211947.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '智选路由', '超讯捷COSOONJOY随行WiFi mini 2', '迷你随身WiFi，轻巧便捷', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_AC48BB65B831B57DEA63F62B2FBC2274.png', '2026-06-30 06:53:01'),

                                                                                                                       ('路由存储', '配件周边', '华为凌霄子母路由 Q7 电线版 子路由', '子路由，扩展Wi-Fi覆盖', 699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_89F990356192CD66FC13F343347AA548.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '配件周边', '华为路由 X3 Pro 日照金山 子路由', '子路由，扩展网络覆盖', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_7E222560EB7BE6FC2744644537FA7CA0.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '配件周边', '华为凌霄子母路由 Q7 网线版 母路由', '母路由，主路由高性能', 999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_51BFE02576B2484E653FE08E967A636B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '配件周边', '华为凌霄子母路由 Q7 网线版 子路由 超薄款', '超薄子路由，美观节省空间', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_3F2E3824D50DC146E87250BEF2A4A28E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '配件周边', '华为凌霄子母路由 Q7 网线版 子路由', '子路由，扩展网络信号', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_17BA21500A286FFE8383A5EA703EF151.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '配件周边', '华为凌霄子母路由 Q6 网线版 优享版 子路由', '优享版子路由，网络扩展', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_709CD311D6C5BD37AD3710C6471F4070.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '配件周边', '华为凌霄子母路由 Q6E 子路由', 'Q6E子路由，扩展覆盖', 399.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202312/gbom/6942103101649/428_428_E6DCE1CB1C424C7B7E1CD08C0D2A05F6mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '配件周边', '华为凌霄子母路由 Q6 子路由', 'Q6子路由，经典扩展设备', 399.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202312/gbom/6941487287789/428_428_0597FE49FA3CF3C6464A5B458DACF962mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('路由存储', '配件周边', '华为家庭存储断电保护电源', '断电保护，数据安全更可靠', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C83410EFC9D4267AA4355DB5BC97B8BE.png', '2026-06-30 06:53:01');

-- =====================================================
-- 智能门锁分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('智能门锁', '智能门锁', '华为智能门锁 M2', 'AI 3D人脸识别，金融级安全守护', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_97B868561F9980C911B0A76CFFB87971.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '智能门锁', '华为智能门锁 X1', '智能门锁，便捷安全开门', 2199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E521CB6F47FA168B1416D9E6C14D5B9E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '智能门锁', '华为智能门锁 2 Ultra', '高端门锁，Ultra版旗舰体验', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_394E88B455770941B1B394D10D154E3D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '智能门锁', '华为智能门锁 2 Pro', 'Pro级智能门锁，安全升级', 3299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_483979FC1D6F3A6CB4F8AC0DC9836631.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '智能门锁', '华为智能门锁 2 尊享版', '尊享版，智能门锁优选', 2799.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_CE11CAE56E4CA34C7125BBD59B9E55B2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '智能门锁', '华为智能门锁 2', '经典智能门锁，安全便捷', 2399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F3DB0AC1E5D1D2973140968FA179A359.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '智能门锁', '华为智能门锁 2 悦享版', '悦享版，性价比智能门锁', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A980FCBFA491F892B4C12EF940A52F8D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '智能门锁', '华为智能门锁 SE', 'SE入门款，智能门锁体验', 1699.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202311/gbom/6941487285037/428_428_693845D1E1477BD3D1E8CA2B280101CFmp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('智能门锁', '配件周边', '华为智能门锁NFC卡', 'NFC门卡，便捷开锁', 99.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A669ED94A146CBEEC140FC8BC018E88F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '配件周边', '华为智能门锁 X1 装饰锁', '装饰锁，搭配门锁使用', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_CECF39621294837EACBB36F0CAB7DBC2.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '配件周边', '华为智能门锁 2 系列装饰锁', '装饰锁，适配2系列门锁', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_419CA050C07A485D12990664BC3C9F2B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '配件周边', '华为智能门锁 2 系列专用锂电池', '专用锂电池，续航持久', 199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D459733E7972DAA89DDEAABF753DA746.png', '2026-06-30 06:53:01'),
                                                                                                                       ('智能门锁', '配件周边', '华为智能门锁 专用锂电池 一代专用', '一代专用电池，稳定供电', 199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_97C06C12E72D1757801988469B4B8E2B.png', '2026-06-30 06:53:01');

-- =====================================================
-- 鸿蒙智行分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('鸿蒙智行', '预约试驾', '尊界系列', '尊界全系预约试驾', 0.00, 'https://res.vmallres.com/uomcdn/CN/cms/202502/3fa852f39d9d4e2c96ffeaf7acee794e.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '预约试驾', '问界系列', '问界全系预约试驾', 0.00, 'https://res.vmallres.com/uomcdn/CN/cms/202503/4c84936fa07d46459a3f6865d21ab37a.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '预约试驾', '享界系列', '享界全系预约试驾', 0.00, 'https://res.vmallres.com/uomcdn/CN/cms/202407/a3aef025d1884b6c8f3c84b198a592f3.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '预约试驾', '智界系列', '智界全系预约试驾', 0.00, 'https://res.vmallres.com/uomcdn/CN/cms/202411/f6f731c1d9d74c9886e24f14ccd7ca33.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '预约试驾', '尚界系列', '尚界全系预约试驾', 0.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/e4e1532751ef4437a37a7b89d3c1d828.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智行', '尊界系列', '尊界 S800 Grand Design 典藏大观', '尊界旗舰，极致奢华定制版', 1680000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/3b6caa3d52474bcea3fc66ba38519194.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '尊界系列', '尊界 V800', '大型旗舰SUV，鸿蒙智行科技', 1380000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/72487a29527c41e1b4eb7ed65ce35183.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '尊界系列', '尊界 V680', '中大型豪华SUV，智能驾驭', 980000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/67dd8da0869d4ef283c591fa882fff01.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '尊界系列', '尊界 S800', '旗舰级智能轿车，鸿蒙智行标杆', 1280000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/35486494ee4747f6bae5dae33b26cb72.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智行', '问界系列', '问界 M9', '大型旗舰SUV，全场景智慧出行', 468000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/66c826d89fb640938fd9cae23c7adc38.jpg', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '问界系列', '问界 M9 Ultimate 领世加长版', '旗舰加长版，极致豪华空间', 598000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/30d4284296884fee8d78a3b461def12c.jpg', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '问界系列', '问界 M8', '中大型SUV，智能驾驶新标杆', 358000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/6826f5bf7d1248c18d541bcef9bba99c.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '问界系列', '问界 M7', '家庭智慧SUV，舒适智能', 298000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202603/c0d35fc57469474bbc05c75c6c34e2c0.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '问界系列', '问界 M6', '中型SUV，智能驾驶新选择', 259800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/1ca44fdd46964067b0070cb425aa1dab.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '问界系列', '问界 新M5 Ultra', '紧凑型SUV，智能驾驶升级', 248000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202602/aa8e6f8b76c5459c8ea647217ac073ce.png', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智行', '享界系列', '享界 S9T', '豪华智能轿车，舒适驾乘', 458000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202603/5eea07e8ffe74e2f955e8f9a1126a3fc.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '享界系列', '享界 S9', '智能轿车，享受驾驶乐趣', 398000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202603/04c7b8d5ff7d4927a1b555d8a9b784d2.png', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智行', '智界系列', '智界 V9', '大型智能MPV，全家出行首选', 429800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/c9fec9129920457d8184d012991538b9.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '智界系列', '智界 R7', '跨界SUV，智能运动风', 299800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202603/c0fa5b688bcc4d92a91b60957a3582ba.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '智界系列', '智界 新S7', '智能轿车，运动操控出色', 268000.00, 'https://res.vmallres.com/uomcdn/CN/cms/202603/03abb52f4d7d44f383a45f71e3f06ed0.png', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智行', '尚界系列', '尚界 Z7', '年轻时尚SUV，智能科技赋能', 229800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/16323ddab7314fb8bc3353fa7562b446.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '尚界系列', '尚界 Z7T', '运动轿跑SUV，动态操控出色', 259800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/6405cfdfc1c24ee3a32ed38bcc7a9182.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智行', '尚界系列', '尚界 H5', '新生代智能轿车，年轻活力', 189800.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/f430a646f74d44e5b4a66026872f447d.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智行', '家充桩', '华为家充桩 7kW', '家用充电桩，安全便捷充电', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_97109524AF09D1E2EF408198C7F208EA.png', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智行', '鸿蒙智行汽车生态精品', '精品附件', '汽车精品附件，提升出行体验', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/202512/87e0ebdf9bc94c9f888996c610c1945a.png.50.webp', '2026-06-30 06:53:01');

-- =====================================================
-- 配件中心分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('配件中心', '通用配件', '充电器', '原装充电器，快速安全充电', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/cdbf3b05d0c5463d955c3e1362d0a5c1.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '通用配件', '数据线', '高速数据线，充电传输二合一', 49.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/1c12e97f42eb4195be7e765cc7005097.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '通用配件', '移动电源', '大容量快充，随时续航无忧', 169.00, 'https://res.vmallres.com/uomcdn/CN/cms/202605/7940a36f27b84cf88426980bce07deaa.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '通用配件', '车载充电器', '车载快充，开车充电两不误', 89.00, 'https://res.vmallres.com/uomcdn/CN/cms/202505/01fa43e750574403a3adf8455b3211ed.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '通用配件', 'Tag 防丢精灵', '小巧防丢器，查找物品好帮手', 99.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_565D0ABC77171672227A74B5209494FB.png', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '通用配件', '自拍杆/支架', '自拍杆支架，拍摄更自由', 59.00, 'https://res.vmallres.com/uomcdn/CN/cms/2024-02/3942096c949340d3962078a50dafe08c.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('配件中心', '专属配件', '手机配件', '手机专属配件，保护与装饰', 29.00, 'https://res.vmallres.com/uomcdn/CN/cms/202401/CC577C176D1F23E2D607BDA502B0206F.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '电脑配件', '电脑配件，提升工作效率', 129.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/b309fef51f9641289e6cc6b96419b992.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '平板配件', '平板配件，学习办公好助手', 79.00, 'https://res.vmallres.com/uomcdn/CN/cms/202107/525E479025381D8ED7401FA2C7ED060D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '穿戴配件', '穿戴配件，个性搭配随心换', 49.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/48a53704a2794d929d6e65306c9b9110.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '音频配件', '音频配件，提升聆听体验', 29.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/1289204235624a0ca29f518d5e6529a1.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '智慧屏配件', '智慧屏配件，扩展娱乐体验', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202401/909874A687162F6EE16B0E00DC48B1FC.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '眼镜配件', '眼镜配件，佩戴更舒适', 29.00, 'https://res.vmallres.com/uomcdn/CN/cms/2024-02/6a6cc0e9b6284636bbed8deaeb4653de.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '智能门锁配件', '门锁配件，安全升级', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/202411/ded21d14669a441aae18d289e19ffea1.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '家庭存储配件', '存储配件，扩展家庭存储', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C83410EFC9D4267AA4355DB5BC97B8BE.png', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '专属配件', '健康配件', '健康配件，科学管理健康', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/437d7b7cd5a34680b364594f08f232ca.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('配件中心', '更多配件', 'TILTA 适用于HUAWEI Pura X Max专业摄影套装', '专业摄影套装，提升拍摄效果', 999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_0CD807D183AE88CB6061D6423D12F3C0.png', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '更多配件', 'TILTA 适用于HUAWEI Pura 90 Pro Max专业摄影套装', '专业摄影套装，打造专业级拍摄', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_20496538C3763D73ED3761C7180AE8C3.png', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '更多配件', '绿联 6A数据线 USB转C', '6A大电流，Type-C数据线', 39.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_CDC5F42DF5C1E1F5858BD2918A445DA1.png', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '更多配件', '艾歌P系列电视伸缩挂架', '伸缩挂架，灵活调整观看角度', 399.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_A6138B1442F504947884A790893C76DB.png', '2026-06-30 06:53:01'),
                                                                                                                       ('配件中心', '更多配件', 'TILTA 适用于HUAWEI Mate 80系列专业摄影套装', '专业摄影套装，Mate 80专属', 1199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_A643F8118D56A402EC36D666FFB37271.png', '2026-06-30 06:53:01');

-- =====================================================
-- 全屋智能分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('全屋智能', '热卖单品', '华为智慧屏 MateTV Pro', '鸿蒙AI加持，影院级音画体验', 15999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_BC8579A5F481D2576218AB9AA05B619F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为智慧屏 MateTV', '跨时代旗舰，智慧生活新定义', 12999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_42249B5634E16EAC8B249189B1B9322F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为Vision智慧屏 6 Pro', '鸿蒙AI，影院级视听享受', 8999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D56C910A77D0DE230D69ED72626C0B9B.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为Vision智慧屏 6', '智慧先锋，年轻家庭首选', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_95E126DEEE7B18C7AD3938758D4BA5DC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为Vision智慧屏 6 SE', 'SE版，性价比智慧屏之选', 4999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_35A4A66188B9B6ADFEE8427A5027885F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为智能门锁 X1', '智能门锁，便捷安全开门', 2199.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E521CB6F47FA168B1416D9E6C14D5B9E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为智能门锁 2 Ultra', '高端门锁，Ultra版旗舰体验', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_394E88B455770941B1B394D10D154E3D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为智能门锁 2 Pro', 'Pro级智能门锁，安全升级', 3299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_483979FC1D6F3A6CB4F8AC0DC9836631.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', 'Sound X5', '旗舰智能音箱，澎湃音质，鸿蒙加持', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_B6B421462B9D1070D7344999E0B64A37.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为AI音箱 2e 全屋版', '全屋智能语音控制，音乐随享', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_14FCAB79E343D441BC39F1789FE6FBBB.png', '2026-06-30 06:53:01'),
                                                                                                                       ('全屋智能', '热卖单品', '华为鸿蒙智家 蓝牙网关 Lite', '蓝牙网关，连接智能设备', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D1A3B2C870AC70E6CEB8FF46BF3E039A.png', '2026-06-30 06:53:01'),

                                                                                                                       ('全屋智能', '解决方案', '1+3+N解决方案', '全屋智能解决方案，打造智慧家庭', 0.00, 'https://res.vmallres.com/uomcdn/CN/cms/202601/e78f16a021c5489097abc1466c377a5f.jpg', '2026-06-30 06:53:01');

-- =====================================================
-- 华为服务分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('华为服务', '保障服务', 'HUAWEI Care+', '一年期意外保障服务，安心使用', 399.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/73e6a2f0f71046c69edbb404fdb12ed3.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('华为服务', '保障服务', '延长服务宝', '延长保修服务，使用更放心', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202512/f68c0a500add415fac6cde6682f2c8d7.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('华为服务', '保障服务', '智慧屏全质保', '智慧屏全面质量保障', 499.00, 'https://res.vmallres.com/uomcdn/CN/cms/202512/7b1114a2e463455ca833de9e4472626f.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('华为服务', '保障服务', '耳机丢失无忧服务', '耳机丢失可享受折扣换新', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/e8b26cb2fe97437485c09c02f20d3304.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('华为服务', '焕新服务', '手机一口价换电池服务', '手机电池一口价换新，实惠便捷', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202512/83449f0688b94b89a3af279240136748.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('华为服务', '焕新服务', '平板一口价换电池服务', '平板电池一口价换新服务', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/85488fe9d9d445b6adfeb2d6af1b4413.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('华为服务', '焕新服务', '穿戴一口价换电池服务', '穿戴设备电池换新服务', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/f706150c1ab742ee9dacc9554dbdba8d.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('华为服务', '焕新服务', '昆仑玻璃更换服务', '昆仑玻璃更换，坚固耐用', 599.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/4c1231984dab4555a95ff674858f6b2b.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('华为服务', '焕新服务', '手表焕新保养服务', '手表全面清洁保养，焕然一新', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/70964b4dc8db441eaa80a012e5a7128c.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('华为服务', '备件服务', '耳机补配备件服务', '耳机配件补购，丢失不再愁', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/48c46ba0a6954ac7a562168dfaec7fcc.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('华为服务', '上门服务', '智慧屏上门安装服务', '专业师傅上门安装调试', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/2024-03/302a2bbf3c504be9aae7288a120f352c.png.50.webp', '2026-06-30 06:53:01');

-- =====================================================
-- 鸿蒙智选分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('鸿蒙智选', '智能安防', '智能摄像头', '高清智能摄像头，远程监控守护', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202504/d2897b2f9cc34a7caab2349f02799f2e.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智选', '环境电器', '空气净化器', '智能空气净化，呼吸更健康', 2999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/62e4a49670a146b2a0db5d6f66cf0320.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '环境电器', '智能空调', '智能温控，舒适节能', 4999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202509/e6a71643fe384555b51fd4168a8fd3e0.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智选', '健康饮水', '智能水杯', '智能水杯，提醒饮水更健康', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/f2c74d8cb9ed42b3989270e9479b546f.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '健康饮水', '净水器', '智能净水，健康饮水新体验', 3999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202505/b53be89934dd4a1b833ecf86c81283b4.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智选', '个护健康', '电动剃须刀', '智能剃须，舒适干净', 599.00, 'https://res.vmallres.com/uomcdn/CN/cms/202312/82C56A91CD1D386EA61D4615BBBC8267.png', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '个护健康', '电动牙刷', '智能声波牙刷，洁净护龈', 399.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/ae886cbf89034ab99469bf0de2343a5c.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '个护健康', '冲牙器', '智能冲牙器，口腔深度清洁', 499.00, 'https://res.vmallres.com/uomcdn/CN/cms/202409/e4a1b4a686814ca9808cd41eb099033e.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智选', '智能照明', '台灯', '智能台灯，护眼调光', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202504/ddb3ffe3507f49c2973d12b4c16e4d1f.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '智能照明', '落地灯', '智能落地灯，氛围照明', 399.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/fe79b84779154b59b68c474e4a2eafec.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '智能照明', '吸顶灯', '智能吸顶灯，全屋照明', 499.00, 'https://res.vmallres.com/uomcdn/CN/cms/202606/27e2b3db6f194eaf9b990fa9e3f97762.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智选', '运动健康', '跳绳', '智能跳绳，科学计数', 99.00, 'https://res.vmallres.com/uomcdn/CN/cms/202510/1e930f18e3ff4115b95360197abcef0d.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '运动健康', '跑步机', '智能跑步机，家庭健身必备', 3999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/c66d49d8b5d2418c983eac05fd079cdd.jpg.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '运动健康', '动感单车', '智能动感单车，高效燃脂', 2999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202411/5becaed127414ed6b717036b669109b4.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '运动健康', '筋膜枪', '智能筋膜枪，深层肌肉放松', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202209/B127E73A607827FA500ECD6B9AF84863.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智选', '居家智品', '智能插座', '智能插座，远程控制电器', 49.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/7e8eb6502f8445da94c14e8c880b1764.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '居家智品', '智能窗帘', '智能窗帘，定时开合', 899.00, 'https://res.vmallres.com/uomcdn/CN/cms/202508/ac059383e04c4442be493c3404889e92.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '居家智品', '传感设备', '智能传感器，安全监测', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202509/f9c13c053a12468ca771bc676018199a.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '居家智品', '智能床', '智能床，健康睡眠监测', 9999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202511/0169da1795624d5b9951d2f40e558a5a.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '居家智品', '智能花洒', '智能花洒，恒温沐浴体验', 2999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202602/d7d1825c4385449095aca497f35e82ef.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '居家智品', '智能浴霸', '智能浴霸，温暖沐浴', 1999.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/0c2f1aa372284176aff4643aa09d8282.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('鸿蒙智选', '影音娱乐', '麦克风', '智能麦克风，K歌直播利器', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202410/fdd2566cc7214584970a6655d01d8161.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '影音娱乐', '手柄', '游戏手柄，畅玩游戏', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202209/47B0FB70E980DD1CBB2A63CF422D4449.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('鸿蒙智选', '影音娱乐', '云台', '手机云台，拍摄稳定更清晰', 599.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/f89f2432ddd845c5b252362319cfd5d0.png.50.webp', '2026-06-30 06:53:01');

-- =====================================================
-- 数字内容分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('数字内容', '华为音乐卡', '华为音乐 超级音乐VIP卡', '畅享千万正版曲库，高品质音乐体验', 198.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_6A63D369733CFF9B8757A04E71E8EF6D.png', '2026-06-30 06:53:01'),
                                                                                                                       ('数字内容', '华为音乐卡', '华为音乐 音乐VIP卡', '海量音乐，VIP专属体验', 68.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202310/sbom/3201070001703/428_428_4118E8A739D24FF64741FB04B2357CFEmp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('数字内容', '华为视频卡', '华为影视会员卡', '海量影视剧集，VIP畅享', 168.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202310/gbom/GB3201070001601/428_428_4D26646E5D60BB780B002C605D9242E0mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('数字内容', '华为视频卡', '华为视频 华为全屏影视SVIP会员卡', '全屏SVIP，极致观影体验', 398.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_ABBBE5C8EB225779D08B5317E80F0249.png', '2026-06-30 06:53:01'),
                                                                                                                       ('数字内容', '华为视频卡', '华为视频 超钻会员卡', '超钻会员，尊享全平台内容', 598.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_D019251C17217E56E037742EA9AF5273.png', '2026-06-30 06:53:01'),
                                                                                                                       ('数字内容', '华为视频卡', '华为视频 全屏少儿会员卡', '少儿专属内容，寓教于乐', 128.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202408/sbom/3201110058301/428_428_3F0500208F8205A0B49577C12FE1031Dmp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('数字内容', '华为主题', '华为主题会员', '海量主题资源，个性定制手机', 68.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202309/gbom/GB3201110044901/428_428_CA2F8D1E9880912FF105E8A840E4F286mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('数字内容', '华为主题', '华为表盘会员', '个性表盘资源，彰显独特品味', 48.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_bop_server/BopMaterialCenter/428_428_EA6B12A57D472075564012A8148DC22A.png', '2026-06-30 06:53:01'),

                                                                                                                       ('数字内容', '华为运动健康卡', '活力人生会员月卡', '月度运动健康服务，活力满满', 30.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202307/gbom/8813031170/428_428_E69610369FC14DC06190B3DDE46ABE12mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('数字内容', '华为运动健康卡', '活力人生会员年卡', '年度运动健康服务，科学管理', 298.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202402/gbom/8813033147/428_428_6D50B6F151A27EB16BCD69E8073C4E13mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('数字内容', '华为运动健康卡', '尊享守护服务卡', '专业健康守护，尊享服务', 499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C9D63252DDED928BEF525E2E62CB8549.png', '2026-06-30 06:53:01');

-- =====================================================
-- 商用终端分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('商用终端', '商用笔记本', '华为擎云 G540', '商用笔记本，企业办公首选', 5999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202303/gbom/6942103100727/428_428_2A476DD6CD9EF7B494A9F3469142CB1Bmp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用笔记本', '华为擎云 G540 Gen2', '第二代商用笔记本，性能升级', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_5A64082F937379FF038F9C8053A3A570.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用笔记本', '华为擎云 HM940', '高端商用笔记本，强劲性能', 8999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_C4C812B574CE230C2CFFC2FA72EF25C0.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用笔记本', '华为擎云 L420x', '信创商用笔记本，安全可靠', 7999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_0FBA74EF34730B82558E16825ABD49B6.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用笔记本', '华为擎云 HM740', '商用笔记本，平衡性能与价格', 6999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_3A6D3439E3F726B89D7998C7FCC85031.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用笔记本', '华为 MateBook Fold 企业版', '折叠屏笔记本企业版，创新形态', 21999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_333B474B8F5E38DF28D8DA50EDD7AA22.png', '2026-06-30 06:53:01'),

                                                                                                                       ('商用终端', '商用显示器', '华为显示器 B3-211H', '21.5英寸商用显示器，办公优选', 999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202306/gbom/6941487289509/428_428_9D51F69E29FBD732B4DEE4A03D8CA872mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用显示器', '华为显示器 B3-242H', '23.8英寸商用显示器，视野更广', 1299.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202208/gbom/6941487272365/428_428_C7C88AB65CC9F61685AC6797743A8F91mp_tds.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用显示器', '华为擎云 M272H', '27英寸商用显示器，高清办公', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_50DC74C19B6CBCDA3433F1050CAEEE11.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用显示器', '华为擎云 M272Q', '27英寸2K商用显示器，清晰细腻', 2499.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202410/gbom/6942103140525/428_428_FBE31ABF4A4A130A256BC42F159A4E68mp.png', '2026-06-30 06:53:01'),

                                                                                                                       ('商用终端', '商用打印机', '华为PixLab B5', '商用激光打印机，高效办公', 2499.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_FB55E5924D5DC81B641304E581F1B5AD.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用打印机', '华为擎云 P5 激光单功能打印机', '单功能激光打印，专注高效', 1699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_2696F41C607B7C113357362D46166471.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用打印机', '华为原装粉盒 适用B5', '原装粉盒，B5打印机专用', 299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_80C863F71D82A24CD80E2AE7B3771A6C.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用打印机', '华为原装硒鼓 适用B5', '原装硒鼓，B5打印机专用', 599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E77992B5813511418528C422A75A19DC.png', '2026-06-30 06:53:01'),

                                                                                                                       ('商用终端', '商用平板', '华为擎云 C5（第3代）', '商用平板，第三代性能升级', 3999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_87905B7646003ECBF0691D5AEC7EDC54.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用平板', '华为擎云 C5e（第2代）', '商用平板，第二代e版', 2999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_BF1834FC5841229F37956092C9A04ABC.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用平板', '华为擎云 C5e', '商用平板，e版性价比之选', 2699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_A96829795FAC00FCA7C602A677A3F38E.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用平板', '华为擎云 C7（第2代）', '商用平板旗舰，第二代升级', 4999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202407/gbom/6942103125836/428_428_A76BAFA66F9E2E18FA2A18E4C91FB707mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用平板', '华为擎云 C7', '商用平板旗舰，性能强悍', 4699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_05644E2206027063E0E1D761D9010594.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用平板', '华为擎云 C5s', '商用平板，C5s版', 3299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E4237D814C4EC5F005B607E4FA47343F.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用平板', '华为擎云 C3', '商用平板入门款，经济实用', 1999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202407/gbom/6942103120589/428_428_A9FA5D7DD2B330EAF62160523CF6D036mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用平板', '华为擎云C5（第4代）', '商用平板，第四代全面升级', 4299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_8DA32C278A73C7DDCE9EC2F3515E0D69.png', '2026-06-30 06:53:01'),

                                                                                                                       ('商用终端', '商用穿戴', '华为擎云 H9D20', '商用穿戴设备，企业定制', 1999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_69F62D116E0EDD09F3915C22A5374348.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用穿戴', '华为擎云 HA580', '商用穿戴，HA580型号', 1299.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_E62C516E28389EF0DA809F542A03F605.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用穿戴', '华为擎云 HA5A0', '商用穿戴，HA5A0型号', 899.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_BBE2F994148ACDF5D4C90293E81FFB68.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用穿戴', '华为擎云 H7556', '商用穿戴，H7556型号', 2599.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_050C89CF1B2B493A909FB35643A87BA8.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用穿戴', '华为擎云 H3540', '商用穿戴，H3540型号', 1699.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F6765B6EB5950FB04D78B7904A56F98B.png', '2026-06-30 06:53:01'),

                                                                                                                       ('商用终端', '商用智慧屏', '华为智慧屏 B3', '商用智慧屏，B3基础款', 5999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_F249E37E8D340D30B58F0F3D108107B4.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用智慧屏', '华为智慧屏 B5', '商用智慧屏，B5专业款', 9999.00, 'https://res.vmallres.com/pimages/uomcdn/CN/pms/202408/gbom/6942103128851/428_428_893800F1FDF00075AC099D6028978BE1mp.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用智慧屏', '华为智慧屏 B7', '商用智慧屏，B7旗舰款', 15999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_12C7AB74516932EC4E821D4364E94402.png', '2026-06-30 06:53:01'),
                                                                                                                       ('商用终端', '商用智慧屏', '华为智慧屏 B9', '商用智慧屏，B9顶配款', 25999.00, 'https://res.vmallres.com/pimages/FssCdnProxy/vmall_product_uom/pmsSalesFile/428_428_87F83D8AEB40CE400118728080A875A0.png', '2026-06-30 06:53:01');

-- =====================================================
-- 美食酒饮分类数据
-- =====================================================
INSERT INTO vmall_homepage_categories (category, `group`, product_name, description, price, image_url, scraped_at) VALUES
                                                                                                                       ('美食酒饮', '甄选美酒', '红葡萄酒', '智利原装进口，果香浓郁', 168.00, 'https://res.vmallres.com/uomcdn/CN/cms/202512/4559edb2684e4176a9d1e15300919a52.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '甄选美酒', '白葡萄酒', '法国原产，清新爽口', 158.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/3d65a7f653d44a53b167831886e3c284.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '甄选美酒', '白酒', '纯粮酿造，醇香绵柔', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/708df74c5cab4e36953d243497c94c0b.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '甄选美酒', '起泡酒', '意大利进口，欢庆之选', 198.00, 'https://res.vmallres.com/uomcdn/CN/cms/202512/d35dfbb513e94cf8af346761a140252e.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('美食酒饮', '冲调品', '咖啡', '精品咖啡豆，香醇浓郁', 89.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/0fac45ade02c4bd081aa7716be462a2c.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '冲调品', '茗茶', '精选茗茶，清香四溢', 128.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/3f6d8432888c470abad1751d6b145bb3.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '冲调品', '蜂蜜', '天然蜂蜜，营养滋补', 89.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/142aecab221b4d0f830fdb92516817ad.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '冲调品', '奶粉', '进口奶粉，营养丰富', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/9c752b8a9e9249319f17d121fd4f827f.png.50.webp', '2026-06-30 06:53:01'),

                                                                                                                       ('美食酒饮', '严选良食', '休闲食品', '各式零食，休闲时刻必备', 39.00, 'https://res.vmallres.com/uomcdn/CN/cms/202407/e2a541ab11fb4308b4c8735cba702375.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '严选良食', '甄选米油', '精选优质米油，健康生活', 79.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/64f8cec0653745b4bc5a1da6d36c6e27.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '严选良食', '精品礼盒', '精美礼盒，送礼佳品', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/e7dd0348e07e476ca1e8e234af082b0c.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '严选良食', '进口牛肉', '澳洲进口，肉质鲜嫩', 299.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/02844004c478400391eee7fa2a7bde94.png.50.webp', '2026-06-30 06:53:01'),
                                                                                                                       ('美食酒饮', '严选良食', '进口火腿', '西班牙进口，风味独特', 199.00, 'https://res.vmallres.com/uomcdn/CN/cms/202604/b3ea8c4571654ea7af1bdb7b5ae9a017.png.50.webp', '2026-06-30 06:53:01');


INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (1, NULL, 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pn=huaweizonePC',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (2, NULL, 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pn=educationcenterpc',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (3, NULL, 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pn=yijiuhuanxinPC',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (4, NULL, 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=401152960',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (5, NULL, 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pn=xinrenpindaoPC',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (6, '享0分期利息', 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101123464',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (7, '企业商用', 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101125613',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (8, 'O2O采购', 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101125614',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (9, '退换货政策', 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101123440',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (10, '手机寄修服务', 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pageId=101123473',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (11, '以旧换新', 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pn=yijiuhuanxinPC',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (12, '教育优惠', 'https://www.vmall.com/portal/activity/index.html?isShowLayout=false&pn=educationcenterpc',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (13, '商家中心', 'https://www.vmall.com/portal/activity/index.html?pn=zhaoshang', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (14, '华为商城手机版', 'https://www.vmall.com/portal/activity/index.html?pageId=401001427',
        '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
INSERT INTO vmall_homepage_activities (id, title, activity_url, scraped_at)
VALUES (15, 'COOKIES', 'https://www.vmall.com/portal/activity/index.html?pn=cookies', '2026-06-28 06:51:02.843')
ON DUPLICATE KEY UPDATE title=VALUES(title),
                        activity_url=VALUES(activity_url),
                        scraped_at=VALUES(scraped_at);
