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
      }, (image: Resource, index: number) => index.toString())
    }
    .width('100%')
    .aspectRatio(1)
    .autoPlay(true)
    .interval(3500)
    .indicator(true)
  }
}