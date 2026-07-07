// AI 智能导购悬浮按钮组件 —— 支持拖拽移动，点击跳转 AI 聊天页
import { router, display, window } from '@kit.ArkUI';

@Component
export struct AiFloatingButton {
  initBottom: number = 90;        // 初始底部偏移（距底部距离）
  @State posX: number = 0;        // 按钮 X 位置
  @State posY: number = 0;        // 按钮 Y 位置
  private startX: number = 0;     // 拖拽起始 X
  private startY: number = 0;     // 拖拽起始 Y
  private winW: number = 360;     // 窗口宽度
  private winH: number = 800;     // 窗口高度

  // 初始化：获取窗口尺寸，计算按钮初始位置
  aboutToAppear() {
    const defaultDisplay = display.getDefaultDisplaySync();
    this.winW = px2vp(defaultDisplay.width);
    this.winH = px2vp(defaultDisplay.height) - 96;
    this.setPosition();
    try {
      window.getLastWindow(getContext(this)).then((win: window.Window) => {
        const rect = win.getWindowProperties().windowRect;
        this.winW = px2vp(rect.width);
        this.winH = px2vp(rect.height);
        let bottomPad = 60;
        try {
          const navArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
          if (navArea && navArea.bottomRect && navArea.bottomRect.height > 0) {
            bottomPad = Math.max(bottomPad, px2vp(navArea.bottomRect.height));
          }
        } catch (_e2) {}
        try {
          const sysArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
          if (sysArea && sysArea.bottomRect && sysArea.bottomRect.height > 0) {
            bottomPad = Math.max(bottomPad, px2vp(sysArea.bottomRect.height));
          }
        } catch (_e3) {}
        this.winH = px2vp(rect.height) - bottomPad;
        this.setPosition();
      });
    } catch (_e) {}
  }

  // 计算按钮位置（右下角）
  setPosition() {
    this.posX = this.winW - 56 - 16;
    this.posY = this.winH - 56 - this.initBottom;
  }

  build() {
    Column() {
      Image($r('app.media.ai_chat_icon'))
        .width(44)
        .height(44)
    }
    .width(56)
    .height(56)
    .backgroundColor('#D71920')
    .borderRadius(28)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .shadow({ radius: 12, color: '#40D71920', offsetX: 0, offsetY: 4 })
    .position({ left: this.posX, top: this.posY })
    // 拖拽手势：支持在屏幕上自由拖动
    .gesture(
      PanGesture()
        .onActionStart(() => {
          this.startX = this.posX;
          this.startY = this.posY;
        })
        .onActionUpdate((event: GestureEvent) => {
          let newX = this.startX + event.offsetX;
          let newY = this.startY + event.offsetY;
          newX = Math.max(0, Math.min(this.winW - 56, newX));
          newY = Math.max(0, Math.min(this.winH - 56, newY));
          this.posX = newX;
          this.posY = newY;
        })
    )
    // 点击跳转 AI 聊天页
    .onClick(() => {
      router.pushUrl({ url: 'pages/AiChatPage' });
    })
  }
}
