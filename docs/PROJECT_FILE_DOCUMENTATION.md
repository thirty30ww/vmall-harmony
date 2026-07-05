# 华为商城仿写项目功能文档

> 本文档按代码实现的功能模块分类说明项目文件。图片、图标、商品媒体资源不逐项说明。

## 1. 项目整体结构

本项目分为后端和鸿蒙端两部分：

- 后端：Spring Boot + MyBatis + Spring Security + JWT，负责提供接口和读取数据库数据。
- 鸿蒙端：ArkTS / ArkUI，负责页面展示、用户交互和调用后端接口。

## 2. 项目启动与基础配置

### 后端文件

- `pom.xml`
  - Maven 依赖与构建配置，定义 Spring Boot、MyBatis、Security、JWT 等依赖。

- `mvnw` / `mvnw.cmd`
  - Maven Wrapper 脚本，用于统一执行 Maven 命令。

- `src/main/java/org/example/vmall_home_demo/VmallHomeDemoApplication.java`
  - Spring Boot 项目启动入口。

- `src/main/resources/application.properties`
  - 后端运行配置，包含数据库连接、服务端口等信息。

- `src/main/java/org/example/vmall_home_demo/config/WebConfig.java`
  - Web 全局配置，主要处理跨域等基础能力。

### 鸿蒙端文件

- `HarmonyApp/oh-package.json5`
  - 鸿蒙工程依赖配置。

- `HarmonyApp/oh-package-lock.json5`
  - 鸿蒙依赖锁定文件。

- `HarmonyApp/hvigorfile.ts`
  - 鸿蒙工程构建脚本。

- `HarmonyApp/build-profile.json5`
  - 鸿蒙工程构建 Profile 配置。

- `HarmonyApp/code-linter.json5`
  - 鸿蒙代码检查配置。

- `HarmonyApp/hvigor/hvigor-config.json5`
  - Hvigor 构建工具配置。

- `HarmonyApp/AppScope/app.json5`
  - 鸿蒙应用级配置。

- `HarmonyApp/entry/build-profile.json5`
  - entry 模块构建配置。

- `HarmonyApp/entry/oh-package.json5`
  - entry 模块依赖配置。

- `HarmonyApp/entry/hvigorfile.ts`
  - entry 模块构建脚本。

- `HarmonyApp/entry/obfuscation-rules.txt`
  - entry 模块混淆规则。

- `HarmonyApp/entry/src/main/module.json5`
  - entry 模块声明，配置页面、权限、Ability 等信息。

- `HarmonyApp/entry/src/main/ets/entryability/EntryAbility.ets`
  - 鸿蒙应用启动入口，负责加载初始页面。

- `HarmonyApp/entry/src/main/ets/entrybackupability/EntryBackupAbility.ets`
  - 鸿蒙备份恢复能力入口。

## 3. 用户认证功能

实现登录、注册、验证码、JWT 登录态保存。

### 后端文件

- `src/main/java/org/example/vmall_home_demo/controller/AuthController.java`
  - 提供登录、注册、发送登录验证码、发送注册验证码接口。

- `src/main/java/org/example/vmall_home_demo/service/AuthService.java`
  - 处理登录、注册、验证码校验、密码加密、JWT 生成逻辑。

- `src/main/java/org/example/vmall_home_demo/security/JwtTokenProvider.java`
  - 负责 JWT Token 的生成、解析和校验。

- `src/main/java/org/example/vmall_home_demo/security/JwtAuthenticationFilter.java`
  - 从请求头读取 Token，校验后设置当前登录用户。

- `src/main/java/org/example/vmall_home_demo/config/SecurityConfig.java`
  - 配置接口访问权限，放行认证接口，保护需要登录的接口。

- `src/main/java/org/example/vmall_home_demo/mapper/UserMapper.java`
  - 查询用户、创建用户、更新最后登录时间。

- `src/main/java/org/example/vmall_home_demo/mapper/SmsCodeMapper.java`
  - 写入、查询、更新验证码记录。

- `src/main/java/org/example/vmall_home_demo/entity/User.java`
  - 用户实体。

- `src/main/java/org/example/vmall_home_demo/entity/SmsCode.java`
  - 验证码实体。

- `src/main/java/org/example/vmall_home_demo/dto/LoginRequest.java`
  - 登录请求参数。

- `src/main/java/org/example/vmall_home_demo/dto/RegisterRequest.java`
  - 注册请求参数。

- `src/main/java/org/example/vmall_home_demo/dto/SendCodeRequest.java`
  - 发送验证码请求参数。

