import { Category, categoryData } from '../data/categoryData';

@Component
export struct CategoryGrid {
  onSelect: (category: Category) => void = () => {};

  get columns(): Category[][] {
    const result: Category[][] = [];
    for (let i = 0; i < categoryData.length; i += 2) {
      result.push([categoryData[i], categoryData[i + 1]]);
    }
    return result;
  }

  @Builder
  columnItem(item: Category) {
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

  build() {
    Scroll() {
      Row({ space: 10 }) {
        ForEach(this.columns, (column: Category[], idx: number) => {
          Column({ space: 14 }) {
            this.columnItem(column[0])
            if (column.length > 1) {
              this.columnItem(column[1])
            }
          }
          .width(72)
          .alignItems(HorizontalAlign.Center)
        }, (column: Category[], idx: number) => idx.toString())
      }
    }
    .width('100%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }
}
