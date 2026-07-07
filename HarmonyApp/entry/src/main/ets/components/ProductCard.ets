// 商品卡片组件 —— 首页商品列表中的单个商品展示
import { Product } from '../api/homeApi';

@Component
export struct ProductCard {
  @Prop product: Product = {
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
  onProductClick: (product: Product) => void = () => {};  // 点击回调

  build() {
    Column({ space: 8 }) {
      // 商品图片
      Stack() {
        if (this.product.imageUrl) {
          Image(this.product.imageUrl)
            .width('100%')
            .height(116)
            .objectFit(ImageFit.Contain)
        } else {
          Text('HUAWEI')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#8A8F99')
        }
      }
      .width('100%')
      .height(128)
      .backgroundColor('#F7F8FA')
      .borderRadius(8)

      // 商品名称
      Text(this.product.name ?? '华为商品')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#1D2129')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')

      // 商品特性描述
      Text(this.product.feature ?? '精选推荐')
        .fontSize(11)
        .fontColor('#86909C')
        .lineHeight(16)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('100%')

      // 价格（null 时显示 "到店了解"）
      Text(this.product.price === null ? '到店了解' : `¥${this.product.price}`)
        .fontSize(15)
        .fontWeight(FontWeight.Bold)
        .fontColor('#D71920')
        .width('100%')
    }
    .padding(10)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .width('100%')
    .onClick(() => {
      this.onProductClick(this.product);
    })
  }
}
