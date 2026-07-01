import { router } from '@kit.ArkUI';
import { getProductById, Product } from '../api/homeApi';

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

@Entry
@Component
struct ProductDetailPage {
  @State product: Product = emptyProduct();
  @State hasProduct: boolean = false;
  @State loading: boolean = true;
  @State errorMessage: string = '';

  aboutToAppear() {
    const params = router.getParams() as Record<string, number>;
    const productId = Number(params.productId ?? 0);
    this.loadProduct(productId);
  }

  async loadProduct(productId: number) {
    this.loading = true;
    this.errorMessage = '';
    try {
      this.product = await getProductById(productId);
      this.hasProduct = true;
    } catch (error) {
      this.errorMessage = '商品详情加载失败';
      this.hasProduct = false;
    } finally {
      this.loading = false;
    }
  }

  build() {
    Column() {
      Row({ space: 12 }) {
        Button('<')
          .width(40)
          .height(40)
          .fontSize(18)
          .fontColor('#111111')
          .backgroundColor('#F2F3F5')
          .borderRadius(20)
          .onClick(() => {
            router.back();
          })

        Text('商品详情')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')

        Blank()
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })

      Scroll() {
        Column({ space: 16 }) {
          if (this.loading) {
            Text('加载中')
              .fontSize(14)
              .fontColor('#86909C')
              .padding(32)
          } else if (this.errorMessage.length > 0) {
            Text(this.errorMessage)
              .fontSize(14)
              .fontColor('#86909C')
              .padding(32)
          } else if (this.hasProduct) {
            Stack() {
              if (this.product.imageUrl) {
                Image(this.product.imageUrl)
                  .width('100%')
                  .height(260)
                  .objectFit(ImageFit.Contain)
              } else {
                Text('HUAWEI')
                  .fontSize(28)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#8A8F99')
              }
            }
            .width('100%')
            .height(280)
            .backgroundColor(Color.White)
            .borderRadius(8)

            Column({ space: 12 }) {
              Text(this.product.name ?? '华为商品')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .fontColor('#111111')
                .width('100%')

              Text(this.product.feature ?? '精选推荐')
                .fontSize(14)
                .fontColor('#4E5969')
                .lineHeight(22)
                .width('100%')

              Text(this.product.price === null ? '到店了解' : `¥${this.product.price}`)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#D71920')
                .width('100%')

              Text(`商品编号：${this.product.prdId ?? '-'}`)
                .fontSize(13)
                .fontColor('#86909C')
                .width('100%')

              Text(`规格编码：${this.product.sbomCode ?? '-'}`)
                .fontSize(13)
                .fontColor('#86909C')
                .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(8)
          }
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 24 })
      }
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6F8')
  }
}
