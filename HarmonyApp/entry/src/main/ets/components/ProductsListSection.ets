import { router } from '@kit.ArkUI';
import { ProductType, ProductsListData, productsList } from '../data/productsListData';

const productSectionTypes: ProductType[] = [
  ProductType.PHONE,
  ProductType.TABLET,
  ProductType.WEARABLE,
  ProductType.COMPUTER,
  ProductType.AUDIO,
  ProductType.SMART_HOME
]

@Component
export struct ProductsListSection {
  priceText(item: ProductsListData): string {
    const price = item.discountPrice ?? item.originalPrice;
    return `\u00A5${price}`;
  }

  getProductsByType(type: ProductType): ProductsListData[] {
    return productsList.filter((item: ProductsListData) => item.type === type);
  }
  productIndex(item: ProductsListData): number {
    for (let index = 0; index < productsList.length; index++) {
      if (productsList[index].productName === item.productName && productsList[index].type === item.type) {
        return index;
      }
    }
    return -1;
  }

  openProduct(item: ProductsListData) {
    const price = item.discountPrice ?? item.originalPrice;
    try {
      router.pushUrl({
        url: 'pages/ProductDetailPage',
        params: {
          productId: 0,
          source: 'homeStatic',
          localProductIndex: this.productIndex(item),
          productName: item.productName,
          productFeature: item.description,
          productPrice: price.toString()
        }
      });
    } catch (error) {
    }
  }

  @Builder
  BigProductCard(item: ProductsListData) {
    Column() {
      Image(item.productCardsImagePath)
        .width('100%')
        .height(300)
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: 8, topRight: 8 })

      Row() {
        Column({ space: 6 }) {
          Text(item.productName)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1D1D1F')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })

          Text(item.description)
            .fontSize(14)
            .fontColor('#6B7280')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)

        Text(this.priceText(item))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')
          .margin({ left: 10 })
      }
      .width('100%')
      .height(92)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)
    }
    .width('100%')
    .borderRadius(8)
    .clip(true)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.openProduct(item);
    })
  }

  @Builder
  SmallProductCard(item: ProductsListData) {
    Column({ space: 8 }) {
      Image(item.productCardsImagePath)
        .width(128)
        .height(128)
        .objectFit(ImageFit.Contain)

      Text(item.productName)
        .fontSize(14)
        .fontWeight(FontWeight.Bold)
        .fontColor('#1D1D1F')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(item.description)
        .fontSize(12)
        .fontColor('#6B7280')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Text(this.priceText(item))
        .fontSize(13)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')
    }
    .width(194)
    .height(238)
    .padding({ left: 12, right: 12, top: 14, bottom: 12 })
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .onClick(() => {
      this.openProduct(item);
    })
  }

  @Builder
  ProductTypeSection(type: ProductType) {
    if (this.getProductsByType(type).length > 0) {
      Column({ space: 12 }) {
        Row() {
          Text(type)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#111111')

          Blank()

          Row({ space: 4 }) {
            Text('\u66F4\u591A')
              .fontSize(15)
              .fontColor('#6B7280')
            Text('>')
              .fontSize(18)
              .fontColor('#9CA3AF')
          }
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')

        this.BigProductCard(this.getProductsByType(type)[0])

        if (this.getProductsByType(type).length > 1) {
          Scroll() {
            Row({ space: 10 }) {
              ForEach(this.getProductsByType(type).slice(1), (item: ProductsListData) => {
                this.SmallProductCard(item)
              }, (item: ProductsListData) => `${type}-${item.productName}`)
            }
          }
          .width('100%')
          .scrollable(ScrollDirection.Horizontal)
          .scrollBar(BarState.Off)
        }
      }
      .width('100%')
    }
  }

  build() {
    Column({ space: 22 }) {
      ForEach(productSectionTypes, (type: ProductType) => {
        this.ProductTypeSection(type)
      }, (type: ProductType) => type)
    }
    .width('100%')
  }
}