@Component
export struct SearchBar {
  @Link keyword: string;
  onSearch: (keyword: string) => void = () => {};

  build() {
    Column() {
      Row({ space: 8 }) {
        TextInput({ placeholder: '\u641c\u7d22\u5546\u54c1', text: this.keyword })
          .height(42)
          .layoutWeight(1)
          .fontSize(15)
          .borderRadius(21)
          .backgroundColor('#F4F5F7')
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.keyword = value;
          })

        Button('\u641c\u7d22')
          .height(42)
          .width(64)
          .fontSize(15)
          .fontColor(Color.White)
          .backgroundColor('#111111')
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