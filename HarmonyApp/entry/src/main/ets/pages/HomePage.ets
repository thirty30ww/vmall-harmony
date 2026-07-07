// 首页页面 —— 主入口，包含底部导航栏切换（首页、分类、发现、购物车、我的）
import { router } from '@kit.ArkUI';
import { ActivityBanner } from '../components/ActivityBanner';
import { BottomNavBar } from '../components/BottomNavBar';
import { CategoryPanel } from '../components/CategoryPanel';
import { CategoryGrid } from '../components/CategoryGrid';
import { DiscoverPanel } from '../components/DiscoverPanel';
import { HomeSwiper } from '../components/HomeSwiper';
import { ProductCard } from '../components/ProductCard';
import { ProductsListSection } from '../components/ProductsListSection';
import { SearchBar } from '../components/SearchBar';
import { CartItem, CartSummary, deleteCartItem, getCart } from '../api/cartApi';
import { CartItemCardComponent } from '../components/CartItemCardComponent';
import { Category as HomeCategory } from '../data/categoryData';
import { getHomeData, getProducts, HomeData, Product } from '../api/homeApi';
import { AiFloatingButton } from '../components/AiFloatingButton';

@Entry
@Component
struct HomePage {
  // 首页数据（分类、搜索建议、活动、商品列表）
  @State homeData: HomeData = {
    categories: [],
    suggestions: [],
    activities: [],
    products: []
  };
  @State keyword: string = '';          // 搜索关键字
  @State loading: boolean = true;        // 首页加载状态
  @State errorMessage: string = '';      // 错误提示信息
  @State activeTabIndex: number = 0;     // 底部导航栏当前选中标签（0首页/1分类/2发现/3购物车/4我的）
  @State currentUsername: string = '';   // 当前用户名
  @State cartItems: CartItem[] = [];     // 购物车商品列表
  @State cartSelectedCount: number = 0;  // 购物车已选数量
  @State cartTotalAmount: number = 0;    // 购物车总金额
  @State cartLoading: boolean = false;   // 购物车加载状态
  @State cartErrorMessage: string = '';  // 购物车错误信息

  // 页面即将显示时初始化：加载用户信息、处理传入参数、加载首页数据
  aboutToAppear() {
    this.loadCurrentUser();
    const params = router.getParams() as Record<string, number>;
    let targetTab: number = -1;
    if (params) {
      targetTab = Number(params.targetTab ?? -1);
    }
    if (targetTab >= 0 && targetTab <= 4) {
      this.activeTabIndex = targetTab;
    }
    this.loadHome();
    if (this.activeTabIndex === 3) {
      this.loadCart();
    }
  }

  // 从全局存储加载当前用户信息
  loadCurrentUser() {
    const username = AppStorage.get<string>('username') ?? '';
    const phone = AppStorage.get<string>('phone') ?? '';
    this.currentUsername = username.length > 0 ? username : phone;
  }

  // 判断用户是否已登录（检查 Token 是否存在）
  isLoggedIn(): boolean {
    const token = AppStorage.get<string>('token') ?? '';
    return token.length > 0;
  }

  // 退出登录，清除全局存储并跳转登录页
  logout() {
    AppStorage.setOrCreate('token', '');
    AppStorage.setOrCreate('phone', '');
    AppStorage.setOrCreate('username', '');
    this.currentUsername = '';
    this.cartItems = [];
    this.cartSelectedCount = 0;
    this.cartTotalAmount = 0;
    this.cartErrorMessage = '';
    try {
      router.pushUrl({ url: 'pages/LoginPage' });
    } catch (error) {
      this.errorMessage = '页面跳转失败';
    }
  }

  // 加载购物车数据
  async loadCart() {
    if (!this.isLoggedIn()) {
      this.cartItems = [];
      this.cartSelectedCount = 0;
      this.cartTotalAmount = 0;
      this.cartErrorMessage = '';
      return;
    }

    this.cartLoading = true;
    this.cartErrorMessage = '';
    try {
      const summary: CartSummary = await getCart();
      const loadedItems: CartItem[] = [];
      for (let i = 0; i < summary.items.length; i++) {
        const old = summary.items[i];
        loadedItems.push({
          id: old.id, productId: old.productId, productSource: old.productSource,
          productName: old.productName, productImage: old.productImage,
          productPrice: old.productPrice, productFeature: old.productFeature,
          quantity: 1, selected: old.selected ?? false
        });
      }
      this.cartItems = loadedItems;
      this.recalcCartTotals();
    } catch (error) {
      this.cartErrorMessage = '购物车加载失败';
    } finally {
      this.cartLoading = false;
    }
  }

