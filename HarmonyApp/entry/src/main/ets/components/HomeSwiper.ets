// 首页轮播图组件 —— 展示华为产品宣传图轮播
const swiperImages: Resource[] = [
  $r('app.media.swiper_PuraXMax'),
  $r('app.media.swiper_Mate80ProMax'),
  $r('app.media.swiper_nova16'),
  $r('app.media.swiper_FreeClip2'),
  $r('app.media.swiper_shangjieH5')
]

@Component
export struct HomeSwiper {
  build() {
    Swiper() {
      ForEach(swiperImages, (image: Resource, index: number) => {
        Image(image)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .borderRadius(18)
      }, (image: Resource, index: number) => index.toString())
    }
    .width('100%')
    .aspectRatio(1)          // 宽高比 1:1
    .autoPlay(true)           // 自动轮播
    .interval(3500)           // 3.5 秒切换
    .indicator(true)          // 显示指示器
    .borderRadius(18)
  }
}
