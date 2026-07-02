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
import { CartItem, CartSummary,
  deleteCartItem,
  deleteCartItem as removeCartItem, getCart, selectAllCartItems, updateCartItem } from '../api/cartApi';
import { Category as HomeCategory } from '../data/categoryData';
import { productsList } from '../data/productsListData';
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
  @State operatingItemId: number | null = null;
  @State isDeletingItemId: number | null = null;

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

  // 2. 在 applyCartSummary 中排序
  applyCartSummary(summary: CartSummary) {
    // 按 id 升序排列
    const sortedItems = summary.items.sort((a: CartItem, b: CartItem) => a.id - b.id);
    this.cartItems = sortedItems;
    this.cartSelectedCount = summary.selectedCount;
    this.cartTotalAmount = summary.totalAmount;
  }

  // 首次加载购物车
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
      // 按 id 升序排列
      const sortedItems = summary.items.sort((a: CartItem, b: CartItem) => a.id - b.id);
      this.cartItems = sortedItems;
      this.cartSelectedCount = summary.selectedCount;
      this.cartTotalAmount = summary.totalAmount;
    } catch (error) {
      this.cartErrorMessage = '购物车加载失败';
    } finally {
      this.cartLoading = false;
    }
  }



  // 1. 修复 changeCartQuantity 方法 - 确保状态正确更新
  // 修复：changeCartQuantity - 不触发全局刷新
  async changeCartQuantity(item: CartItem, quantity: number) {
    const nextQuantity: number = Math.max(0, Math.min(99, quantity));
    if (nextQuantity === item.quantity) {
      return;
    }

    // 当数量变为0时，执行删除
    if (nextQuantity === 0) {
      await this.deleteCartProduct(item);
      return;
    }

    this.operatingItemId = item.id;
    this.cartErrorMessage = '';

    try {
      const summary: CartSummary = await updateCartItem(item.id, nextQuantity, null);
      this.applyCartSummary(summary);
    } catch (error) {
      this.cartErrorMessage = '数量更新失败';
      await this.loadCartSilent();
    } finally {
      this.operatingItemId = null;
    }
  }
  // 2. 修复 toggleCartSelected 方法
  async toggleCartSelected(item: CartItem) {
    this.operatingItemId = item.id;
    this.cartErrorMessage = '';

    try {
      const summary: CartSummary = await updateCartItem(item.id, null, !item.selected);
      this.applyCartSummary(summary);
    } catch (error) {
      this.cartErrorMessage = '选中状态更新失败';
      await this.loadCartSilent();
    } finally {
      this.operatingItemId = null;
    }
  }

  // 修改 deleteCartProduct 方法
  // 3. 在 deleteCartProduct 中重新排序
  async deleteCartProduct(item: CartItem) {
    this.isDeletingItemId = item.id;
    this.cartErrorMessage = '';

    try {
      // 过滤并排序
      const filteredItems: CartItem[] = [];
      for (let i = 0; i < this.cartItems.length; i++) {
        if (this.cartItems[i].id !== item.id) {
          filteredItems.push(this.cartItems[i]);
        }
      }

      // 按 id 升序排列
      const sortedItems = filteredItems.sort((a: CartItem, b: CartItem) => a.id - b.id);

      let selectedCount = 0;
      let totalAmount = 0;
      for (let i = 0; i < sortedItems.length; i++) {
        if (sortedItems[i].selected) {
          selectedCount++;
          totalAmount += sortedItems[i].productPrice * sortedItems[i].quantity;
        }
      }

      this.cartItems = sortedItems;
      this.cartSelectedCount = selectedCount;
      this.cartTotalAmount = totalAmount;

      await deleteCartItem(item.id);
      await this.loadCartSilent();
    } catch (error) {
      this.cartErrorMessage = '删除失败，请重试';
      await this.loadCartSilent();
    } finally {
      this.isDeletingItemId = null;
    }
  }


  // 静默加载购物车（保持顺序）
  async loadCartSilent() {
    try {
      const summary: CartSummary = await getCart();
      // 使用 applyCartSummary 保持顺序
      this.applyCartSummary(summary);
    } catch (error) {
      // 静默失败，保持现有数据
      console.error('静默加载购物车失败', error);
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

  // 4. 修复 toggleCartAll 方法
  async toggleCartAll() {
    const newSelectedState = !this.allCartSelected();
    this.cartErrorMessage = '';

    // 乐观更新 - 保持原有顺序
    const updatedItems: CartItem[] = [];
    for (let i = 0; i < this.cartItems.length; i++) {
      const item = this.cartItems[i];
      updatedItems.push({
        id: item.id,
        productId: item.productId,
        productSource: item.productSource,
        productName: item.productName,
        productImage: item.productImage,
        productPrice: item.productPrice,
        productFeature: item.productFeature,
        quantity: item.quantity,
        selected: newSelectedState,
        lineAmount: item.lineAmount
      });
    }

    let newTotalAmount = 0;
    if (newSelectedState) {
      for (let i = 0; i < updatedItems.length; i++) {
        newTotalAmount += updatedItems[i].productPrice * updatedItems[i].quantity;
      }
    }

    // 直接更新，保持顺序
    this.cartItems = updatedItems;
    this.cartSelectedCount = newSelectedState ? updatedItems.length : 0;
    this.cartTotalAmount = newTotalAmount;

    try {
      const summary: CartSummary = await selectAllCartItems(newSelectedState);
      // 使用 applyCartSummary 保持顺序
      this.applyCartSummary(summary);
    } catch (error) {
      this.cartErrorMessage = '全选更新失败';
      await this.loadCartSilent();
    }
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

  // 5. 优化 cartSelectButton - 使用更可靠的点击处理
  @Builder
  cartSelectButton(selected: boolean, itemId: number, onTap: () => void) {
    Button(selected ? '\u2713' : '')
      .width(24)
      .height(24)
      .fontSize(14)
      .fontWeight(FontWeight.Bold)
      .fontColor(selected ? Color.White : '#C9CDD4')
      .padding(0)
      .backgroundColor(selected ? '#D71920' : Color.White)
      .borderRadius(12)
      .border({
        width: 1.5,
        color: selected ? '#D71920' : '#C9CDD4'
      })
      .enabled(this.operatingItemId !== itemId)
      .onClick(() => {
        onTap();
      })
  }

  @Builder
  cartProductImage(item: CartItem) {
    Stack() {
      if (item.productSource === 'homeStatic' && item.productId >= 0 && item.productId < productsList.length) {
        Image(productsList[item.productId].productCardsImagePath)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
      } else if (item.productImage !== null && item.productImage.length > 0) {
        Image(item.productImage)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
      } else {
        Text('HUAWEI')
          .fontSize(13)
          .fontWeight(FontWeight.Bold)
          .fontColor('#8A8F99')
      }
    }
    .width(92)
    .height(92)
    .backgroundColor('#F6F7F9')
    .borderRadius(10)
    .alignContent(Alignment.Center)
  }

  // 6. 修复 cartItemCard - 确保列表项正确响应状态变化
  @Builder
  cartItemCard(item: CartItem) {
    // 使用 @Builder 内部计算状态
    this.cartItemCardContent(item)
  }

  @Builder
  cartItemCardContent(item: CartItem) {
    // 在 Builder 内部通过 this 访问状态
    Row({ space: 10 }) {
      Column() {
        this.cartSelectButton(item.selected, item.id, () => {
          this.toggleCartSelected(item);
        })
      }
      .width(28)
      .height('100%')
      .justifyContent(FlexAlign.Center)

      // 商品图片区域 - 添加透明度效果
      Stack() {
        this.cartProductImage(item)
        if (this.operatingItemId === item.id || this.isDeletingItemId === item.id) {
          Column() {
            Text(this.isDeletingItemId === item.id ? '删除中...' : '...')
              .fontSize(12)
              .fontColor('#999999')
          }
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(255,255,255,0.7)')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
      }
      .width(92)
      .height(92)
      .borderRadius(10)
      .backgroundColor('#F6F7F9')

      Column({ space: 7 }) {
        Text(item.productName)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#111111')
          .lineHeight(20)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .opacity(this.isDeletingItemId === item.id ? 0.5 : 1)

        Text(item.productFeature ?? '')
          .fontSize(12)
          .fontColor('#7A7F85')
          .lineHeight(16)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .width('100%')
          .opacity(this.isDeletingItemId === item.id ? 0.5 : 1)

        Row() {
          Row({ space: 2 }) {
            Text('\u00a5')
              .fontSize(12)
              .fontWeight(FontWeight.Bold)
              .fontColor('#D71920')
            Text(this.priceText(item.productPrice))
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor('#D71920')
          }
          .layoutWeight(1)
          .opacity(this.isDeletingItemId === item.id ? 0.5 : 1)

          Row() {
            Button('-')
              .width(30)
              .height(30)
              .fontSize(18)
              .fontColor('#333333')
              .padding(0)
              .backgroundColor('#F1F2F4')
              .borderRadius(15)
              .enabled(this.operatingItemId !== item.id && this.isDeletingItemId !== item.id)
              .opacity(this.operatingItemId === item.id || this.isDeletingItemId === item.id ? 0.5 : 1)
              .onClick(() => {
                // 当数量为1时，执行删除
                if (item.quantity <= 1) {
                  this.deleteCartProduct(item);
                } else {
                  this.changeCartQuantity(item, item.quantity - 1);
                }
              })

            Text(item.quantity.toString())
              .width(34)
              .fontSize(14)
              .fontColor('#111111')
              .textAlign(TextAlign.Center)
              .opacity(this.isDeletingItemId === item.id ? 0.5 : 1)

            Button('+')
              .width(30)
              .height(30)
              .fontSize(18)
              .fontColor('#333333')
              .padding(0)
              .backgroundColor('#F1F2F4')
              .borderRadius(15)
              .enabled(this.operatingItemId !== item.id && this.isDeletingItemId !== item.id && item.quantity < 99)
              .opacity(this.operatingItemId === item.id || this.isDeletingItemId === item.id || item.quantity >= 99 ? 0.5 : 1)
              .onClick(() => {
                this.changeCartQuantity(item, item.quantity + 1);
              })
          }
          .height(30)
          .alignItems(VerticalAlign.Center)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Button(this.isDeletingItemId === item.id ? '删除中...' : '\u5220\u9664')
          .width(this.isDeletingItemId === item.id ? 80 : 58)
          .height(28)
          .fontSize(13)
          .fontColor(this.isDeletingItemId === item.id ? '#CCCCCC' : '#8A8F96')
          .padding(0)
          .backgroundColor(Color.Transparent)
          .alignSelf(ItemAlign.End)
          .enabled(this.isDeletingItemId !== item.id)
          .onClick(() => {
            this.deleteCartProduct(item);
          })
      }
      .layoutWeight(1)
      .height('100%')
    }
    .width('100%')
    .height(140)
    .padding({ left: 12, right: 12, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
    .borderRadius(16)
    .alignItems(VerticalAlign.Center)
    .opacity(this.isDeletingItemId === item.id ? 0.7 : 1)
    .animation({ duration: 200, curve: Curve.EaseInOut })
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

  // 7. 修复 cartContent 中的 List 渲染 - 使用 @Builder 和 key
  @Builder
  cartContent() {
    if (!this.isLoggedIn()) {
      this.cartEmptyContent('\u8bf7\u5148\u767b\u5f55\u540e\u67e5\u770b\u8d2d\u7269\u8f66', '\u53bb\u767b\u5f55', true)
    } else if (this.cartItems.length === 0 && !this.cartErrorMessage) {
      // 只有第一次加载时显示loading
      if (this.cartLoading) {
        Column() {
          Text('加载中...')
            .fontSize(15)
            .fontColor('#86909C')
        }
        .layoutWeight(1)
        .width('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        this.cartEmptyContent('您的购物车暂时没有商品', '去购物', false)
      }
    } else if (this.cartErrorMessage.length > 0 && this.cartItems.length === 0) {
      Column({ space: 12 }) {
        Text(this.cartErrorMessage)
          .fontSize(15)
          .fontColor('#86909C')
        Button('重试')
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
    } else {
      Column() {
        // 在 cartContent 的 List 中
        List({ space: 12 }) {
          ForEach(this.cartItems, (item: CartItem) => {
            ListItem() {
              this.cartItemCard(item)
            }
          }, (item: CartItem) => item.id.toString()) // 使用 id 作为唯一且稳定的 key
        }
        .layoutWeight(1)
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .scrollBar(BarState.Off)
        // 底部结算栏
        Row() {
          Row({ space: 8 }) {
            this.cartSelectButton(
              this.allCartSelected(),
              -1, // 全选用特殊id
              () => {
                this.toggleCartAll();
              }
            )
            Text('全选')
              .fontSize(15)
              .fontColor('#111111')
          }
          .height('100%')
          .alignItems(VerticalAlign.Center)

          Blank()

          Text('合计: ')
            .fontSize(14)
            .fontColor('#111111')
          Text('\u00a5' + this.priceText(this.cartTotalAmount))
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor('#D71920')

          Button('结算(' + this.cartSelectedCount.toString() + ')')
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
              if (this.cartSelectedCount > 0) {
                // 跳转到结算页面
                try {
                  router.pushUrl({ url: 'pages/CheckoutPage' });
                } catch (error) {
                  this.cartErrorMessage = '页面跳转失败';
                }
              }
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

        if (this.activeTabIndex === 1 || this.activeTabIndex === 4) {
          Stack() {
            if (this.activeTabIndex === 4) {
              Image($r('app.media.youjian'))
                .width(25)
                .height(25)
                .objectFit(ImageFit.Contain)
            } else {
              Text('\u2315')
                .fontSize(28)
                .fontColor('#111111')
            }
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