//商品类型枚举值
export enum ProductType {
  PHONE = '手机',
  TABLET = '平板',
  WEARABLE = '穿戴',
  COMPUTER = '电脑',
  AUDIO = '音频',
  SMART_HOME = '鸿蒙智家'
}
//商品分类列表模板
export  interface  ProductsListData {
  productCardsImagePath : Resource
  productName:string
  description:string
  originalPrice:number
  discountPrice:number | null
  type: ProductType
}

export const productsList:ProductsListData[]=[
  {
    productCardsImagePath:$r('app.media.productsList_nova16pro'),
    productName:'nova 16 Pro',
    description:'2亿红枫影像|麒麟9010S芯片|7000mAh巨鲸电池',
    originalPrice:3899,
    discountPrice:null,
    type: ProductType.PHONE
  },
  {
    productCardsImagePath:$r('app.media.productsList_nova16'),
    productName:'nova 16',
    description:'后置红枫影像',
    originalPrice:2999,
    discountPrice:null,
    type: ProductType.PHONE
  },
  {
    productCardsImagePath:$r('app.media.productsList_MateX7'),
    productName:'Mate X7',
    description:'超可靠折叠玄武架构',
    originalPrice:13999,
    discountPrice:11999,
    type: ProductType.PHONE
  },
  {
    productCardsImagePath:$r('app.media.productsList_PuraXMax'),
    productName:'Pura X Max',
    description:'双面阔型屏|AI灵感妙创',
    originalPrice:11999,
    discountPrice:null,
    type: ProductType.PHONE
  },

  {
    productCardsImagePath:$r('app.media.productsList_Mate80ProMax'),
    productName:'Mate80 Pro Max',
    description:'全金属玄武架构',
    originalPrice:7499,
    discountPrice:null,
    type: ProductType.PHONE
  },

  {
    productCardsImagePath:$r('app.media.productsList_MatePadProMax'),
    productName:'MatePad Pro Max',
    description:'超轻超薄|鸿蒙专业生产力|音悦家App',
    originalPrice:5999,
    discountPrice:null,
    type: ProductType.TABLET
  },
  {
    productCardsImagePath:$r('app.media.productsList_MatePad115_2026'),
    productName:'MatePad 11.5 2026',
    description:'120 HZ高刷全面屏',
    originalPrice:1999,
    discountPrice:null,
    type: ProductType.TABLET
  },
  {
    productCardsImagePath:$r('app.media.ProductsList_MatePadEdge'),
    productName:'MatePad Edge',
    description:'X90系列芯片首登平板',
    originalPrice:5999,
    discountPrice:null,
    type: ProductType.TABLET
  },
  {
    productCardsImagePath:$r('app.media.productsList_MatePad115S_2025'),
    productName:'MatePad 11.5S 2025',
    description:'144Hz高刷全面屏|华为笔记',
    originalPrice:2049,
    discountPrice:null,
    type: ProductType.TABLET
  },
  {
    productCardsImagePath:$r('app.media.productsList_MatePadMini'),
    productName:'MatePad Mini',
    description:'全网通通话|超轻薄设计',
    originalPrice:3249,
    discountPrice:2949,
    type: ProductType.TABLET
  },
  {
    productCardsImagePath:$r('app.media.productsList_WATCH5'),
    productName:'WATCH 5',
    description:'X-TAP智感窗|腕上小艺|手势操控',
    originalPrice:2499,
    discountPrice:2099,
    type: ProductType.WEARABLE
  },
  {
    productCardsImagePath:$r('app.media.productsList_HuaWeiShouHuan11Pro'),
    productName:'华为手环 11 Pro',
    description:'1.62英寸高亮大屏',
    originalPrice:349,
    discountPrice:null,
    type: ProductType.WEARABLE
  },
  {
    productCardsImagePath:$r('app.media.productsList_ChaoXinXinX1Pro'),
    productName:'华为超新星手表 X1 Prp',
    description:'5天关机定位|掌上相机',
    originalPrice:2298,
    discountPrice:null,
    type: ProductType.WEARABLE
  },
  {
    productCardsImagePath:$r('app.media.productsList_WATCH_FIT5Pro'),
    productName:'WATCH FIT 5 Pro',
    description:'1.92英寸窄边框全面屏',
    originalPrice:2099,
    discountPrice:null,
    type: ProductType.WEARABLE
  },
  {
    productCardsImagePath:$r('app.media.productsList_ULTIMATE_DESIGN'),
    productName:'WATCH ULTIMATE DESIGN',
    description:'华为首款珠宝智能腕表',
    originalPrice:29999,
    discountPrice:null,
    type: ProductType.WEARABLE
  },
  {
    productCardsImagePath:$r('app.media.productsList_MateBook14HongMeng'),
    productName:'MateBook 14 鸿蒙版',
    description:'2.8K OLED触控屏',
    originalPrice:6699,
    discountPrice:6199,
    type: ProductType.COMPUTER
  },
  {
    productCardsImagePath:$r('app.media.productsList_MateViewGT'),
    productName:'MateView GT 27英寸',
    description:'27 英寸全面屏|2K200 Hz',
    originalPrice:1099,
    discountPrice:899,
    type: ProductType.COMPUTER
  },
  {
    productCardsImagePath:$r('app.media.productsList_HUAWEIMateViewSE'),
    productName:'HUAWEI MateView SE 27英寸',
    description:'27英寸 IPS屏',
    originalPrice:599,
    discountPrice:549,
    type: ProductType.COMPUTER
  },
  {
    productCardsImagePath:$r('app.media.productsList_MateBookD16E'),
    productName:'MateBook D 16 SE',
    description:'16英寸全面屏',
    originalPrice:4999,
    discountPrice:4499,
    type: ProductType.COMPUTER
  },
  {
    productCardsImagePath:$r('app.media.productsList_MateBookPro'),
    productName:'MateBook Pro',
    description:'鸿蒙A|970克超轻薄长续航',
    originalPrice:8999,
    discountPrice:7999,
    type: ProductType.COMPUTER
  },
  {
    productCardsImagePath:$r('app.media.productsList_FreeClip2'),
    productName:'FreeClip 2',
    description:'全新 C 形桥 舒适稳固',
    originalPrice:1599,
    discountPrice:1299,
    type: ProductType.AUDIO
  },
  {
    productCardsImagePath:$r('app.media.productsList_FreeBudsPro5'),
    productName:'FreeBuds Pro5',
    description:'母带级无损音质',
    originalPrice:1559,
    discountPrice:1259,
    type: ProductType.AUDIO
  },
  {
    productCardsImagePath:$r('app.media.productsList_FreeBuds6'),
    productName:'FreeBuds 6',
    description:'超然感知原声单元',
    originalPrice:799,
    discountPrice:669,
    type: ProductType.AUDIO
  },
  {
    productCardsImagePath:$r('app.media.productsList_FreeBuds7i'),
    productName:'FreeBuds 7i',
    description:'智慧动态降噪 4.0',
    originalPrice:599,
    discountPrice:454,
    type: ProductType.AUDIO
  },
  {
    productCardsImagePath:$r('app.media.productsList_FreeBuds6i'),
    productName:'FreeBuds 6i',
    description:'旗舰级降噪深度',
    originalPrice:399,
    discountPrice:299,
    type: ProductType.AUDIO
  },
  {
    productCardsImagePath:$r('app.media.productsList_HuaWeiVisionZhiHuiPing6SE'),
    productName:'华为Vision智慧屏 6SE',
    description:'Super MiniLED 鸿鹄画质',
    originalPrice:2999,
    discountPrice:2676,
    type: ProductType.SMART_HOME
  },
  {
    productCardsImagePath:$r('app.media.productsList_HuaWeiZhiNengMenSuo2Pro'),
    productName:'华为智能门锁 2 Pro',
    description:'AI 3D 人脸识别 3.0',
    originalPrice:2799,
    discountPrice:2464,
    type: ProductType.SMART_HOME
  },
  {
    productCardsImagePath:$r('app.media.productsList_HuaWeiLingXiaoZiMuLuYouQ7'),
    productName:'华为凌霄智能路由器Q7',
    description:'全屋千兆免布线，插电就有高速网',
    originalPrice:1299,
    discountPrice:1097,
    type: ProductType.SMART_HOME
  },
  {
    productCardsImagePath:$r('app.media.productsList_HuaWeiJiaTingCunCHU'),
    productName:'华为家庭存储 有盘版',
    description:'手机扩容神器',
    originalPrice:3059,
    discountPrice:null,
    type: ProductType.SMART_HOME
  },
  {
    productCardsImagePath:$r('app.media.productsList_HuaWeiVisionZhiHuiPing6'),
    productName:'华为Vision智慧屏 6',
    description:'4.9cm 超薄如画',
    originalPrice:4999,
    discountPrice:4759,
    type: ProductType.SMART_HOME
  },
]
