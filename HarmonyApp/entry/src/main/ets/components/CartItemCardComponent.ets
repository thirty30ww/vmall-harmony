import { CartItem } from '../api/cartApi';
import { productsList } from '../data/productsListData';

@Component
export struct CartItemCardComponent {
  @ObjectLink item: CartItem;
  @Prop operatingItemId: number = -1;
  @Prop isDeletingItemId: number = -1;
  onToggleSelected: (item: CartItem) => void = () => {};
  onChangeQuantity: (item: CartItem, quantity: number) => void = () => {};
  onDelete: (item: CartItem) => void = () => {};

  priceText(value: number): string {
    return value.toFixed(2);
  }

  build() {
    Row({ space: 10 }) {
      Column() {
        Button(this.item.selected ? '\u2713' : '')
          .width(24)
          .height(24)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.item.selected ? Color.White : '#C9CDD4')
          .padding(0)
          .backgroundColor(this.item.selected ? '#D71920' : Color.White)
          .borderRadius(12)
          .border({ width: 1.5, color: this.item.selected ? '#D71920' : '#C9CDD4' })
          .enabled(this.operatingItemId !== this.item.id)
          .onClick(() => {
            this.onToggleSelected(this.item);
          })
      }
      .width(28)
      .height('100%')
      .justifyContent(FlexAlign.Center)

      Stack() {
        if (this.item.productSource === 'homeStatic' && this.item.productId >= 0 && this.item.productId < productsList.length) {
          Image(productsList[this.item.productId].productCardsImagePath)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Contain)
        } else if (this.item.productImage !== null && this.item.productImage.length > 0) {
          Image(this.item.productImage)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Contain)
        } else {
          Text('HUAWEI')
            .fontSize(13)
            .fontWeight(FontWeight.Bold)
            .fontColor('#8A8F99')
        }
      }
      .width(92)
      .height(92)
      .backgroundColor('#F6F7F9')
      .borderRadius(10)
      .alignContent(Alignment.Center)

      Column({ space: 7 }) {
        Text(this.item.productName)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')
          .lineHeight(20)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Text(this.item.productFeature ?? '')
          .fontSize(12)
          .fontColor('#7A7F85')
          .lineHeight(16)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')

        Row() {
          Row({ space: 2 }) {
            Text('\u00a5')
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
              .fontColor('#D71920')
            Text(this.priceText(this.item.productPrice))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#D71920')
          }
          .layoutWeight(1)

          Row() {
            Button('-')
              .width(30)
              .height(30)
              .fontSize(18)
              .fontColor('#333333')
              .padding(0)
              .backgroundColor('#F1F2F4')
              .borderRadius(15)
              .enabled(this.operatingItemId !== this.item.id && this.isDeletingItemId !== this.item.id)
              .onClick(() => {
                this.onChangeQuantity(this.item, this.item.quantity - 1);
              })

            Text(this.item.quantity.toString())
              .width(34)
              .fontSize(14)
              .fontColor('#111111')
              .textAlign(TextAlign.Center)

            Button('+')
              .width(30)
              .height(30)
              .fontSize(18)
              .fontColor('#333333')
              .padding(0)
              .backgroundColor('#F1F2F4')
              .borderRadius(15)
              .enabled(this.operatingItemId !== this.item.id && this.isDeletingItemId !== this.item.id && this.item.quantity < 99)
              .onClick(() => {
                this.onChangeQuantity(this.item, this.item.quantity + 1);
              })
          }
          .height(30)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Button(this.isDeletingItemId === this.item.id ? '\u5220\u9664\u4e2d' : '\u5220\u9664')
          .width(64)
          .height(28)
          .fontSize(13)
          .fontColor('#8A8F96')
          .padding(0)
          .backgroundColor(Color.Transparent)
          .alignSelf(ItemAlign.End)
          .enabled(this.isDeletingItemId !== this.item.id)
          .onClick(() => {
            this.onDelete(this.item);
          })
      }
      .layoutWeight(1)
      .height('100%')
    }
    .width('100%')
    .height(140)
    .padding({ left: 12, right: 12, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(16)
    .alignItems(VerticalAlign.Center)
  }
}