  // 重新计算购物车选中数量和总金额
  recalcCartTotals() {
    let selectedCount: number = 0;
    let totalAmount: number = 0;
    for (let i: number = 0; i < this.cartItems.length; i++) {
      const item = this.cartItems[i];
      if (item.selected) {
        selectedCount += item.quantity;
        totalAmount += item.productPrice * item.quantity;
      }
    }
    this.cartSelectedCount = selectedCount;
    this.cartTotalAmount = totalAmount;
  }

  // 切换购物车中某个商品的选中状态
  toggleCartSelected(item: CartItem) {
    this.cartErrorMessage = '';
    const newItems: CartItem[] = [];
    for (let i: number = 0; i < this.cartItems.length; i++) {
      const old = this.cartItems[i];
      if (old.id === item.id) {
        const clone: CartItem = {
          id: old.id, productId: old.productId, productSource: old.productSource,
          productName: old.productName, productImage: old.productImage,
          productPrice: old.productPrice, productFeature: old.productFeature,
          quantity: old.quantity, selected: !old.selected
        };
        newItems.push(clone);
      } else {
        newItems.push(old);
      }
    }
    this.cartItems = newItems;
    this.recalcCartTotals();
  }

  // 修改购物车商品数量（限制 1-99）
  changeCartQuantity(item: CartItem, quantity: number) {
    this.cartErrorMessage = '';
    const nextQuantity: number = Math.max(1, Math.min(99, quantity));
    if (nextQuantity === item.quantity) {
      return;
    }
    const newItems: CartItem[] = [];
    for (let i: number = 0; i < this.cartItems.length; i++) {
      const old = this.cartItems[i];
      if (old.id === item.id) {
        const clone: CartItem = {
          id: old.id, productId: old.productId, productSource: old.productSource,
          productName: old.productName, productImage: old.productImage,
          productPrice: old.productPrice, productFeature: old.productFeature,
          quantity: nextQuantity, selected: old.selected
        };
        newItems.push(clone);
      } else {
        newItems.push(old);
      }
    }
    this.cartItems = newItems;
    this.recalcCartTotals();
  }

  // 从购物车删除指定商品
  async deleteCartProduct(item: CartItem) {
    this.cartErrorMessage = '';
    const newItems: CartItem[] = [];
    for (let i: number = 0; i < this.cartItems.length; i++) {
      if (this.cartItems[i].id !== item.id) {
        newItems.push(this.cartItems[i]);
      }
    }
    this.cartItems = newItems;
    this.recalcCartTotals();

    try {
      await deleteCartItem(item.id);
    } catch (error) {
      this.cartErrorMessage = '删除失败';
      await this.loadCartSilent();
    }
  }

  // 静默加载购物车（用于删除失败后的回滚恢复）
  async loadCartSilent() {
    try {
      const summary: CartSummary = await getCart();
      const loadedItems: CartItem[] = [];
      for (let i = 0; i < summary.items.length; i++) {
        const old = summary.items[i];
        loadedItems.push({
          id: old.id, productId: old.productId, productSource: old.productSource,
          productName: old.productName, productImage: old.productImage,
          productPrice: old.productPrice, productFeature: old.productFeature,
          quantity: 1, selected: old.selected ?? false
        });
      }
      this.cartItems = loadedItems;
      this.recalcCartTotals();
    } catch (error) {
      console.error('购物车加载失败', error);
    }
  }

  // 判断是否所有购物车商品都已选中
  allCartSelected(): boolean {
    if (this.cartItems.length === 0) {
      return false;
    }
    for (let index = 0; index < this.cartItems.length; index++) {
      if (!this.cartItems[index].selected) {
        return false;
      }
    }
    return true;
  }

  // 全选/取消全选购物车商品
  toggleCartAll() {
    this.cartErrorMessage = '';
    const nextSelected: boolean = !this.allCartSelected();
    const newItems: CartItem[] = [];
    for (let i: number = 0; i < this.cartItems.length; i++) {
      const old = this.cartItems[i];
      const clone: CartItem = {
        id: old.id, productId: old.productId, productSource: old.productSource,
        productName: old.productName, productImage: old.productImage,
        productPrice: old.productPrice, productFeature: old.productFeature,
        quantity: old.quantity, selected: nextSelected
      };
      newItems.push(clone);
    }
    this.cartItems = newItems;
    this.recalcCartTotals();
  }

