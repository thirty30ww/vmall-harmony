// 底部导航栏组件 —— 首页/分类/发现/购物车/我的 五个 Tab 切换
@Component
export struct BottomNavBar {
  @Link activeIndex: number;                   // 当前激活的 Tab 索引
  onTabChange: (index: number) => void = () => {};  // Tab 切换回调

  // 根据选中状态显示对应图标（选中/未选中）
  @Builder
  navIcon(index: number) {
    if (index === 0) {
      Image(this.activeIndex === index ? $r('app.media.tabBuilder_ShouYe_select') : $r('app.media.tabBuilder_ShouYe'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
    } else if (index === 1) {
      Image(this.activeIndex === index ? $r('app.media.tabBuilder_FenLei_select') : $r('app.media.tabBuilder_FenLei'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
    } else if (index === 2) {
      Image(this.activeIndex === index ? $r('app.media.tabBuilder_FaXian_select') : $r('app.media.tabBuilder_FaXian'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
    } else if (index === 3) {
      Image(this.activeIndex === index ? $r('app.media.tabBuilder_GouWuChe_select') : $r('app.media.tabBuilder_GouWuChe'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
    } else {
      Image(this.activeIndex === index ? $r('app.media.tabBuilder_WoDe_select') : $r('app.media.tabBuilder_WoDe'))
        .width(24)
        .height(24)
        .objectFit(ImageFit.Contain)
    }
  }

  // 单个导航项
  @Builder
  navItem(index: number, label: string) {
    Column({ space: 2 }) {
      this.navIcon(index)

      Text(label)
        .fontSize(12)
        .lineHeight(16)
        .height(16)
        .fontColor(this.activeIndex === index ? '#D71920' : '#7A7F85')
        .fontWeight(this.activeIndex === index ? FontWeight.Bold : FontWeight.Regular)
        .textAlign(TextAlign.Center)
        .width('100%')
    }
    .layoutWeight(1)
    .height(52)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.activeIndex = index;
      this.onTabChange(index);
    })
  }

  build() {
    Row() {
      this.navItem(0, '首页')
      this.navItem(1, '分类')
      this.navItem(2, '发现')
      this.navItem(3, '购物车')
      this.navItem(4, '我的')
    }
    .width('100%')
    .height(60)
    .padding({ left: 4, right: 4, top: 4, bottom: 4 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }
}
