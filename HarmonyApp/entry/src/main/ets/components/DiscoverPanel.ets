// DiscoverPanel.ets
import {
  createEmptyDiscoverData,
  DiscoverData,
  DiscoverItem,
  DiscoverSectionGroup,
  getDiscoverData
} from '../api/discoverApi';

const DEFAULT_DISCOVER_PAGE_ID: string = '101151623';
const DISCOVER_TABS: string[] = ['推荐', '发布会', '选购攻略', '玩机技巧'];

const TAB_PAGE_MAP: Record<string, string> = {
  '推荐': '101151080',
  '发布会': '101151077',
  '选购攻略': '101151081',
  '玩机技巧': '101151082'
};

@Component
struct BannerSwiper {
  @Prop bannerItemsData: DiscoverItem[] = [];

  build() {
    if (this.bannerItemsData.length > 0) {
      Swiper() {
        ForEach(this.bannerItemsData, (item: DiscoverItem) => {
          Image(item.imageUrl ?? '')
            .width('100%')
            .objectFit(ImageFit.Auto)
            .borderRadius(18)
            .onClick(() => {
              if (item.linkUrl) {
                console.info('点击跳转: ' + item.linkUrl);
              }
            })
        }, (item: DiscoverItem) => item.id.toString())
      }
      .width('100%')
      .autoPlay(true)
      .interval(3500)
      .indicator(true)
      .indicatorStyle({
        color: '#D0D0D0',
        selectedColor: '#111111'
      })
      .borderRadius(18)
    } else {
      Column() {
        Text('暂无轮播内容')
          .fontSize(14)
          .fontColor('#86909C')
      }
      .width('100%')
      .height(200)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .borderRadius(18)
    }
  }
}

@Component
struct TabsBar {
  @Prop selectedIndex: number = 0;
  onTabClick?: (index: number, name: string) => void;

  build() {
    Column() {
      Row({ space: 8 }) {
        ForEach(DISCOVER_TABS, (tabName: string, index: number) => {
          Text(tabName)
            .fontSize(15)
            .fontWeight(this.selectedIndex === index ? FontWeight.Bold : FontWeight.Regular)
            .fontColor(this.selectedIndex === index ? Color.White : '#222222')
            .textAlign(TextAlign.Center)
            .height(40)
            .layoutWeight(1)
            .backgroundColor(this.selectedIndex === index ? '#111111' : '#E8EBEF')
            .borderRadius(20)
            .onClick(() => {
              if (this.onTabClick) {
                this.onTabClick(index, tabName);
              }
            })
        }, (tabName: string) => tabName)
      }
      .width('100%')
      .height(46)
    }
    .width('100%')
  }
}

@Component
struct ContentGrid {
  @Prop items: DiscoverItem[] = [];

  displayTitle(item: DiscoverItem): string {
    const title: string = item.title ?? '';
    if (title.length > 0 && title !== '1') {
      return title;
    }
    const productName: string = item.productName ?? '';
    if (productName.length > 0) {
      return productName;
    }
    return '精选内容';
  }

  displaySubTitle(item: DiscoverItem): string {
    const subtitle: string = item.subtitle ?? '';
    if (subtitle.length > 0) {
      return subtitle;
    }
    const authorName: string = item.authorName ?? '';
    if (authorName.length > 0) {
      return authorName;
    }
    return '';
  }

  formatViewCount(count: number | null): string {
    if (count === null || count === undefined) return '';
    if (count >= 10000) {
      return (count / 10000).toFixed(1) + '万';
    }
    return count.toString();
  }

  build() {
    Grid() {
      if (this.items.length > 0) {
        ForEach(this.items, (item: DiscoverItem) => {
          GridItem() {
            Column() {
              Stack() {
                if ((item.imageUrl ?? '').length > 0) {
                  Image(item.imageUrl ?? '')
                    .width('100%')
                    .height(180)
                    .objectFit(ImageFit.Cover)
                    .borderRadius({ topLeft: 8, topRight: 8 })
                } else {
                  Column() {
                    Text('HUAWEI')
                      .fontSize(18)
                      .fontWeight(FontWeight.Bold)
                      .fontColor('#8A8F99')
                  }
                  .width('100%')
                  .height(180)
                  .justifyContent(FlexAlign.Center)
                  .backgroundColor('#F4F5F7')
                  .borderRadius({ topLeft: 8, topRight: 8 })
                }

                if (item.contentType === '2') {
                  Text('视频')
                    .fontSize(10)
                    .fontColor(Color.White)
                    .backgroundColor('rgba(0,0,0,0.6)')
                    .borderRadius(4)
                    .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                    .position({ x: 8, y: 8 })
                }
              }
              .width('100%')
              .height(180)
              .clip(true)

              Column() {
                Text(this.displayTitle(item))
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#1D2129')
                  .lineHeight(20)
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .width('100%')

                Row() {
                  Text(this.displaySubTitle(item))
                    .fontSize(13)
                    .fontColor('#86909C')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .layoutWeight(1)

                  if (item.viewCount !== null && item.viewCount !== undefined) {
                    Text(this.formatViewCount(item.viewCount))
                      .fontSize(12)
                      .fontColor('#C0C4CC')
                  }
                }
                .width('100%')
                .margin({ top: 4 })
              }
              .padding({ left: 10, right: 10, bottom: 10 })
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .height(250)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .onClick(() => {
              if (item.linkUrl) {
                console.info('点击内容: ' + item.linkUrl);
              }
            })
          }
        }, (item: DiscoverItem) => item.id.toString())
      } else {
        GridItem() {
          Column() {
            Text('当前频道暂无内容')
              .fontSize(14)
              .fontColor('#86909C')
          }
          .width('100%')
          .height(160)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(Color.White)
          .borderRadius(12)
        }
      }
    }
    .columnsTemplate('1fr')
    .columnsGap(0)
    .rowsGap(10)
    .width('100%')
  }
}

@Component
export struct DiscoverPanel {
  @State discoverData: DiscoverData = createEmptyDiscoverData();
  @State bannerItemsData: DiscoverItem[] = [];
  @State selectedTabIndex: number = 0;
  @State selectedTabName: string = '推荐';
  @State contentTabName: string = '推荐';
  @State errorMessage: string = '';
  @State isBannerLoaded: boolean = false;

