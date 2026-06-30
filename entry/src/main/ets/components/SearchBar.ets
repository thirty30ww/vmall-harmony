import { SearchSuggestion } from '../api/homeApi';

@Component
export struct SearchBar {
  @Link keyword: string;
  @Prop suggestions: SearchSuggestion[] = [];
  onSearch: (keyword: string) => void = () => {};

  build() {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        TextInput({ placeholder: '搜索商品', text: this.keyword })
          .height(42)
          .layoutWeight(1)
          .fontSize(15)
          .borderRadius(21)
          .backgroundColor('#F4F5F7')
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.keyword = value;
          })

        Button('搜索')
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

      Scroll() {
        Row({ space: 8 }) {
          ForEach(this.suggestions.slice(0, 8), (item: SearchSuggestion) => {
            Text(item.keyword ?? '')
              .fontSize(12)
              .fontColor('#4E5969')
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: 12, right: 12 })
              .height(28)
              .backgroundColor('#F4F5F7')
              .borderRadius(14)
              .onClick(() => {
                this.keyword = item.keyword ?? '';
                this.onSearch(this.keyword);
              })
          }, (item: SearchSuggestion) => item.id.toString())
        }
        .height(28)
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(28)
    }
    .width('100%')
    .height(78)
  }
}