  // 将价格格式化为两位小数
  priceText(value: number): string {
    return value.toFixed(2);
  }

  // 获取当前 Tab 的中文名称
  tabName(): string {
    switch (this.activeTabIndex) {
      case 1:
        return '分类';
      case 2:
        return '发现';
      case 3:
        return '购物车';
      case 4:
        return '我的';
      default:
        return '首页';
    }
  }

  // 加载首页数据（从后端接口获取）
  async loadHome() {
    this.loading = true;
    this.errorMessage = '';
    try {
      this.homeData = await getHomeData();
    } catch (error) {
      this.errorMessage = '首页加载失败，请检查后端服务';
    } finally {
      this.loading = false;
    }
  }

  // 搜索商品
  async searchProducts(keyword: string) {
    this.loading = true;
    this.errorMessage = '';
    try {
      const products = await getProducts(keyword);
      this.homeData = {
        categories: this.homeData.categories,
        suggestions: this.homeData.suggestions,
        activities: this.homeData.activities,
        products: products
      };
    } catch (error) {
      this.errorMessage = '搜索失败，请稍后重试';
    } finally {
      this.loading = false;
    }
  }

  // 打开商品详情页
  openProduct(product: Product) {
    try {
      router.pushUrl({
        url: 'pages/ProductDetailPage',
        params: {
          productId: product.id,
          source: 'home',
          productName: product.name ?? '',
          productImage: product.imageUrl ?? '',
          productFeature: product.feature ?? '',
          productPrice: product.price === null ? '' : product.price.toString()
        }
      });
    } catch (error) {
      this.errorMessage = '页面跳转失败';
    }
  }

