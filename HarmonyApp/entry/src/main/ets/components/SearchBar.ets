// 搜索栏组件 —— 首页顶部的商品搜索输入框
@Component
export struct SearchBar {
  @Link keyword: string;                        // 搜索关键字（双向绑定）
  onSearch: (keyword: string) => void = () => {};  // 搜索回调

  build() {
    Column() {
      Row({ space: 8 }) {
        Row({ space: 6 }) {
          TextInput({ placeholder: '搜索华为商城商品', text: this.keyword })
            .height(42)
            .layoutWeight(1)
            .fontSize(14)
            .backgroundColor(Color.Transparent)
            .onChange((value: string) => {
              this.keyword = value;
            })
        }
        .height(42)
        .layoutWeight(1)
        .padding({ left: 12, right: 12 })
        .backgroundColor('#FFFFFF')
        .borderRadius(21)
        .border({ width: 1, color: '#E5E6E8' })

        Button('搜索')
          .height(42)
          .width(64)
          .fontSize(15)
          .fontColor(Color.White)
          .backgroundColor('#D71920')
          .borderRadius(21)
          .onClick(() => {
            this.onSearch(this.keyword);
          })
      }
      .width('100%')
      .height(42)
    }
    .width('100%')
    .height(42)
  }
}