- `src/main/java/org/example/vmall_home_demo/dto/SendCodeResponse.java`
  - 发送验证码响应结构。

- `src/main/java/org/example/vmall_home_demo/dto/AuthResponse.java`
  - 登录或注册成功后的响应结构。

- `src/main/java/org/example/vmall_home_demo/dto/UserInfo.java`
  - 当前用户信息结构，用于 JWT Principal 和接口返回。

- `docs/vmall_user_auth.sql`
  - 用户、验证码相关数据库脚本。

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/ets/api/authApi.ets`
  - 封装登录、注册、发送验证码接口。

- `HarmonyApp/entry/src/main/ets/pages/LoginPage.ets`
  - 登录页面，登录成功后保存 Token、手机号、用户名。

- `HarmonyApp/entry/src/main/ets/pages/RegisterPage.ets`
  - 注册页面，注册成功后保存登录态。

## 4. 首页功能

实现首页搜索栏、分类入口、轮播图、活动入口、商品推荐列表。

### 后端文件

- `src/main/java/org/example/vmall_home_demo/controller/HomeController.java`
  - 提供 `/api/home` 首页聚合接口。

- `src/main/java/org/example/vmall_home_demo/service/HomeService.java`
  - 聚合分类、搜索推荐词、活动、商品数据。

- `src/main/java/org/example/vmall_home_demo/dto/HomeResponse.java`
  - 首页接口响应结构。

- `src/main/java/org/example/vmall_home_demo/controller/ProductController.java`
  - 提供商品列表、商品详情接口。

- `src/main/java/org/example/vmall_home_demo/service/ProductService.java`
  - 处理商品查询、搜索、详情逻辑。

- `src/main/java/org/example/vmall_home_demo/mapper/ProductMapper.java`
  - 查询首页商品数据。

- `src/main/java/org/example/vmall_home_demo/entity/Product.java`
  - 商品实体。

- `src/main/java/org/example/vmall_home_demo/controller/ActivityController.java`
  - 提供活动入口接口。

- `src/main/java/org/example/vmall_home_demo/service/ActivityService.java`
  - 活动入口业务逻辑。

- `src/main/java/org/example/vmall_home_demo/mapper/ActivityMapper.java`
  - 查询活动入口数据。

- `src/main/java/org/example/vmall_home_demo/entity/Activity.java`
  - 活动入口实体。

- `src/main/java/org/example/vmall_home_demo/controller/SearchSuggestionController.java`
  - 提供搜索推荐词接口。

- `src/main/java/org/example/vmall_home_demo/service/SearchSuggestionService.java`
  - 搜索推荐词业务逻辑。

- `src/main/java/org/example/vmall_home_demo/mapper/SearchSuggestionMapper.java`
  - 查询搜索推荐词数据。

- `src/main/java/org/example/vmall_home_demo/entity/SearchSuggestion.java`
  - 搜索推荐词实体。

- `docs/vmall_homepage.sql`
  - 首页、商品、分类、搜索推荐词等数据库脚本。

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/ets/api/homeApi.ets`
  - 封装首页聚合、商品列表、商品详情接口。

- `HarmonyApp/entry/src/main/ets/pages/HomePage.ets`
  - 主页面中的首页模块，组织搜索、轮播、分类、活动、商品列表。

- `HarmonyApp/entry/src/main/ets/components/SearchBar.ets`
  - 首页搜索栏组件。

- `HarmonyApp/entry/src/main/ets/components/HomeSwiper.ets`
  - 首页轮播图组件。

- `HarmonyApp/entry/src/main/ets/components/CategoryGrid.ets`
  - 首页分类宫格组件。

- `HarmonyApp/entry/src/main/ets/components/ActivityBanner.ets`
  - 首页活动入口组件。

- `HarmonyApp/entry/src/main/ets/components/ProductCard.ets`
  - 首页商品卡片组件。

- `HarmonyApp/entry/src/main/ets/components/ProductsListSection.ets`
  - 首页横向商品推荐模块。

- `HarmonyApp/entry/src/main/ets/data/categoryData.ets`
  - 首页分类入口本地数据。

- `HarmonyApp/entry/src/main/ets/data/productsListData.ets`
  - 首页横向商品模块本地数据。

## 5. 分类功能

实现左侧纵向分类菜单、右侧商品入口、商品点击进入详情页。

### 后端文件

- `src/main/java/org/example/vmall_home_demo/controller/CategoryController.java`
  - 提供 `/api/categories` 分类完整数据接口。

- `src/main/java/org/example/vmall_home_demo/service/CategoryService.java`
  - 分类商品业务逻辑。