  // ===== 首页内容区域 Builder =====
  @Builder
  homeContent() {
    Scroll() {
      Column({ space: 18 }) {
        // 轮播图区域
        Column() {
          HomeSwiper()
        }
        .width('100%')
        .padding({ left: 16, right: 16 })

        // 分类导航 + 活动横幅 + 商品列表区域
        Column({ space: 18 }) {
          // 顶部分类快捷入口
          CategoryGrid({
            onSelect: (category: HomeCategory) => {
              this.keyword = category.categoryName;
              this.searchProducts(this.keyword);
            }
          })

          // 活动横幅轮播
          ActivityBanner({ activities: this.homeData.activities })

          // 商品分类区块（手机/平板/穿戴等）
          ProductsListSection()

          // 商品列表网格
          Grid() {
            ForEach(this.homeData.products, (item: Product) => {
              GridItem() {
                ProductCard({
                  product: item,
                  onProductClick: (product: Product) => {
                    this.openProduct(product);
                  }
                })
              }
            }, (item: Product) => item.id.toString())
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(10)
          .rowsGap(10)
          .width('100%')
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .padding({ top: 4, bottom: 24 })
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }

  // ===== 购物车空状态 Builder =====
  @Builder
  cartEmptyContent(text: string, buttonText: string, targetLogin: boolean) {
    Column({ space: 14 }) {
      // 购物车图标占位
      Stack() {
        Text('\uD83D\uDED2')
          .fontSize(76)
          .fontColor('#CDD3DC')
      }
      .width(120)
      .height(92)
      .alignContent(Alignment.Center)

      // 提示文字
      Text(text)
        .fontSize(16)
        .fontColor('#7A7F85')
        .textAlign(TextAlign.Center)

      // 操作按钮（去登录/去购物）
      Button(buttonText)
        .width(150)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#D71920')
        .borderRadius(25)
        .onClick(() => {
          if (targetLogin) {
            try {
              router.pushUrl({ url: 'pages/LoginPage' });
            } catch (error) {
              this.errorMessage = '页面跳转失败';
            }
          } else {
            this.activeTabIndex = 0;
          }
        })
    }
    .layoutWeight(1)
    .width('100%')
    .padding({ top: 68, left: 16, right: 16 })
    .alignItems(HorizontalAlign.Center)
  }

  // ===== 购物车主内容 Builder =====
  @Builder
  cartContent() {
    // 未登录 -> 显示空状态提示去登录
    if (!this.isLoggedIn()) {
      this.cartEmptyContent('请先登录后查看购物车', '去登录', true)
    } else if (this.cartLoading && this.cartItems.length === 0) {
      // 加载中
      Column() {
        Text('购物车加载中')
          .fontSize(15)
          .fontColor('#86909C')
      }
      .layoutWeight(1)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    } else if (this.cartErrorMessage.length > 0 && this.cartItems.length === 0) {
      // 加载出错 -> 显示重试按钮
      Column({ space: 12 }) {
        Text(this.cartErrorMessage)
          .fontSize(15)
          .fontColor('#86909C')
        Button('重试')
          .width(120)
          .height(42)
          .fontColor(Color.White)
          .backgroundColor('#111111')
          .borderRadius(21)
          .onClick(() => {
            this.loadCart();
          })
      }
      .layoutWeight(1)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    } else if (this.cartItems.length === 0) {
      // 购物车为空
      this.cartEmptyContent('您的购物车暂时没有商品', '去购物', false)
    } else {
      // 购物车有商品 -> 展示列表 + 底部结算栏
      Column() {
        // 商品列表
        List({ space: 12 }) {
          ForEach(this.cartItems, (item: CartItem) => {
            ListItem() {
              CartItemCardComponent({
                item: item,
                onToggleSelected: (cartItem: CartItem) => {
                  this.toggleCartSelected(cartItem);
                },
                onChangeQuantity: (cartItem: CartItem, quantity: number) => {
                  this.changeCartQuantity(cartItem, quantity);
                },
                onDelete: (cartItem: CartItem) => {
                  this.deleteCartProduct(cartItem);
                }
              })
            }
          }, (item: CartItem) => item.id.toString() + '_' + item.selected.toString() + '_' + item.quantity.toString())
        }
        .layoutWeight(1)
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .scrollBar(BarState.Off)

        // 底部结算栏
        Row() {
          // 全选按钮
          Row({ space: 8 }) {
            Button(this.allCartSelected() ? '\u2713' : '')
              .width(24)
              .height(24)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.allCartSelected() ? Color.White : '#C9CDD4')
              .padding(0)
              .backgroundColor(this.allCartSelected() ? '#D71920' : Color.White)
              .borderRadius(12)
              .border({ width: 1.5, color: this.allCartSelected() ? '#D71920' : '#C9CDD4' })
              .onClick(() => {
                this.toggleCartAll();
              })
            Text('全选')
              .fontSize(15)
              .fontColor('#111111')
          }
          .height('100%')
          .alignItems(VerticalAlign.Center)

          Blank()

          // 合计金额
          Text('合计: ')
            .fontSize(14)
            .fontColor('#111111')
          Text('¥' + this.priceText(this.cartTotalAmount))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#D71920')

          // 结算按钮
          Button('结算(' + this.cartSelectedCount.toString() + ')')
            .width(88)
            .height(34)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .backgroundColor('#D71920')
            .borderRadius(17)
            .margin({ left: 12 })
            .enabled(this.cartSelectedCount > 0)
            .opacity(this.cartSelectedCount > 0 ? 1 : 0.6)
        }
        .width('100%')
        .height(66)
        .padding({ left: 16, right: 12 })
        .backgroundColor(Color.White)
        .alignItems(VerticalAlign.Center)
      }
      .layoutWeight(1)
      .width('100%')
    }
  }

  // ===== 我的页面 —— 资产项 Builder =====
  @Builder
  myAssetItem(icon: Resource, title: string) {
    Column({ space: 4 }) {
      Image(icon)
        .width(34)
        .height(34)
        .objectFit(ImageFit.Contain)

      Text(title)
        .fontSize(14)
        .fontColor('#111111')
        .textAlign(TextAlign.Center)

      Text('--')
        .fontSize(12)
        .fontColor('#111111')
        .textAlign(TextAlign.Center)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  // ===== 我的页面 —— 订单项 Builder =====
  @Builder
  myOrderItem(icon: Resource, title: string) {
    Column({ space: 8 }) {
      Image(icon)
        .width(31)
        .height(31)
        .objectFit(ImageFit.Contain)

      Text(title)
        .fontSize(14)
        .fontColor('#111111')
        .textAlign(TextAlign.Center)
        .maxLines(1)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  // ===== 我的页面 —— 服务项 Builder =====
  @Builder
  myServiceItem(icon: Resource, title: string) {
    Column({ space: 8 }) {
      Image(icon)
        .width(31)
        .height(31)
        .objectFit(ImageFit.Contain)

      Text(title)
        .fontSize(14)
        .fontColor('#222222')
        .textAlign(TextAlign.Center)
        .maxLines(1)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  // ===== 我的页面 —— 列表行 Builder =====
  @Builder
  myListRow(icon: Resource, title: string) {
    Row() {
      Image(icon)
        .width(28)
        .height(28)
        .objectFit(ImageFit.Contain)
        .margin({ right: 12 })

      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')
        .layoutWeight(1)

      Text('›')
        .fontSize(20)
        .fontColor('#C9CDD4')
    }
    .width('100%')
    .height(64)
    .alignItems(VerticalAlign.Center)
  }

  // ===== 我的页面 —— 退出登录行 Builder =====
  @Builder
  logoutRow() {
    Row() {
      Image($r('app.media.logout'))
        .width(28)
        .height(28)
        .objectFit(ImageFit.Contain)
        .margin({ right: 12 })

      Text('退出登录')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#D71920')
        .layoutWeight(1)

      Text('›')
        .fontSize(20)
        .fontColor('#C9CDD4')
    }
    .width('100%')
    .height(64)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.logout();
    })
  }

  // ===== "我的"页面内容 Builder =====
  @Builder
  myContent() {
    Scroll() {
      Column({ space: 14 }) {
        // 用户头像和名称/登录入口
        Column() {
          Row({ space: 14 }) {
            Image($r('app.media.avatar'))
              .width(58)
              .height(58)
              .borderRadius(29)
              .objectFit(ImageFit.Cover)

            Text(this.currentUsername.length > 0 ? this.currentUsername : '登录/注册')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
              .layoutWeight(1)
          }
          .width('100%')
          .height(84)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            if (this.currentUsername.length > 0) {
              return;
            }
            try {
              router.pushUrl({ url: 'pages/LoginPage' });
            } catch (error) {
              this.errorMessage = '页面跳转失败';
            }
          })

          Divider()
            .strokeWidth(1)
            .color('#E1E1E1')

          // 会员频道入口
          Row() {
            Text('开启智慧生活')
              .fontSize(16)
              .fontColor('#7A7F85')
              .layoutWeight(1)

            Text('会员频道')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#7B5B20')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#E7C987')
              .borderRadius(15)
          }
          .width('100%')
          .height(52)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 12, bottom: 4 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        // 资产卡片（积分/优惠券/代金券/优购码）
        Row() {
          this.myAssetItem($r('app.media.jifen'), '积分')
          this.myAssetItem($r('app.media.youhui'), '优惠券')
          this.myAssetItem($r('app.media.daijing'), '代金券')
          this.myAssetItem($r('app.media.bao'), '优购码')
        }
        .width('100%')
        .height(104)
        .padding({ left: 18, right: 18 })
        .backgroundColor(Color.White)
        .borderRadius(18)
        .alignItems(VerticalAlign.Center)

        // 我的订单
        Column({ space: 12 }) {
          Row() {
            Text('我的订单')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
              .layoutWeight(1)

            Text('全部订单')
              .fontSize(16)
              .fontColor('#7A7F85')

            Text('›')
              .fontSize(18)
              .fontColor('#8A8F96')
              .margin({ left: 4 })
          }
          .height(36)
          .alignItems(VerticalAlign.Center)

          // 订单状态入口（待付款/待收货/待评价/售后退款/回收单）
          Row() {
            this.myOrderItem($r('app.media.daifukuan'), '待付款')
            this.myOrderItem($r('app.media.daishouhuo'), '待收货')
            this.myOrderItem($r('app.media.pingjia'), '待评价')
            this.myOrderItem($r('app.media.shouhou'), '售后退款')
            this.myOrderItem($r('app.media.huishou'), '回收单')
          }
          .width('100%')
          .height(58)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 26, bottom: 18 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        // 常用服务
        Column({ space: 14 }) {
          Row() {
            Text('常用服务')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
              .layoutWeight(1)

            Text('联系客服')
              .fontSize(16)
              .fontColor('#7A7F85')

            Text('›')
              .fontSize(18)
              .fontColor('#8A8F96')
              .margin({ left: 4 })
          }
          .height(36)
          .alignItems(VerticalAlign.Center)

          // 服务入口（官方售后/服务商店/保值换新/价保申请）
          Row() {
            this.myServiceItem($r('app.media.shouhou'), '官方售后')
            this.myServiceItem($r('app.media.shangdian'), '服务商店')
            this.myServiceItem($r('app.media.baozhi'), '保值换新')
            this.myServiceItem($r('app.media.baojia'), '价保申请')
          }
          .width('100%')
          .height(62)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 26, bottom: 18 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        // 问题和建议 + 商城公告
        Column() {
          this.myListRow($r('app.media.wenti'), '问题和建议')
          Divider()
            .strokeWidth(1)
            .color('#ECECEC')
            .margin({ left: 40 })
          this.myListRow($r('app.media.gonggao'), '商城公告')
        }
        .width('100%')
        .padding({ left: 14, right: 14 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        // 设置 + 退出登录
        Column() {
          this.myListRow($r('app.media.shezhi'), '设置')
          if (this.isLoggedIn()) {
            Divider()
              .strokeWidth(1)
              .color('#ECECEC')
              .margin({ left: 40 })
            this.logoutRow()
          }
        }
        .width('100%')
        .padding({ left: 14, right: 14 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        // 底部法律信息
        Text('隐私政策  |  用户协议  |  关于Cookie\n营业执照    备案主体编号：44201919072182\n粤ICP备19015064号   粤公网安备44190002003939号\n增值电信业务经营许可证：粤B2-20190762')
          .fontSize(13)
          .lineHeight(22)
          .fontColor('#A5A8AD')
          .textAlign(TextAlign.Center)
          .width('100%')
          .padding({ left: 8, right: 8, top: 18, bottom: 18 })
          .backgroundColor(Color.White)
          .borderRadius(18)
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }

  // ===== 等待中的模块占位 Builder =====
  @Builder
  waitingContent() {
    Column({ space: 12 }) {
      Text(this.tabName())
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')

      Text('当前模块等待完成')
        .fontSize(15)
        .fontColor('#86909C')
    }
    .layoutWeight(1)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  // ===== 顶部导航栏 Builder（非首页时显示）=====
  @Builder
  topBar() {
    if (this.activeTabIndex === 1 || this.activeTabIndex === 3 || this.activeTabIndex === 4) {
      Row() {
        Text(this.activeTabIndex === 1 ? '分类' : this.activeTabIndex === 3 ? '购物车' : '我的')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')

        Blank()
          .layoutWeight(1)

        // "我的"页面右上角的邮件图标
        if (this.activeTabIndex === 4) {
          Stack() {
            Image($r('app.media.youjian'))
              .width(25)
              .height(25)
              .objectFit(ImageFit.Contain)
          }
          .width(48)
          .height(48)
          .backgroundColor('#E8EAED')
          .borderRadius(24)
        }
      }
      .width('100%')
      .height(58)
      .alignItems(VerticalAlign.Center)
      .padding({ left: 16, right: 16, top: 8, bottom: 2 })
    }
  }

  // ===== 页面主构建 =====
  build() {
    Stack() {
      Column() {
        // 首页显示搜索栏，其他 Tab 显示顶部标题栏
        if (this.activeTabIndex === 0) {
          SearchBar({
            keyword: $keyword,
            onSearch: (value: string) => {
              this.searchProducts(value);
            }
          })
          .width('100%')
          .padding({ left: 16, right: 16, top: 8, bottom: 14 })
        } else {
          this.topBar()
        }

        // 根据 Tab 切换不同内容
        if (this.activeTabIndex === 0) {
          this.homeContent()       // 首页
        } else if (this.activeTabIndex === 1) {
          CategoryPanel()          // 分类
            .layoutWeight(1)
        } else if (this.activeTabIndex === 2) {
          DiscoverPanel()          // 发现
            .layoutWeight(1)
        } else if (this.activeTabIndex === 3) {
          this.cartContent()       // 购物车
        } else if (this.activeTabIndex === 4) {
          this.myContent()         // 我的
        } else {
          this.waitingContent()
        }

        // 底部导航栏
        BottomNavBar({ activeIndex: $activeTabIndex, onTabChange: (index: number) => {
          if (index === 3) {
            this.loadCart();
          } else if (index === 4) {
            this.loadCurrentUser();
          }
        } })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F6F8')

      // AI 智能导购悬浮按钮
      AiFloatingButton({ initBottom: 130 })
    }
    .width('100%')
    .height('100%')
  }
}
