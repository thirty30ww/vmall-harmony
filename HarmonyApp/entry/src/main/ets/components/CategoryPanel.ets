import { router } from '@kit.ArkUI';
import { CategoryPageCategory, CategoryPageGroup, CategoryPageProduct, getCategoryPage } from '../api/categoryApi';

@Component
export struct CategoryPanel {
  @State selectedIndex: number = 0;
  @State selectedCategoryName: string = '';
  @State selectedGroups: CategoryPageGroup[] = [];
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
      this.selectCategory(this.selectedIndex);
    } catch (error) {
      this.errorMessage = '分类加载失败，请检查后端服务';
    } finally {
      this.loading = false;
    }
  }

  selectCategory(index: number) {
    if (index < 0 || index >= this.categories.length) {
      this.selectedIndex = 0;
      this.selectedCategoryName = '';
      this.selectedGroups = [];
      return;
    }

    const category: CategoryPageCategory = this.categories[index];
    this.selectedIndex = index;
    this.selectedCategoryName = category.name ?? '';
    this.selectedGroups = category.groups.slice(0);
  }

  groupGridHeight(count: number): number {
    const rows: number = Math.max(1, Math.ceil(count / 3));
    return rows * 136;
  }

  openProduct(product: CategoryPageProduct) {
    const productPrice: number | null = product.price ?? null;
    try {
      router.pushUrl({
        url: 'pages/ProductDetailPage',
        params: {
          productId: product.id,
          source: 'category',
          productName: product.name,
          productImage: product.imageUrl ?? '',
          productFeature: product.feature ?? '',
          productPrice: productPrice === null ? '' : productPrice.toString()
        }
      });
    } catch (error) {
      this.errorMessage = '页面跳转失败';
    }
  }
  @Builder
  menuItem(index: number, category: CategoryPageCategory) {
    Row() {
      Text(category.name ?? '')
        .fontSize(16)
        .fontWeight(this.selectedIndex === index ? FontWeight.Bold : FontWeight.Regular)
        .fontColor(this.selectedIndex === index ? '#D71920' : '#666666')
        .layoutWeight(1)
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .height(72)
    .width('100%')
    .padding({ left: 16, right: 8 })
    .backgroundColor('#F1F3F5')
    .onClick(() => {
      this.selectCategory(index);
    })
  }

  @Builder
  productTile(product: CategoryPageProduct) {
    Column({ space: 8 }) {
      Image(product.imageUrl ?? '')
        .width(66)
        .height(66)
        .objectFit(ImageFit.Contain)

      Text(product.name)
        .fontSize(13)
        .fontColor('#111111')
        .lineHeight(16)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .width('100%')
        .height(34)
    }
    .width('100%')
    .height(124)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.openProduct(product);
    })
  }

  @Builder
  productGroup(group: CategoryPageGroup) {
    Column({ space: 12 }) {
      Text(group.groupName)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')
        .width('100%')

      Grid() {
        ForEach(group.products, (item: CategoryPageProduct) => {
          GridItem() {
            this.productTile(item)
          }
        }, (item: CategoryPageProduct) => `${this.selectedCategoryName}-${item.id}`)
      }
      .columnsTemplate('1fr 1fr 1fr')
      .columnsGap(8)
      .rowsGap(10)
      .width('100%')
      .height(this.groupGridHeight(group.products.length))
    }
    .width('100%')
    .padding({ left: 14, right: 14, top: 12, bottom: 10 })
    .backgroundColor(Color.White)
    .borderRadius(18)
  }

  @Builder
  categoryContent() {
    if (this.selectedGroups.length > 0) {
      Column({ space: 16 }) {
        ForEach(this.selectedGroups, (group: CategoryPageGroup) => {
          this.productGroup(group)
        }, (group: CategoryPageGroup) => `${this.selectedCategoryName}-${group.groupName}`)
      }
      .width('100%')
    } else {
      Column() {
        Text('当前模块等待完成')
          .fontSize(14)
          .fontColor('#86909C')
      }
      .width('100%')
      .height(160)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .borderRadius(18)
    }
  }

  build() {
    if (this.loading) {
      Column() {
        Text('加载中')
          .fontSize(14)
          .fontColor('#86909C')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#F5F6F8')
    } else if (this.errorMessage.length > 0) {
      Column({ space: 12 }) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor('#86909C')
          .textAlign(TextAlign.Center)
        Button('重试')
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
      .backgroundColor('#F5F6F8')
    } else {
      Row() {
        Scroll() {
          Column() {
            ForEach(this.categories, (item: CategoryPageCategory, index: number) => {
              this.menuItem(index, item)
            }, (item: CategoryPageCategory) => item.id.toString())
          }
          .width('100%')
        }
        .width(116)
        .height('100%')
        .backgroundColor('#F1F3F5')
        .scrollBar(BarState.Off)

        if (this.categories.length === 0) {
          Column() {
            Text('暂无分类数据')
              .fontSize(14)
              .fontColor('#86909C')
          }
          .layoutWeight(1)
          .height('100%')
          .padding({ right: 12 })
          .justifyContent(FlexAlign.Center)
        } else {
          Scroll() {
            Column() {
              this.categoryContent()
            }
            .width('100%')
            .padding({ left: 0, right: 0, top: 16, bottom: 24 })
          }
          .layoutWeight(1)
          .height('100%')
          .padding({ right: 12 })
          .scrollBar(BarState.Off)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F1F3F5')
    }
  }
}
