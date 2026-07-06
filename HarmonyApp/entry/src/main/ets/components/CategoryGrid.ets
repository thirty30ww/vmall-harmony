import { Category, categoryData } from '../data/categoryData';

@Component
export struct CategoryGrid {
  onSelect: (category: Category) => void = () => {};

  build() {
    Scroll() {
      Row({ space: 10 }) {
        ForEach(categoryData.slice(0, 8), (item: Category) => {
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
          .width(72)
          .alignItems(HorizontalAlign.Center)
          .onClick(() => {
            this.onSelect(item);
          })
        }, (item: Category) => item.categoryName)
      }
    }
    .width('100%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }
}