- `src/main/java/org/example/vmall_home_demo/mapper/CategoryMapper.java`
  - 查询分类商品数据，包括商品名称、图片、描述、价格。

- `src/main/java/org/example/vmall_home_demo/entity/Category.java`
  - 分类商品实体。

- `src/main/java/org/example/vmall_home_demo/controller/CategoryPageController.java`
  - 提供分类页菜单结构接口。

- `src/main/java/org/example/vmall_home_demo/service/CategoryPageService.java`
  - 分类页菜单结构业务逻辑。

- `src/main/java/org/example/vmall_home_demo/mapper/CategoryPageMapper.java`
  - 查询分类页左侧菜单。

- `src/main/java/org/example/vmall_home_demo/entity/CategoryPageMenu.java`
  - 分类页菜单实体。

- `src/main/java/org/example/vmall_home_demo/entity/CategoryPageProduct.java`
  - 分类页商品实体。

- `src/main/java/org/example/vmall_home_demo/dto/CategoryPageResponse.java`
  - 分类页响应结构。

- `src/main/java/org/example/vmall_home_demo/dto/CategoryPageCategoryDto.java`
  - 分类页分类 DTO。

- `src/main/java/org/example/vmall_home_demo/dto/CategoryPageProductDto.java`
  - 分类页商品 DTO。

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/ets/api/categoryApi.ets`
  - 封装分类页接口，并把后端平铺数据转换为页面需要的分组结构。

- `HarmonyApp/entry/src/main/ets/components/CategoryPanel.ets`
  - 分类页主体组件，负责左侧菜单、右侧商品分组和商品点击跳转。

- `HarmonyApp/entry/src/main/ets/pages/HomePage.ets`
  - 主页面中承载分类 Tab。

## 6. 商品详情功能

实现从首页或分类点击商品后进入详情页，显示商品图片、价格、描述，并支持加入购物车。

### 后端文件

- `ProductController.java`
  - 提供首页商品详情接口 `/api/products/{id}`。

- `ProductService.java`
  - 商品详情查询逻辑。

- `ProductMapper.java`
  - 根据商品 ID 查询数据库商品详情。

- `CategoryMapper.java`
  - 分类商品数据中提供价格和描述，供分类点击时传入详情页。

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/ets/pages/ProductDetailPage.ets`
  - 商品详情页，负责展示商品信息、底部入口和加入购物车按钮。

- `HarmonyApp/entry/src/main/ets/pages/HomePage.ets`
  - 首页商品点击跳转详情。

- `HarmonyApp/entry/src/main/ets/components/CategoryPanel.ets`
  - 分类商品点击跳转详情。

- `HarmonyApp/entry/src/main/ets/components/ProductsListSection.ets`
  - 首页横向商品点击跳转详情。

## 7. 发现页功能

实现发现页顶部标题、搜索图标、轮播图、推荐、发布会、选购攻略、玩机技巧等内容。

### 后端文件

- `src/main/java/org/example/vmall_home_demo/controller/DiscoverController.java`
  - 提供发现页接口。

- `src/main/java/org/example/vmall_home_demo/service/DiscoverService.java`
  - 发现页数据组装逻辑。

- `src/main/java/org/example/vmall_home_demo/mapper/DiscoverMapper.java`
  - 查询发现页页面、Tab、导航、栏目、内容项。

- `src/main/java/org/example/vmall_home_demo/entity/DiscoverPage.java`
  - 发现页页面实体。

- `src/main/java/org/example/vmall_home_demo/entity/DiscoverTab.java`
  - 发现页 Tab 实体。

- `src/main/java/org/example/vmall_home_demo/entity/DiscoverNavIcon.java`
  - 发现页导航入口实体。

- `src/main/java/org/example/vmall_home_demo/entity/DiscoverSection.java`
  - 发现页内容分区实体。

- `src/main/java/org/example/vmall_home_demo/entity/DiscoverItem.java`
  - 发现页内容项实体。

- `src/main/java/org/example/vmall_home_demo/dto/DiscoverResponse.java`
  - 发现页接口响应结构。

- `src/main/java/org/example/vmall_home_demo/dto/DiscoverSectionDto.java`
  - 发现页分区 DTO。

