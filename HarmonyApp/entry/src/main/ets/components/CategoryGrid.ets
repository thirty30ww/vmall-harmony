// 首页顶部分类网格组件 —— 横向滚动展示 16 个分类入口
import { Category, categoryData } from '../data/categoryData';

@Component
export struct CategoryGrid {
  onSelect: (category: Category) => void = () => {};  // 分类点击回调

  // 单个分类列项
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

  // 每行显示两个分类（上下排列）
  @Builder
  pairColumn(first: Category, second: Category) {
    Column({ space: 14 }) {
      this.columnItem(first)
      this.columnItem(second)
    }
    .width(72)
    .alignItems(HorizontalAlign.Center)
  }

  build() {
    Scroll() {
      Row({ space: 10 }) {
        this.pairColumn(categoryData[0], categoryData[1])
        this.pairColumn(categoryData[2], categoryData[3])
        this.pairColumn(categoryData[4], categoryData[5])
        this.pairColumn(categoryData[6], categoryData[7])
        this.pairColumn(categoryData[8], categoryData[9])
        this.pairColumn(categoryData[10], categoryData[11])
        this.pairColumn(categoryData[12], categoryData[13])
        this.pairColumn(categoryData[14], categoryData[15])
      }
    }
    .width('100%')
    .scrollable(ScrollDirection.Horizontal)  // 横向滚动
    .scrollBar(BarState.Off)
  }
}
