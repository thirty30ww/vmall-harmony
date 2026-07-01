import { Category, categoryData } from '../data/categoryData';

@Component
export struct CategoryGrid {
  onSelect: (category: Category) => void = () => {};

  build() {
    Grid() {
      ForEach(categoryData, (item: Category) => {
        GridItem() {
          Column({ space: 6 }) {
            Image(item.categoryImagePath)
              .width(42)
              .height(42)
              .objectFit(ImageFit.Contain)

            Text(item.categoryName)
              .fontSize(12)
              .fontColor('#1D2129')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            this.onSelect(item);
          })
        }
      }, (item: Category) => item.categoryName)
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .columnsGap(10)
    .rowsGap(14)
    .height(304)
    .width('100%')
  }
}