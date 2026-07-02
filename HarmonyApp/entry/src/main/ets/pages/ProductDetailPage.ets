import { router } from '@kit.ArkUI';
import { addCartItem, AddCartItemRequest } from '../api/cartApi';
import { getProductById, Product } from '../api/homeApi';
import { productsList } from '../data/productsListData';

interface ProductDetailParams {
  productId?: number | string;
  source?: string;
  productName?: string;
  productImage?: string;
  productFeature?: string;
  productPrice?: string;
  localProductIndex?: number | string;
}

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
  @State product: Product = emptyProduct();
  @State source: string = 'home';
  @State localProductIndex: number = -1;
  @State hasProduct: boolean = false;
  @State loading: boolean = true;
  @State errorMessage: string = '';
  @State addingCart: boolean = false;
  @State cartNotice: string = '';

  aboutToAppear() {
    const params = router.getParams() as ProductDetailParams;
    const productId: number = Number(params.productId ?? 0);
    const sourceParam: string = params.source ?? 'home';
    this.source = sourceParam === 'category' ? 'category' : sourceParam === 'homeStatic' ? 'homeStatic' : 'home';
    this.localProductIndex = Number(params.localProductIndex ?? -1);
    this.product = fallbackProduct(params);
    this.hasProduct = this.product.name !== null || this.product.imageUrl !== null;

    if (this.localProductIndex >= 0 && this.localProductIndex < productsList.length) {
      this.loading = false;
    } else if (this.source === 'home' && productId > 0) {
      this.loadProduct(productId);
    } else {
      this.loading = false;
    }
  }

  async loadProduct(productId: number) {
    this.loading = true;
    this.errorMessage = '';
    try {
      const detail: Product = await getProductById(productId);
      this.product = detail;
      this.hasProduct = true;
    } catch (error) {
      if (!this.hasProduct) {
        this.errorMessage = '\u5546\u54c1\u8be6\u60c5\u52a0\u8f7d\u5931\u8d25';
      }
    } finally {
      this.loading = false;
    }
  }

  sourceLabel(): string {
    return this.source === 'category' ? '\u5206\u7c7b' : '\u9996\u9875';
  }

  goHomeTab(tabIndex: number) {
    try {
      router.pushUrl({
        url: 'pages/HomePage',
        params: {
          targetTab: tabIndex
        }
      });
    } catch (error) {
      this.errorMessage = '\u9875\u9762\u8df3\u8f6c\u5931\u8d25';
    }
  }

  async handleAddCart() {
    const token = AppStorage.get<string>('token') ?? '';
    if (token.length === 0) {
      try {
        router.pushUrl({ url: 'pages/LoginPage' });
      } catch (error) {
        this.cartNotice = '\u8bf7\u5148\u767b\u5f55';
      }
      return;
    }

    const productId: number = this.localProductIndex >= 0 ? this.localProductIndex : Number(this.product.id ?? 0);
    const productSource: string = this.localProductIndex >= 0 ? 'homeStatic' : this.source;
    const requestBody: AddCartItemRequest = {
      productId: productId,
      productSource: productSource,
      productName: this.product.name ?? '\u534e\u4e3a\u5546\u54c1',
      productImage: this.product.imageUrl,
      productPrice: this.product.price === null ? 0 : this.product.price,
      productFeature: this.product.feature,
      quantity: 1
    };

    this.addingCart = true;
    this.cartNotice = '';
    try {
      await addCartItem(requestBody);
      this.cartNotice = '\u5df2\u52a0\u5165\u8d2d\u7269\u8f66';
    } catch (error) {
      this.cartNotice = '\u52a0\u5165\u8d2d\u7269\u8f66\u5931\u8d25';
    } finally {
      this.addingCart = false;
    }
  }

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

  @Builder
  productImageBlock() {
    Stack() {
      if (this.localProductIndex >= 0 && this.localProductIndex < productsList.length) {
        Image(productsList[this.localProductIndex].productCardsImagePath)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
      } else if (this.product.imageUrl) {
        Image(this.product.imageUrl)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
      } else {
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

  @Builder
  productInfoCard() {
    Column({ space: 12 }) {
      Row({ space: 4 }) {
        Text('\u00a5')
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

      Text(this.product.name ?? '\u534e\u4e3a\u5546\u54c1')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#222222')
        .lineHeight(30)
        .width('100%')

      Text(this.product.feature ?? '\u7cbe\u9009\u534e\u4e3a\u5546\u57ce\u5546\u54c1\uff0c\u66f4\u591a\u89c4\u683c\u548c\u6d3b\u52a8\u4fe1\u606f\u8bf7\u4ee5\u9875\u9762\u5b9e\u9645\u6570\u636e\u4e3a\u51c6')
        .fontSize(16)
        .fontColor('#333333')
        .lineHeight(25)
        .width('100%')

      Text('\u2460\u8d2d\u673a\u8d60\u597d\u793c \u2461\u6652\u5355\u62bd\u597d\u793c\uff0c\u67e5\u770b\u6d3b\u52a8\u8be6\u60c5>>')
        .fontSize(14)
        .fontColor('#D71920')
        .lineHeight(20)
        .width('100%')

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

  @Builder
  bottomBar() {
    Row() {
      this.bottomNavItem('source', this.sourceLabel())
      this.bottomNavItem('cart', '\u8d2d\u7269\u8f66')

      Button(this.addingCart ? '\u52a0\u5165\u4e2d' : '\u52a0\u5165\u8d2d\u7269\u8f66')
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

  build() {
    Column() {
      Stack() {
        Scroll() {
          Column() {
            if (this.loading && !this.hasProduct) {
              Column() {
                Text('\u52a0\u8f7d\u4e2d')
                  .fontSize(15)
                  .fontColor('#86909C')
              }
              .width('100%')
              .height(420)
              .justifyContent(FlexAlign.Center)
            } else if (this.errorMessage.length > 0 && !this.hasProduct) {
              Column() {
                Text(this.errorMessage)
                  .fontSize(15)
                  .fontColor('#86909C')
              }
              .width('100%')
              .height(420)
              .justifyContent(FlexAlign.Center)
            } else {
              this.productImageBlock()
              this.productInfoCard()
            }
          }
          .width('100%')
          .padding({ bottom: 76 })
        }
        .width('100%')
        .height('100%')
        .scrollBar(BarState.Off)

        Column() {
          Row() {
            this.topButton('<', true)

            Blank()

            this.topButton('...', false)
          }
          .width('100%')
          .padding({ left: 12, right: 12, top: 0 })

          Blank()

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
  }
}