  aboutToAppear() {
    this.loadBannerData();
    this.loadDiscover(this.selectedTabName);
  }

  async loadBannerData() {
    if (this.isBannerLoaded) {
      return;
    }
    try {
      const data = await getDiscoverData(DEFAULT_DISCOVER_PAGE_ID, '推荐');
      const allItems: DiscoverItem[] = [];
      data.sections.forEach((group: DiscoverSectionGroup) => {
        group.items.forEach((item: DiscoverItem) => {
          allItems.push(item);
        });
      });

      const banners = allItems.filter((item: DiscoverItem) => {
        return item.pageId === DEFAULT_DISCOVER_PAGE_ID &&
          (item.imageUrl ?? '').length > 0 &&
          (item.itemType === 'ad' || (item.title ?? '').includes('发布会'));
      });

      if (banners.length > 0) {
        this.bannerItemsData = banners.slice(0, 5);
      } else {
        const fallbackBanners = allItems.filter((item: DiscoverItem) => {
          return (item.imageUrl ?? '').length > 0;
        });
        this.bannerItemsData = fallbackBanners.slice(0, 5);
      }
      this.isBannerLoaded = true;
      console.info('轮播图加载完成，数量: ' + this.bannerItemsData.length);
    } catch (error) {
      console.error('加载轮播图失败: ' + JSON.stringify(error));
    }
  }

  async loadDiscover(tabName: string) {
    this.errorMessage = '';
    try {
      const pageId = TAB_PAGE_MAP[tabName] || DEFAULT_DISCOVER_PAGE_ID;
      console.info('请求: pageId=' + pageId + ', tabName=' + tabName);

      this.discoverData = await getDiscoverData(pageId, tabName);
      this.contentTabName = tabName;

      console.info('加载数据成功，sections数量: ' + this.discoverData.sections.length);
    } catch (error) {
      this.errorMessage = '发现页加载失败，请检查后端服务';
      console.error('加载失败: ' + JSON.stringify(error));
    }
  }

  async onTabClick(index: number, tabName: string) {
    this.selectedTabIndex = index;
    this.selectedTabName = tabName;
    await this.loadDiscover(tabName);
  }

  currentSections(): DiscoverSectionGroup[] {
    const matched: DiscoverSectionGroup[] = this.discoverData.sections.filter((group: DiscoverSectionGroup) => {
      const groupTabName = group.section.tabName ?? '';
      const trimmedGroup = groupTabName.trim();
      const trimmedSelected = this.contentTabName.trim();

      if (this.contentTabName === '推荐') {
        return trimmedGroup === '推荐' || trimmedGroup === '发现';
      }
      return trimmedGroup === trimmedSelected;
    });
    return matched;
  }

  currentItems(): DiscoverItem[] {
    const items: DiscoverItem[] = [];
    this.currentSections().forEach((group: DiscoverSectionGroup) => {
      group.items.forEach((item: DiscoverItem) => {
        items.push(item);
      });
    });
    return items;
  }

  contentItems(): DiscoverItem[] {
    const bannerIds: number[] = this.bannerItemsData.map((item: DiscoverItem) => item.id);

    const items = this.currentItems().filter((item: DiscoverItem) => {
      return bannerIds.indexOf(item.id) < 0 && item.itemType !== 'ad';
    });

    console.info('当前频道内容数量: ' + items.length);
    return items;
  }

  @Builder
  topHeader() {
    Row() {
      Text('发现')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .fontColor('#111111')

      Blank()
        .layoutWeight(1)
    }
    .width('100%')
    .height(58)
    .alignItems(VerticalAlign.Center)
    .padding({ left: 16, right: 16, top: 8, bottom: 0 })
  }

  build() {
    Column() {
      this.topHeader()

      Scroll() {
        Column({ space: 16 }) {
          BannerSwiper({ bannerItemsData: this.bannerItemsData })
          TabsBar({
            selectedIndex: this.selectedTabIndex,
            onTabClick: (i: number, n: string): void => { this.onTabClick(i, n); }
          })
          ContentGrid({ items: this.contentItems() })
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 0, bottom: 24 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6F8')
  }
}
