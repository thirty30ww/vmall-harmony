// 商品详情页 —— 展示商品图片、价格信息、支持加入购物车
import { router } from '@kit.ArkUI';
import { addCartItem, AddCartItemRequest } from '../api/cartApi';
import { getProductById, Product } from '../api/homeApi';
import { productsList } from '../data/productsListData';
import { AiFloatingButton } from '../components/AiFloatingButton';

// 商品详情页路由参数类型
interface ProductDetailParams {
  productId?: number | string;
  source?: string;
  productName?: string;
  productImage?: string;
  productFeature?: string;
  productPrice?: string;
  localProductIndex?: number | string;
}

// 创建空白商品对象
function emptyProduct(): Product {
  return {
    id: 0,
    prdId: null,
    sbomCode: null,
    name: null,
    feature: null,
    price: null,
    imageUrl: null,
    productUrl: null,
    rawText: null,
    scrapedAt: null
  };
}

// 根据路由参数构造降级商品数据（后端数据加载失败时用作兜底）
function fallbackProduct(params: ProductDetailParams): Product {
  const priceText: string = params.productPrice ?? '';
  const priceValue: number = Number(priceText);
  const price: number | null = priceText.length > 0 && priceValue > 0 ? priceValue : null;

  return {
    id: Number(params.productId ?? 0),
    prdId: null,
    sbomCode: null,
    name: params.productName ?? null,
    feature: params.productFeature ?? null,
    price: price,
    imageUrl: params.productImage ?? null,
    productUrl: null,
    rawText: null,
    scrapedAt: null
  };
}

@Entry
@Component
struct ProductDetailPage {
  @State product: Product = emptyProduct();  // 当前商品数据
  @State source: string = 'home';             // 来源（home/category/homeStatic）
  @State localProductIndex: number = -1;      // 本地静态商品索引
  @State hasProduct: boolean = false;         // 是否已有商品数据
  @State loading: boolean = true;             // 加载状态
  @State errorMessage: string = '';           // 错误信息
  @State addingCart: boolean = false;         // 正在加入购物车
  @State cartNotice: string = '';             // 购物车操作提示

  // 页面初始化：从路由参数获取商品信息
  aboutToAppear() {
    const params = router.getParams() as ProductDetailParams;
    const productId: number = Number(params.productId ?? 0);
    const sourceParam: string = params.source ?? 'home';
    this.source = sourceParam === 'category' ? 'category' : sourceParam === 'homeStatic' ? 'homeStatic' : 'home';
    this.localProductIndex = Number(params.localProductIndex ?? -1);
    this.product = fallbackProduct(params);
    this.hasProduct = this.product.name !== null || this.product.imageUrl !== null;

    // 本地静态商品直接展示，其他来源调用接口加载
    if (this.localProductIndex >= 0 && this.localProductIndex < productsList.length) {
      this.loading = false;
    } else if (this.source === 'home' && productId > 0) {
      this.loadProduct(productId);
    } else {
      this.loading = false;
    }
  }

  // 根据 ID 从后端加载商品详情
  async loadProduct(productId: number) {
    this.loading = true;
    this.errorMessage = '';
    try {
      const detail: Product = await getProductById(productId);
      this.product = detail;
      this.hasProduct = true;
    } catch (error) {
      if (!this.hasProduct) {
        this.errorMessage = '商品详情加载失败';
      }
    } finally {
      this.loading = false;
    }
  }

  // 来源文本标签
  sourceLabel(): string {
    return this.source === 'category' ? '分类' : '首页';
  }

  // 跳转到首页指定 Tab
  goHomeTab(tabIndex: number) {
    try {
      router.pushUrl({
        url: 'pages/HomePage',
        params: {
          targetTab: tabIndex
        }
      });
    } catch (error) {
      this.errorMessage = '页面跳转失败';
    }
  }

  // 添加到购物车
  async handleAddCart() {
    const token = AppStorage.get<string>('token') ?? '';
    if (token.length === 0) {
      try {
        router.pushUrl({ url: 'pages/LoginPage' });
      } catch (error) {
        this.cartNotice = '请先登录';
      }
      return;
    }

    const productId: number = this.localProductIndex >= 0 ? this.localProductIndex : Number(this.product.id ?? 0);
    const productSource: string = this.localProductIndex >= 0 ? 'homeStatic' : this.source;
    const requestBody: AddCartItemRequest = {
      productId: productId,
      productSource: productSource,
      productName: this.product.name ?? '华为商品',
      productImage: this.product.imageUrl,
      productPrice: this.product.price === null ? 0 : this.product.price,
      productFeature: this.product.feature
    };

    this.addingCart = true;
    this.cartNotice = '';
    try {
      await addCartItem(requestBody);
      this.cartNotice = '已加入购物车';
    } catch (error) {
      this.cartNotice = '加入购物车失败';
    } finally {
      this.addingCart = false;
    }
  }

  // ===== 顶部圆形按钮 Builder（返回/更多）=====
  @Builder
  topButton(text: string, isBack: boolean) {
    Stack() {
      Text(text)
        .fontSize(24)
        .fontColor('#111111')
        .textAlign(TextAlign.Center)
    }
    .width(46)
    .height(46)
    .backgroundColor('#F2F3F5')
    .borderRadius(23)
    .alignContent(Alignment.Center)
    .onClick(() => {
      if (isBack) {
        router.back();
      }
    })
  }

