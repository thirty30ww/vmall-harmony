import { router } from '@kit.ArkUI';
import { ActivityBanner } from '../components/ActivityBanner';
import { BottomNavBar } from '../components/BottomNavBar';
import { CategoryPanel } from '../components/CategoryPanel';
import { CategoryGrid } from '../components/CategoryGrid';
import { DiscoverPanel } from '../components/DiscoverPanel';
import { HomeSwiper } from '../components/HomeSwiper';
import { ProductCard } from '../components/ProductCard';
import { ProductsListSection } from '../components/ProductsListSection';
import { SearchBar } from '../components/SearchBar';
import { CartItem, CartSummary, deleteCartItem, getCart } from '../api/cartApi';
import { CartItemCardComponent } from '../components/CartItemCardComponent';
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
  @State currentUsername: string = '';
  @State cartItems: CartItem[] = [];
  @State cartSelectedCount: number = 0;
  @State cartTotalAmount: number = 0;
  @State cartLoading: boolean = false;
  @State cartErrorMessage: string = '';


  aboutToAppear() {
    this.loadCurrentUser();
    const params = router.getParams() as Record<string, number>;
    let targetTab: number = -1;
    if (params) {
      targetTab = Number(params.targetTab ?? -1);
    }
    if (targetTab >= 0 && targetTab <= 4) {
      this.activeTabIndex = targetTab;
    }
    this.loadHome();
    if (this.activeTabIndex === 3) {
      this.loadCart();
    }
  }

  loadCurrentUser() {
    const username = AppStorage.get<string>('username') ?? '';
    const phone = AppStorage.get<string>('phone') ?? '';
    this.currentUsername = username.length > 0 ? username : phone;
  }
  isLoggedIn(): boolean {
    const token = AppStorage.get<string>('token') ?? '';
    return token.length > 0;
  }

  logout() {
    AppStorage.setOrCreate('token', '');
    AppStorage.setOrCreate('phone', '');
    AppStorage.setOrCreate('username', '');
    this.currentUsername = '';
    this.cartItems = [];
    this.cartSelectedCount = 0;
    this.cartTotalAmount = 0;
    this.cartErrorMessage = '';
    try {
      router.pushUrl({ url: 'pages/LoginPage' });
    } catch (error) {
      this.errorMessage = '\u9875\u9762\u8df3\u8f6c\u5931\u8d25';
    }
  }

  async loadCart() {
    if (!this.isLoggedIn()) {
      this.cartItems = [];
      this.cartSelectedCount = 0;
      this.cartTotalAmount = 0;
      this.cartErrorMessage = '';
      return;
    }

    this.cartLoading = true;
    this.cartErrorMessage = '';
    try {
      const summary: CartSummary = await getCart();
      this.cartItems = summary.items;
      this.cartSelectedCount = summary.selectedCount;
      this.cartTotalAmount = summary.totalAmount;
    } catch (error) {
      this.cartErrorMessage = '\u8d2d\u7269\u8f66\u52a0\u8f7d\u5931\u8d25';
    } finally {
      this.cartLoading = false;
    }
  }

  recalcCartTotals() {
    let selectedCount: number = 0;
    let totalAmount: number = 0;
    for (let i: number = 0; i < this.cartItems.length; i++) {
      const item = this.cartItems[i];
      if (item.selected) {
        selectedCount += item.quantity;
        totalAmount += item.productPrice * item.quantity;
      }
    }
    this.cartSelectedCount = selectedCount;
    this.cartTotalAmount = totalAmount;
  }

  toggleCartSelected(item: CartItem) {
    this.cartErrorMessage = '';
    const newItems: CartItem[] = [];
    for (let i: number = 0; i < this.cartItems.length; i++) {
      const old = this.cartItems[i];
      if (old.id === item.id) {
        const clone: CartItem = {
          id: old.id, productId: old.productId, productSource: old.productSource,
          productName: old.productName, productImage: old.productImage,
          productPrice: old.productPrice, productFeature: old.productFeature,
          quantity: old.quantity, lineAmount: old.lineAmount,
          selected: !old.selected
        };
        newItems.push(clone);
      } else {
        newItems.push(old);
      }
    }
    this.cartItems = newItems;
    this.recalcCartTotals();
  }

  changeCartQuantity(item: CartItem, quantity: number) {
    this.cartErrorMessage = '';
    const nextQuantity: number = Math.max(0, Math.min(99, quantity));
    if (nextQuantity === item.quantity) {
      return;
    }
    if (nextQuantity === 0) {
      this.deleteCartProduct(item);
      return;
    }
    const newItems: CartItem[] = [];
    for (let i: number = 0; i < this.cartItems.length; i++) {
      const old = this.cartItems[i];
      if (old.id === item.id) {
        const clone: CartItem = {
          id: old.id, productId: old.productId, productSource: old.productSource,
          productName: old.productName, productImage: old.productImage,
          productPrice: old.productPrice, productFeature: old.productFeature,
          quantity: nextQuantity, lineAmount: old.lineAmount,
          selected: old.selected
        };
        newItems.push(clone);
      } else {
        newItems.push(old);
      }
    }
    this.cartItems = newItems;
    this.recalcCartTotals();
  }

  async deleteCartProduct(item: CartItem) {
    this.cartErrorMessage = '';
    const newItems: CartItem[] = [];
    for (let i: number = 0; i < this.cartItems.length; i++) {
      if (this.cartItems[i] !== item) {
        newItems.push(this.cartItems[i]);
      }
    }
    this.cartItems = newItems;
    this.recalcCartTotals();

    try {
      await deleteCartItem(item.id);
    } catch (error) {
      this.cartErrorMessage = '\u5220\u9664\u5931\u8d25';
      await this.loadCartSilent();
    }
  }

  async loadCartSilent() {
    try {
      const summary: CartSummary = await getCart();
      this.cartItems = summary.items;
      this.cartSelectedCount = summary.selectedCount;
      this.cartTotalAmount = summary.totalAmount;
    } catch (error) {
      console.error('load cart failed', error);
    }
  }
  allCartSelected(): boolean {
    if (this.cartItems.length === 0) {
      return false;
    }
    for (let index = 0; index < this.cartItems.length; index++) {
      if (!this.cartItems[index].selected) {
        return false;
      }
    }
    return true;
  }
  toggleCartAll() {
    this.cartErrorMessage = '';
    const nextSelected: boolean = !this.allCartSelected();
    const newItems: CartItem[] = [];
    for (let i: number = 0; i < this.cartItems.length; i++) {
      const old = this.cartItems[i];
      const clone: CartItem = {
        id: old.id, productId: old.productId, productSource: old.productSource,
        productName: old.productName, productImage: old.productImage,
        productPrice: old.productPrice, productFeature: old.productFeature,
        quantity: old.quantity, lineAmount: old.lineAmount,
        selected: nextSelected
      };
      newItems.push(clone);
    }
    this.cartItems = newItems;
    this.recalcCartTotals();
  }

  priceText(value: number): string {
    return value.toFixed(2);
  }
  tabName(): string {
    switch (this.activeTabIndex) {
      case 1:
        return '\u5206\u7c7b';
      case 2:
        return '\u53d1\u73b0';
      case 3:
        return '\u8d2d\u7269\u8f66';
      case 4:
        return '\u6211\u7684';
      default:
        return '\u9996\u9875';
    }
  }

  async loadHome() {
    this.loading = true;
    this.errorMessage = '';
    try {
      this.homeData = await getHomeData();
    } catch (error) {
      this.errorMessage = '\u9996\u9875\u52a0\u8f7d\u5931\u8d25\uff0c\u8bf7\u68c0\u67e5\u540e\u7aef\u670d\u52a1';
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
      this.errorMessage = '\u641c\u7d22\u5931\u8d25\uff0c\u8bf7\u7a0d\u540e\u91cd\u8bd5';
    } finally {
      this.loading = false;
    }
  }

  openProduct(product: Product) {
    try {
      router.pushUrl({
        url: 'pages/ProductDetailPage',
        params: {
          productId: product.id,
          source: 'home',
          productName: product.name ?? '',
          productImage: product.imageUrl ?? '',
          productFeature: product.feature ?? '',
          productPrice: product.price === null ? '' : product.price.toString()
        }
      });
    } catch (error) {
      this.errorMessage = '\u9875\u9762\u8df3\u8f6c\u5931\u8d25';
    }
  }

  @Builder
  homeContent() {
    Scroll() {
      Column({ space: 18 }) {
        Column() {
          SearchBar({
            keyword: $keyword,
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
  cartEmptyContent(text: string, buttonText: string, targetLogin: boolean) {
    Column({ space: 14 }) {
      Stack() {
        Text('\uD83D\uDED2')
          .fontSize(76)
          .fontColor('#CDD3DC')
      }
      .width(120)
      .height(92)
      .alignContent(Alignment.Center)

      Text(text)
        .fontSize(16)
        .fontColor('#7A7F85')
        .textAlign(TextAlign.Center)

      Button(buttonText)
        .width(150)
        .height(50)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor(Color.White)
        .backgroundColor('#D71920')
        .borderRadius(25)
        .onClick(() => {
          if (targetLogin) {
            try {
              router.pushUrl({ url: 'pages/LoginPage' });
            } catch (error) {
              this.errorMessage = '\u9875\u9762\u8df3\u8f6c\u5931\u8d25';
            }
          } else {
            this.activeTabIndex = 0;
          }
        })
    }
    .layoutWeight(1)
    .width('100%')
    .padding({ top: 68, left: 16, right: 16 })
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  cartContent() {
    if (!this.isLoggedIn()) {
      this.cartEmptyContent('\u8bf7\u5148\u767b\u5f55\u540e\u67e5\u770b\u8d2d\u7269\u8f66', '\u53bb\u767b\u5f55', true)
    } else if (this.cartLoading && this.cartItems.length === 0) {
      Column() {
        Text('\u8d2d\u7269\u8f66\u52a0\u8f7d\u4e2d')
          .fontSize(15)
          .fontColor('#86909C')
      }
      .layoutWeight(1)
      .width('100%')
      .justifyContent(FlexAlign.Center)
    } else if (this.cartErrorMessage.length > 0 && this.cartItems.length === 0) {
      Column({ space: 12 }) {
        Text(this.cartErrorMessage)
          .fontSize(15)
          .fontColor('#86909C')
        Button('\u91cd\u8bd5')
          .width(120)
          .height(42)
          .fontColor(Color.White)
          .backgroundColor('#111111')
          .borderRadius(21)
          .onClick(() => {
            this.loadCart();
          })
      }
      .layoutWeight(1)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    } else if (this.cartItems.length === 0) {
      this.cartEmptyContent('\u60a8\u7684\u8d2d\u7269\u8f66\u6682\u65f6\u6ca1\u6709\u5546\u54c1', '\u53bb\u8d2d\u7269', false)
    } else {
      Column() {
        List({ space: 12 }) {
          ForEach(this.cartItems, (item: CartItem) => {
            ListItem() {
              CartItemCardComponent({
                item: item,
                onToggleSelected: (cartItem: CartItem) => {
                  this.toggleCartSelected(cartItem);
                },
                onChangeQuantity: (cartItem: CartItem, quantity: number) => {
                  this.changeCartQuantity(cartItem, quantity);
                },
                onDelete: (cartItem: CartItem) => {
                  this.deleteCartProduct(cartItem);
                }
              })
            }
          }, (item: CartItem) => item.id.toString() + '_' + item.selected.toString() + '_' + item.quantity.toString())
        }
        .layoutWeight(1)
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .scrollBar(BarState.Off)

        Row() {
          Row({ space: 8 }) {
            Button(this.allCartSelected() ? '\u2713' : '')
              .width(24)
              .height(24)
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor(this.allCartSelected() ? Color.White : '#C9CDD4')
              .padding(0)
              .backgroundColor(this.allCartSelected() ? '#D71920' : Color.White)
              .borderRadius(12)
              .border({ width: 1.5, color: this.allCartSelected() ? '#D71920' : '#C9CDD4' })
              .onClick(() => {
                this.toggleCartAll();
              })
            Text('\u5168\u9009')
              .fontSize(15)
              .fontColor('#111111')
          }
          .height('100%')
          .alignItems(VerticalAlign.Center)

          Blank()

          Text('\u5408\u8ba1: ')
            .fontSize(14)
            .fontColor('#111111')
          Text('\u00a5' + this.priceText(this.cartTotalAmount))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#D71920')

          Button('\u7ed3\u7b97(' + this.cartSelectedCount.toString() + ')')
            .width(116)
            .height(46)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .backgroundColor('#D71920')
            .borderRadius(23)
            .enabled(this.cartSelectedCount > 0)
            .opacity(this.cartSelectedCount > 0 ? 1 : 0.6)
            .onClick(() => {
              AlertDialog.show({ message: '\u6682\u65f6\u4e0d\u652f\u6301' });
            })
        }
        .width('100%')
        .height(66)
        .padding({ left: 16, right: 12 })
        .backgroundColor(Color.White)
        .alignItems(VerticalAlign.Center)
      }
      .layoutWeight(1)
      .width('100%')
    }
  }
  @Builder
  myAssetItem(icon: Resource, title: string) {
    Column({ space: 4 }) {
      Image(icon)
        .width(34)
        .height(34)
        .objectFit(ImageFit.Contain)

      Text(title)
        .fontSize(14)
        .fontColor('#111111')
        .textAlign(TextAlign.Center)

      Text('--')
        .fontSize(12)
        .fontColor('#111111')
        .textAlign(TextAlign.Center)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  myOrderItem(icon: Resource, title: string) {
    Column({ space: 8 }) {
      Image(icon)
        .width(31)
        .height(31)
        .objectFit(ImageFit.Contain)

      Text(title)
        .fontSize(14)
        .fontColor('#111111')
        .textAlign(TextAlign.Center)
        .maxLines(1)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  myServiceItem(icon: Resource, title: string) {
    Column({ space: 8 }) {
      Image(icon)
        .width(31)
        .height(31)
        .objectFit(ImageFit.Contain)

      Text(title)
        .fontSize(14)
        .fontColor('#222222')
        .textAlign(TextAlign.Center)
        .maxLines(1)
    }
    .layoutWeight(1)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  myListRow(icon: Resource, title: string) {
    Row() {
      Image(icon)
        .width(28)
        .height(28)
        .objectFit(ImageFit.Contain)
        .margin({ right: 12 })

      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')
        .layoutWeight(1)

      Text('\u203a')
        .fontSize(34)
        .fontColor('#C9CDD4')
    }
    .width('100%')
    .height(64)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  logoutRow() {
    Row() {
      Text('\u9000\u51fa\u767b\u5f55')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#D71920')
        .layoutWeight(1)

      Text('\u203a')
        .fontSize(34)
        .fontColor('#C9CDD4')
    }
    .width('100%')
    .height(64)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      this.logout();
    })
  }

  @Builder
  myContent() {
    Scroll() {
      Column({ space: 14 }) {
        Column() {
          Row({ space: 14 }) {
            Image($r('app.media.avatar'))
              .width(58)
              .height(58)
              .borderRadius(29)
              .objectFit(ImageFit.Cover)

            Text(this.currentUsername.length > 0 ? this.currentUsername : '\u767b\u5f55/\u6ce8\u518c')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
              .layoutWeight(1)
          }
          .width('100%')
          .height(84)
          .alignItems(VerticalAlign.Center)
          .onClick(() => {
            if (this.currentUsername.length > 0) {
              return;
            }
            try {
              router.pushUrl({ url: 'pages/LoginPage' });
            } catch (error) {
              this.errorMessage = '\u9875\u9762\u8df3\u8f6c\u5931\u8d25';
            }
          })

          Divider()
            .strokeWidth(1)
            .color('#E1E1E1')

          Row() {
            Text('\u5f00\u542f\u667a\u6167\u751f\u6d3b')
              .fontSize(16)
              .fontColor('#7A7F85')
              .layoutWeight(1)

            Text('\u4f1a\u5458\u9891\u9053')
              .fontSize(14)
              .fontWeight(FontWeight.Bold)
              .fontColor('#7B5B20')
              .padding({ left: 12, right: 12, top: 6, bottom: 6 })
              .backgroundColor('#E7C987')
              .borderRadius(15)
          }
          .width('100%')
          .height(52)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 12, bottom: 4 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        Row() {
          this.myAssetItem($r('app.media.jifen'), '\u79ef\u5206')
          this.myAssetItem($r('app.media.youhui'), '\u4f18\u60e0\u5238')
          this.myAssetItem($r('app.media.daijing'), '\u4ee3\u91d1\u5238')
          this.myAssetItem($r('app.media.bao'), '\u4f18\u8d2d\u7801')
        }
        .width('100%')
        .height(104)
        .padding({ left: 18, right: 18 })
        .backgroundColor(Color.White)
        .borderRadius(18)
        .alignItems(VerticalAlign.Center)

        Column({ space: 12 }) {
          Row() {
            Text('\u6211\u7684\u8ba2\u5355')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
              .layoutWeight(1)

            Text('\u5168\u90e8\u8ba2\u5355')
              .fontSize(14)
              .fontColor('#7A7F85')

            Text('\u203a')
              .fontSize(30)
              .fontColor('#8A8F96')
          }
          .height(32)
          .alignItems(VerticalAlign.Center)

          Row() {
            this.myOrderItem($r('app.media.daifukuan'), '\u5f85\u4ed8\u6b3e')
            this.myOrderItem($r('app.media.daishouhuo'), '\u5f85\u6536\u8d27')
            this.myOrderItem($r('app.media.pingjia'), '\u5f85\u8bc4\u4ef7')
            this.myOrderItem($r('app.media.shouhou'), '\u552e\u540e\u9000\u6b3e')
            this.myOrderItem($r('app.media.huishou'), '\u56de\u6536\u5355')
          }
          .width('100%')
          .height(58)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 26, bottom: 18 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        Column({ space: 14 }) {
          Row() {
            Text('\u5e38\u7528\u670d\u52a1')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#111111')
              .layoutWeight(1)

            Text('\u8054\u7cfb\u5ba2\u670d')
              .fontSize(16)
              .fontColor('#7A7F85')

            Text('\u203a')
              .fontSize(30)
              .fontColor('#8A8F96')
          }
          .height(32)
          .alignItems(VerticalAlign.Center)

          Row() {
            this.myServiceItem($r('app.media.shouhou'), '\u5b98\u65b9\u552e\u540e')
            this.myServiceItem($r('app.media.shangdian'), '\u670d\u52a1\u5546\u5e97')
            this.myServiceItem($r('app.media.baozhi'), '\u4fdd\u503c\u6362\u65b0')
            this.myServiceItem($r('app.media.baojia'), '\u4ef7\u4fdd\u7533\u8bf7')
          }
          .width('100%')
          .height(62)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 26, bottom: 18 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        Column() {
          this.myListRow($r('app.media.wenti'), '\u95ee\u9898\u548c\u5efa\u8bae')
          Divider()
            .strokeWidth(1)
            .color('#ECECEC')
            .margin({ left: 40 })
          this.myListRow($r('app.media.gonggao'), '\u5546\u57ce\u516c\u544a')
        }
        .width('100%')
        .padding({ left: 14, right: 14 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        Column() {
          this.myListRow($r('app.media.shezhi'), '\u8bbe\u7f6e')
          if (this.isLoggedIn()) {
            Divider()
              .strokeWidth(1)
              .color('#ECECEC')
              .margin({ left: 40 })
            this.logoutRow()
          }
        }
        .width('100%')
        .padding({ left: 14, right: 14 })
        .backgroundColor(Color.White)
        .borderRadius(18)

        Text('\u9690\u79c1\u653f\u7b56  |  \u7528\u6237\u534f\u8bae  |  \u5173\u4e8eCookie\n\u8425\u4e1a\u6267\u7167    \u5907\u6848\u4e3b\u4f53\u7f16\u53f7\uff1a44201919072182\n\u7ca4ICP\u590719015064\u53f7   \u7ca4\u516c\u7f51\u5b89\u590744190002003939\u53f7\n\u589e\u503c\u7535\u4fe1\u4e1a\u52a1\u7ecf\u8425\u8bb8\u53ef\u8bc1\uff1a\u7ca4B2-20190762')
          .fontSize(13)
          .lineHeight(22)
          .fontColor('#A5A8AD')
          .textAlign(TextAlign.Center)
          .width('100%')
          .padding({ left: 8, right: 8, top: 18, bottom: 18 })
          .backgroundColor(Color.White)
          .borderRadius(18)
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 16 })
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

      Text('\u5f53\u524d\u6a21\u5757\u7b49\u5f85\u5b8c\u6210')
        .fontSize(15)
        .fontColor('#86909C')
    }
    .layoutWeight(1)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  topBar() {
    if (this.activeTabIndex !== 2) {
      Row() {
        Text(this.activeTabIndex === 1 ? '\u5206\u7c7b' : this.activeTabIndex === 3 ? '\u8d2d\u7269\u8f66' : this.activeTabIndex === 4 ? '\u6211\u7684' : '\u534e\u4e3a\u5546\u57ce')
          .fontSize(this.activeTabIndex === 1 || this.activeTabIndex === 3 || this.activeTabIndex === 4 ? 28 : 22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')

        Blank()
          .layoutWeight(1)

        if (this.activeTabIndex === 4) {
          Stack() {
            Image($r('app.media.youjian'))
              .width(25)
              .height(25)
              .objectFit(ImageFit.Contain)
          }
          .width(48)
          .height(48)
          .backgroundColor('#E8EAED')
          .borderRadius(24)
        }
      }
      .width('100%')
      .height(58)
      .alignItems(VerticalAlign.Center)
      .padding({ left: 16, right: 16, top: 8, bottom: 2 })
    }
  }

  build() {
    Column() {
      this.topBar()

      if (this.activeTabIndex === 0) {
        this.homeContent()
      } else if (this.activeTabIndex === 1) {
        CategoryPanel()
          .layoutWeight(1)
      } else if (this.activeTabIndex === 2) {
        DiscoverPanel()
          .layoutWeight(1)
      } else if (this.activeTabIndex === 3) {
        this.cartContent()
      } else if (this.activeTabIndex === 4) {
        this.myContent()
      } else {
        this.waitingContent()
      }

      BottomNavBar({ activeIndex: $activeTabIndex, onTabChange: (index: number) => {
        if (index === 3) {
          this.loadCart();
        } else if (index === 4) {
          this.loadCurrentUser();
        }
      } })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6F8')
  }
}
