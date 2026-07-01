import { router } from '@kit.ArkUI';
import { ActivityBanner } from '../components/ActivityBanner';
import { BottomNavBar } from '../components/BottomNavBar';
import { CategoryPanel } from '../components/CategoryPanel';
import { CategoryGrid } from '../components/CategoryGrid';
import { HomeSwiper } from '../components/HomeSwiper';
import { ProductCard } from '../components/ProductCard';
import { ProductsListSection } from '../components/ProductsListSection';
import { SearchBar } from '../components/SearchBar';
import { Category as HomeCategory } from '../data/categoryData';
import { getHomeData, getProducts, HomeData, Product } from '../api/homeApi';

@Entry
@Component
struct HomePage {
  @State homeData: HomeData = {
    categories: [],
    suggestions: [],
    activities: [],
    products: []
  };
  @State keyword: string = '';
  @State loading: boolean = true;
  @State errorMessage: string = '';
  @State activeTabIndex: number = 0;

  aboutToAppear() {
    this.loadHome();
  }

  tabName(): string {
    switch (this.activeTabIndex) {
      case 1:
        return '分类';
      case 2:
        return '发现';
      case 3:
        return '购物车';
      case 4:
        return '我的';
      default:
        return '首页';
    }
  }

  async loadHome() {
    this.loading = true;
    this.errorMessage = '';
    try {
      this.homeData = await getHomeData();
    } catch (error) {
      this.errorMessage = '首页加载失败，请检查后端服务';
    } finally {
      this.loading = false;
    }
  }

  async searchProducts(keyword: string) {
    this.loading = true;
    this.errorMessage = '';
    try {
      const products = await getProducts(keyword);
      this.homeData = {
        categories: this.homeData.categories,
        suggestions: this.homeData.suggestions,
        activities: this.homeData.activities,
        products: products
      };
    } catch (error) {
      this.errorMessage = '搜索失败，请稍后重试';
    } finally {
      this.loading = false;
    }
  }

  openProduct(product: Product) {
    try {
      router.pushUrl({
        url: 'pages/ProductDetailPage',
        params: {
          productId: product.id
        }
      });
    } catch (error) {
      this.errorMessage = '页面跳转失败';
    }
  }

  @Builder
  homeContent() {
    Scroll() {
      Column({ space: 18 }) {
        Column() {
          SearchBar({
            keyword: $keyword,
            suggestions: this.homeData.suggestions,
            onSearch: (value: string) => {
              this.searchProducts(value);
            }
          })
        }
        .width('100%')
        .padding({ left: 16, right: 16 })

        HomeSwiper()

        Column({ space: 18 }) {
          CategoryGrid({
            onSelect: (category: HomeCategory) => {
              this.keyword = category.categoryName;
              this.searchProducts(this.keyword);
            }
          })

          ActivityBanner({ activities: this.homeData.activities })

          ProductsListSection()


          Grid() {
            ForEach(this.homeData.products, (item: Product) => {
              GridItem() {
                ProductCard({
                  product: item,
                  onProductClick: (product: Product) => {
                    this.openProduct(product);
                  }
                })
              }
            }, (item: Product) => item.id.toString())
          }
          .columnsTemplate('1fr 1fr')
          .columnsGap(10)
          .rowsGap(10)
          .width('100%')
        }
        .width('100%')
        .padding({ left: 16, right: 16 })
      }
      .width('100%')
      .padding({ top: 4, bottom: 24 })
    }
    .layoutWeight(1)
    .scrollBar(BarState.Off)
  }

  @Builder
  waitingContent() {
    Column({ space: 12 }) {
      Text(this.tabName())
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')

      Text('当前模块等待完成')
        .fontSize(15)
        .fontColor('#86909C')
    }
    .layoutWeight(1)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Column() {
      Row() {
        Text('华为商城')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 6 })

      if (this.activeTabIndex === 0) {
        this.homeContent()
      } else if (this.activeTabIndex === 1) {
        CategoryPanel()
          .layoutWeight(1)
      } else {
        this.waitingContent()
      }

      BottomNavBar({ activeIndex: $activeTabIndex })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6F8')
  }
}