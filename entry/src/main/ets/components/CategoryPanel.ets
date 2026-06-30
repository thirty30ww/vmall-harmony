import { CategoryPageCategory, getCategoryPage } from '../api/categoryApi';

@Component
export struct CategoryPanel {
  @State selectedIndex: number = 0;
  @State categories: CategoryPageCategory[] = [];
  @State loading: boolean = false;
  @State errorMessage: string = '';

  aboutToAppear() {
    this.loadCategoryPage();
  }

  async loadCategoryPage() {
    this.loading = true;
    this.errorMessage = '';
    try {
      const data = await getCategoryPage();
      this.categories = data.categories;
      if (this.selectedIndex >= this.categories.length) {
        this.selectedIndex = 0;
      }
    } catch (error) {
      this.errorMessage = '\u5206\u7C7B\u52A0\u8F7D\u5931\u8D25\uFF0C\u8BF7\u68C0\u67E5\u540E\u7AEF\u670D\u52A1';
    } finally {
      this.loading = false;
    }
  }

  selectedCategory(): CategoryPageCategory | null {
    if (this.categories.length === 0 || this.selectedIndex < 0 || this.selectedIndex >= this.categories.length) {
      return null;
    }
    return this.categories[this.selectedIndex];
  }

  @Builder
  menuItem(index: number, category: CategoryPageCategory) {
    Row() {
      if (this.selectedIndex === index) {
        Blank()
          .width(3)
          .height(22)
          .backgroundColor('#D71920')
          .borderRadius(2)
      } else {
        Blank()
          .width(3)
          .height(22)
      }

      Text(category.name ?? '')
        .fontSize(14)
        .fontWeight(this.selectedIndex === index ? FontWeight.Bold : FontWeight.Regular)
        .fontColor(this.selectedIndex === index ? '#D71920' : '#4E5969')
        .layoutWeight(1)
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .height(48)
    .width('100%')
    .backgroundColor(this.selectedIndex === index ? Color.White : '#F5F6F8')
    .onClick(() => {
      this.selectedIndex = index;
    })
  }

  @Builder
  categoryPlaceholder(category: CategoryPageCategory) {
    Column({ space: 14 }) {
      Text(category.name ?? '')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')
        .width('100%')

      Column({ space: 8 }) {
        Text('\u5F53\u524D\u6A21\u5757\u7B49\u5F85\u5B8C\u6210')
          .fontSize(14)
          .fontColor('#86909C')
      }
      .width('100%')
      .height(160)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .borderRadius(8)
    }
    .width('100%')
    .padding(14)
  }

  @Builder
  rightContent() {
    if (this.loading) {
      Column() {
        Text('\u52A0\u8F7D\u4E2D')
          .fontSize(14)
          .fontColor('#86909C')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else if (this.errorMessage.length > 0) {
      Column({ space: 12 }) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor('#86909C')
          .textAlign(TextAlign.Center)
        Button('\u91CD\u8BD5')
          .height(36)
          .fontSize(14)
          .backgroundColor('#111111')
          .borderRadius(18)
          .onClick(() => {
            this.loadCategoryPage();
          })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else if (this.selectedCategory() !== null) {
      this.categoryPlaceholder(this.selectedCategory() as CategoryPageCategory)
    } else {
      Column() {
        Text('\u6682\u65E0\u5206\u7C7B\u6570\u636E')
          .fontSize(14)
          .fontColor('#86909C')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
  }

  build() {
    Row() {
      Scroll() {
        Column() {
          ForEach(this.categories, (item: CategoryPageCategory, index: number) => {
            this.menuItem(index, item)
          }, (item: CategoryPageCategory) => item.id.toString())
        }
        .width('100%')
      }
      .width(92)
      .height('100%')
      .backgroundColor('#F5F6F8')
      .scrollBar(BarState.Off)

      Scroll() {
        Column() {
          this.rightContent()
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 12, bottom: 20 })
      }
      .layoutWeight(1)
      .height('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6F8')
  }
}
