import { Category, categoryData } from '../data/categoryData';

@Component
export struct CategoryGrid {
  onSelect: (category: Category) => void = () => {};

  get pairStartIndices(): number[] {
    const result: number[] = [];
    for (let i = 0; i < categoryData.length; i += 2) {
      result.push(i);
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
        ForEach(this.pairStartIndices, (startIdx: number) => {
          Column({ space: 14 }) {
            this.columnItem(categoryData[startIdx])
            if (startIdx + 1 < categoryData.length) {
              this.columnItem(categoryData[startIdx + 1])
            }
          }
          .width(72)
          .alignItems(HorizontalAlign.Center)
        }, (startIdx: number) => startIdx.toString())
      }
    }
    .width('100%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
  }
}
