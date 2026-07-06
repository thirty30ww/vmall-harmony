import { router, KeyboardAvoidMode } from '@kit.ArkUI';
import { chatWithAI } from '../api/aiApi';

interface ChatMessage {
  role: 'user' | 'ai';
  content: string;
}

@Entry
@Component
struct AiChatPage {
  @State messages: ChatMessage[] = [
    { role: 'ai', content: '你好！我是智能导购助手，可以帮你推荐商品、了解产品信息。请问有什么需要帮助的吗？' }
  ];
  @State inputText: string = '';
  @State loading: boolean = false;
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
  }

  aboutToDisappear() {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
  }

  build() {
    Stack() {
      Column() {
        Scroll(this.scroller) {
          Column() {
            ForEach(this.messages, (msg: ChatMessage) => {
              if (msg.role === 'ai') {
                this.aiMessage(msg.content)
              } else {
                this.userMessage(msg.content)
              }
            }, (item: ChatMessage) => item.content + item.role)

            if (this.loading) {
              Row() {
                Image($r('app.media.ai_chat_icon'))
                  .width(28)
                  .height(28)
                  .borderRadius(14)
                  .margin({ right: 8 })
                Text('思考中...')
                  .fontSize(14)
                  .fontColor('#86909C')
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 8 })
              .alignItems(VerticalAlign.Top)
            }
          }
          .width('100%')
          .padding({ top: 12, bottom: 12 })
        }
        .layoutWeight(1)
        .width('100%')
        .align(Alignment.Top)

        Row() {
          TextInput({ text: this.inputText, placeholder: '输入问题...' })
            .layoutWeight(1)
            .height(44)
            .fontSize(15)
            .backgroundColor('#F2F3F5')
            .borderRadius(22)
            .padding({ left: 16, right: 16 })
            .onChange((value: string) => {
              this.inputText = value;
            })
            .onFocus(() => {
              this.scroller.scrollEdge(Edge.Bottom);
            })

          Button() {
            Text('发送')
              .fontColor(Color.White)
              .fontSize(15)
          }
          .width(64)
          .height(40)
          .backgroundColor('#D71920')
          .borderRadius(20)
          .margin({ left: 8 })
          .enabled(this.inputText.trim().length > 0 && !this.loading)
          .onClick(() => {
            this.sendMessage();
          })
        }
        .width('100%')
        .height(64)
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
        .backgroundColor(Color.White)
        .alignItems(VerticalAlign.Center)
      }
      .width('100%')
      .height('100%')
      .padding({ top: 52 })

      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#1D2129')
          .onClick(() => {
            router.back();
          })
        Text('  智能导购助手')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1D2129')
        Blank()
      }
      .width('100%')
      .height(52)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .border({ width: { bottom: 0.5 }, color: { bottom: '#E5E6E8' } })
      .alignItems(VerticalAlign.Center)
      .position({ top: 0 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F6F8')
  }

  @Builder userMessage(content: string) {
    Row() {
      Blank()
      Column() {
        Text(content)
          .fontSize(15)
          .fontColor(Color.White)
          .padding({ left: 14, right: 14, top: 10, bottom: 10 })
          .backgroundColor('#D71920')
          .borderRadius({ topLeft: 16, topRight: 4, bottomLeft: 16, bottomRight: 16 })
          .maxLines(100)
          .lineHeight(22)
      }
      .margin({ left: 60 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 8 })
    .alignItems(VerticalAlign.Top)
  }

  @Builder aiMessage(content: string) {
    Row() {
      Image($r('app.media.ai_chat_icon'))
        .width(28)
        .height(28)
        .borderRadius(14)
        .margin({ right: 8 })
        .alignSelf(ItemAlign.Start)

      Column() {
        Text(content)
          .fontSize(15)
          .fontColor('#1D2129')
          .padding({ left: 14, right: 14, top: 10, bottom: 10 })
          .backgroundColor(Color.White)
          .borderRadius({ topLeft: 4, topRight: 16, bottomLeft: 16, bottomRight: 16 })
          .maxLines(100)
          .lineHeight(22)
      }
      .margin({ right: 60 })

      Blank()
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 8 })
    .alignItems(VerticalAlign.Top)
  }

  async sendMessage() {
    const text: string = this.inputText.trim();
    if (text.length === 0 || this.loading) return;

    this.messages.push({ role: 'user', content: text });
    this.inputText = '';
    this.loading = true;

    try {
      const result = await chatWithAI(text);
      this.messages.push({ role: 'ai', content: result.reply });
    } catch (e) {
      this.messages.push({ role: 'ai', content: '抱歉，暂时无法连接智能助手，请稍后再试。' });
    } finally {
      this.loading = false;
    }

    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 100);
  }
}
