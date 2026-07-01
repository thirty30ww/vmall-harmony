@Component
export struct BottomNavBar {
  @Link activeIndex: number;

  @Builder
  navItem(index: number, icon: string, label: string) {
    Column() {
      Stack() {
        Text(icon)
          .fontSize(22)
          .fontColor(this.activeIndex === index ? '#D71920' : '#7A7F85')
          .fontWeight(this.activeIndex === index ? FontWeight.Bold : FontWeight.Regular)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(28)
      .alignContent(Alignment.Center)

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
    })
  }

  build() {
    Row() {
      this.navItem(0, '⌂', '首页')
      this.navItem(1, '▦', '分类')
      this.navItem(2, '◉', '发现')
      this.navItem(3, '◇', '购物车')
      this.navItem(4, '○', '我的')
    }
    .width('100%')
    .height(60)
    .padding({ left: 4, right: 4, top: 4, bottom: 4 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }
}