- `docs/vmall_discover.sql`
  - 发现页相关数据库脚本。

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/ets/api/discoverApi.ets`
  - 封装发现页接口。

- `HarmonyApp/entry/src/main/ets/components/DiscoverPanel.ets`
  - 发现页主体组件。

- `HarmonyApp/entry/src/main/ets/pages/HomePage.ets`
  - 主页面中承载发现 Tab。

## 8. 购物车功能

实现加入购物车、购物车列表、数量加减、勾选、全选、删除和合计。

### 后端文件

- `src/main/java/org/example/vmall_home_demo/controller/CartController.java`
  - 提供购物车接口，所有接口都通过 JWT 获取当前用户。

- `src/main/java/org/example/vmall_home_demo/service/CartService.java`
  - 购物车业务逻辑，包括加入、修改数量、勾选、删除、合计。

- `src/main/java/org/example/vmall_home_demo/mapper/CartItemMapper.java`
  - 操作购物车表。

- `src/main/java/org/example/vmall_home_demo/entity/CartItem.java`
  - 购物车条目实体。

- `src/main/java/org/example/vmall_home_demo/dto/AddCartItemRequest.java`
  - 加入购物车请求参数。

- `src/main/java/org/example/vmall_home_demo/dto/UpdateCartItemRequest.java`
  - 修改购物车条目请求参数。

- `src/main/java/org/example/vmall_home_demo/dto/SelectAllCartRequest.java`
  - 全选或取消全选请求参数。

- `src/main/java/org/example/vmall_home_demo/dto/CartItemResponse.java`
  - 购物车单项响应结构。

- `src/main/java/org/example/vmall_home_demo/dto/CartSummaryResponse.java`
  - 购物车汇总响应结构。

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/ets/api/cartApi.ets`
  - 封装购物车接口，并自动携带 Token。

- `HarmonyApp/entry/src/main/ets/pages/ProductDetailPage.ets`
  - 商品详情页中调用加入购物车接口。

- `HarmonyApp/entry/src/main/ets/pages/HomePage.ets`
  - 主页面中实现购物车 Tab、列表展示、数量修改、删除、合计。

## 9. 我的页面功能

实现我的页面顶部用户信息、订单入口、资产入口、服务入口和设置入口。

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/ets/pages/HomePage.ets`
  - 主页面中实现我的 Tab，包括当前账号名显示、订单和服务模块。

- `HarmonyApp/entry/src/main/ets/components/BottomNavBar.ets`
  - 底部导航栏，负责切换到我的页面。

### 后端关联

- `AuthController.java` / `AuthService.java`
  - 登录成功后返回用户信息。

- `UserInfo.java`
  - 提供用户名、手机号等当前账号信息。

## 10. 底部导航功能

实现首页、分类、发现、购物车、我的五个底部入口。

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/ets/components/BottomNavBar.ets`
  - 底部导航栏组件。

- `HarmonyApp/entry/src/main/ets/pages/HomePage.ets`
  - 根据底部导航状态切换不同模块内容。

## 11. 资源与路由配置

### 鸿蒙端文件

- `HarmonyApp/entry/src/main/resources/base/profile/main_pages.json`
  - 页面路由配置。

- `HarmonyApp/entry/src/main/resources/base/profile/backup_config.json`
  - 备份配置。

- `HarmonyApp/entry/src/main/resources/base/element/string.json`
  - 字符串资源配置。

- `HarmonyApp/entry/src/main/resources/base/element/color.json`
  - 颜色资源配置。

- `HarmonyApp/entry/src/main/resources/base/element/float.json`
  - 尺寸资源配置。

- `HarmonyApp/entry/src/main/resources/dark/element/color.json`
  - 深色模式颜色资源配置。

## 12. 测试与 Mock

### 后端文件

- `src/test/java/org/example/vmall_home_demo/VmallHomeDemoApplicationTests.java`
  - Spring Boot 默认测试入口。

### 鸿蒙端文件

- `HarmonyApp/entry/src/test/LocalUnit.test.ets`
  - 鸿蒙本地单元测试文件。

- `HarmonyApp/entry/src/test/List.test.ets`
  - 鸿蒙测试样例文件。

- `HarmonyApp/entry/src/ohosTest/ets/test/Ability.test.ets`
  - 鸿蒙 Ability 测试文件。

- `HarmonyApp/entry/src/ohosTest/ets/test/List.test.ets`
  - 鸿蒙列表测试文件。

- `HarmonyApp/entry/src/mock/mock-config.json5`
  - 鸿蒙 Mock 配置文件。

## 13. 维护建议

- 后端新增功能时，保持 `controller -> service -> mapper -> entity/dto` 结构。
- 需要登录的接口从 JWT 当前用户读取身份，不要让前端传 `userId`。
- 鸿蒙端新增页面放在 `pages`，复用 UI 放在 `components`，接口请求放在 `api`。
- 图片资源只维护在资源目录中，文档不逐项说明图片。