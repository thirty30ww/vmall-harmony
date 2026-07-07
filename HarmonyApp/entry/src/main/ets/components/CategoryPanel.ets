// 分类面板组件 —— 左侧分类菜单 + 右侧商品网格
import { router } from '@kit.ArkUI';
import { CategoryPageCategory, CategoryPageGroup, CategoryPageProduct, getCategoryPage } from '../api/categoryApi';

@Component
export struct CategoryPanel {
  @State selectedIndex: number = 0;               // 当前选中的分类索引
  @State selectedCategoryName: string = '';        // 当前选中的分类名称
  @State selectedGroups: CategoryPageGroup[] = [];  // 当前分类的分组列表
  @State categories: CategoryPageCategory[] = [];   // 全部分类数据
  @State loading: boolean = false;                 // 加载状态
  @State errorMessage: string = '';               // 错误信息
  private rightScroller: Scroller = new Scroller(); // 右侧内容区域滚动控制器

  // 组件初始化时加载分类数据
  aboutToAppear() {
    this.loadCategoryPage();
  }

  // 从后端加载分类页面数据
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

  // 选中某个分类，切换右侧内容
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
    setTimeout(() => {
      this.rightScroller.scrollEdge(Edge.Top);
    }, 50);
  }

  // 计算分组网格高度（每行 3 个商品，每个 136px）
  groupGridHeight(count: number): number {
    const rows: number = Math.max(1, Math.ceil(count / 3));
    return rows * 136;
  }

  // 打开商品详情页
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

  // ===== 左侧菜单项 Builder =====
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

  // ===== 商品方块 Builder =====
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

  // ===== 商品分组区域 Builder =====
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

  // ===== 右侧分类内容 Builder =====
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

  // ===== 组件主构建 =====
  build() {
    if (this.loading) {
      // 加载中
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
      // 加载失败 -> 显示重试
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
      // 左菜单 + 右内容
      Row() {
        // 左侧分类菜单（固定宽度 116px）
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

        // 右侧商品内容
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
          Scroll(this.rightScroller) {
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