  // ===== 来源图标 Builder =====
  @Builder
  sourceIcon() {
    if (this.source === 'category') {
      Image($r('app.media.tabBuilder_FenLei'))
        .width(28)
        .height(28)
        .objectFit(ImageFit.Contain)
    } else {
      Image($r('app.media.tabBuilder_ShouYe'))
        .width(28)
        .height(28)
        .objectFit(ImageFit.Contain)
    }
  }

  // ===== 底部导航项 Builder =====
  @Builder
  bottomNavItem(kind: string, label: string) {
    Column({ space: 2 }) {
      if (kind === 'cart') {
        Image($r('app.media.tabBuilder_GouWuChe'))
          .width(28)
          .height(28)
          .objectFit(ImageFit.Contain)
      } else {
        this.sourceIcon()
      }

      Text(label)
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')
    }
    .width(58)
    .height(52)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      if (kind === 'cart') {
        this.goHomeTab(3);
      } else {
        this.goHomeTab(this.source === 'category' ? 1 : 0);
      }
    })
  }

  // ===== 商品图片展示区域 Builder =====
  @Builder
  productImageBlock() {
    Stack() {
      if (this.localProductIndex >= 0 && this.localProductIndex < productsList.length) {
        // 使用本地静态商品图片
        Image(productsList[this.localProductIndex].productCardsImagePath)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
      } else if (this.product.imageUrl) {
        // 使用后端返回的商品图片
        Image(this.product.imageUrl)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
      } else {
        // 无图片时显示占位文字
        Text('HUAWEI')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor('#8A8F99')
      }
    }
    .width('100%')
    .height(360)
    .backgroundColor(Color.White)
    .alignContent(Alignment.Center)
  }

  // ===== 商品信息卡片 Builder =====
  @Builder
  productInfoCard() {
    Column({ space: 12 }) {
      // 价格
      Row({ space: 4 }) {
        Text('¥')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#D71920')
          .baselineOffset(-2)

        Text(this.product.price === null ? '--' : this.product.price.toString())
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .fontColor('#D71920')
      }
      .width('100%')
      .alignItems(VerticalAlign.Bottom)

      // 商品名称
      Text(this.product.name ?? '华为商品')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#222222')
        .lineHeight(30)
        .width('100%')

      // 商品特性描述
      Text(this.product.feature ?? '精选华为商城商品，更多规格和活动信息请以页面实际数据为准')
        .fontSize(16)
        .fontColor('#333333')
        .lineHeight(25)
        .width('100%')

      // 活动提示
      Text('①购机赠好礼 ②晒单抽好礼，查看活动详情>>')
        .fontSize(14)
        .fontColor('#D71920')
        .lineHeight(20)
        .width('100%')

      // 购物车操作提示
      if (this.cartNotice.length > 0) {
        Text(this.cartNotice)
          .fontSize(14)
          .fontColor('#D71920')
          .width('100%')
      }
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 18, bottom: 18 })
    .backgroundColor(Color.White)
    .borderRadius({ topLeft: 16, topRight: 16 })
  }

  // ===== 底部操作栏 Builder =====
  @Builder
  bottomBar() {
    Row() {
      // 来源入口按钮
      this.bottomNavItem('source', this.sourceLabel())
      // 购物车入口按钮
      this.bottomNavItem('cart', '购物车')

      // 加入购物车按钮
      Button(this.addingCart ? '加入中' : '加入购物车')
        .layoutWeight(1)
        .height(50)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#FF9F21')
        .borderRadius(25)
        .onClick(() => {
          this.handleAddCart();
        })
    }
    .width('100%')
    .height(70)
    .padding({ left: 8, right: 10, top: 8, bottom: 8 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  // ===== 页面主构建 =====
  build() {
    Stack() {
      Column() {
        Stack() {
          // 可滚动内容区域
          Scroll() {
            Column() {
              if (this.loading && !this.hasProduct) {
                // 加载中
                Column() {
                  Text('加载中')
                    .fontSize(15)
                    .fontColor('#86909C')
                }
                .width('100%')
                .height(420)
                .justifyContent(FlexAlign.Center)
              } else if (this.errorMessage.length > 0 && !this.hasProduct) {
                // 加载失败
                Column() {
                  Text(this.errorMessage)
                    .fontSize(15)
                    .fontColor('#86909C')
                }
                .width('100%')
                .height(420)
                .justifyContent(FlexAlign.Center)
              } else {
                // 商品图片
                this.productImageBlock()
                // 商品信息卡片
                this.productInfoCard()
              }
            }
            .width('100%')
            .padding({ bottom: 76 })
          }
          .width('100%')
          .height('100%')
          .scrollBar(BarState.Off)

          // 顶部浮动按钮层
          Column() {
            Row() {
              this.topButton('<', true)  // 返回按钮
              Blank()
              this.topButton('...', false) // 更多按钮
            }
            .width('100%')
            .padding({ left: 12, right: 12, top: 0 })

            Blank()

            // 底部操作栏
            this.bottomBar()
          }
          .width('100%')
          .height('100%')
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F2F3F5')

      // AI 智能导购悬浮按钮
      AiFloatingButton({ initBottom: 24 })
    }
    .width('100%')
    .height('100%')
  }
}
