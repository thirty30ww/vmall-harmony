// 分类数据类型 —— 用于首页顶部分类导航
export interface Category {
  categoryImagePath: Resource,
  categoryName: string
}

// 首页顶部分类列表数据，共 16 个分类入口
export const categoryData: Category[] = [
  { categoryImagePath: $r('app.media.category_HuaWeiShouJi'), categoryName: '华为手机' },
  { categoryImagePath: $r('app.media.category_HongMengZhiJia'), categoryName: '鸿蒙智家' },
  { categoryImagePath: $r('app.media.category_YunDongJianKang'), categoryName: '运动健康' },
  { categoryImagePath: $r('app.media.category_HongMengZhiXing'), categoryName: '鸿蒙智行' },
  { categoryImagePath: $r('app.media.category_YinYingYuLe'), categoryName: '影音娱乐' },
  { categoryImagePath: $r('app.media.category_QianKunZhiJia'), categoryName: '乾崑智驾' },
  { categoryImagePath: $r('app.media.category_ZhiHuiBanGong'), categoryName: '智慧办公' },
  { categoryImagePath: $r('app.media.category_HongMengZhiXuan'), categoryName: '鸿蒙智选' },
  { categoryImagePath: $r('app.media.category_JiaoYuYouHui'), categoryName: '教育优惠' },
  { categoryImagePath: $r('app.media.category_PeiJianZhongXin'), categoryName: '配件中心' },
  { categoryImagePath: $r('app.media.category_TaZhiXuan'), categoryName: '她之选' },
  { categoryImagePath: $r('app.media.category_ZhiBoJian'), categoryName: '直播间' },
  { categoryImagePath: $r('app.media.category_QiYeShangYong'), categoryName: '企业商用' },
  { categoryImagePath: $r('app.media.category_YiJiuHuanXin'), categoryName: '以旧换新' },
  { categoryImagePath: $r('app.media.category_ZhongCe'), categoryName: '众测' },
  { categoryImagePath: $r('app.media.category_WoDeJiFen'), categoryName: '我的积分' }
]
