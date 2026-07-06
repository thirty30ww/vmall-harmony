@Component
export struct SearchBar {
  @Link keyword: string;
  onSearch: (keyword: string) => void = () => {};

  build() {
    Column() {
      Row({ space: 8 }) {
        Row({ space: 6 }) {
          Text('\uD83D\uDD0D')
            .fontSize(16)
            .fontColor('#86909C')

          TextInput({ placeholder: '\u641c\u7d22\u534e\u4e3a\u5546\u57ce\u5546\u54c1', text: this.keyword })
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

        Button('\u641c\u7d22')
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