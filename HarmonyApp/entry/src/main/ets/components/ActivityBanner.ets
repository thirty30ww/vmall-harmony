// 活动横幅组件 —— 首页展示活动内容轮播
import { Activity } from '../api/homeApi';

@Component
export struct ActivityBanner {
  @Prop activities: Activity[] = [];

  build() {
    Swiper() {
      ForEach(this.activities.slice(0, 5), (item: Activity, index: number) => {
        Row() {
          Column({ space: 8 }) {
            Text(item.title ?? `华为商城活动 ${index + 1}`)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Text('精选活动入口')
              .fontSize(13)
              .fontColor('#FFE8E8')
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)
        }
        .width('100%')
        .height(128)
        .padding(20)
        .borderRadius(8)
        .linearGradient({
          angle: 135,
          colors: [
            ['#D71920', 0],
            ['#343A40', 1]
          ]
        })
      }, (item: Activity) => item.id.toString())
    }
    .autoPlay(true)      // 自动轮播
    .interval(3500)      // 切换间隔 3.5 秒
    .indicator(true)     // 显示指示器
    .height(128)
    .width('100%')
  }
}
