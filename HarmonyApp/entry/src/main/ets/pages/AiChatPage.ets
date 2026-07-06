import { router, KeyboardAvoidMode } from '@kit.ArkUI';
import {
  chatWithAI,
  listConversations,
  getConversation,
  deleteConversation,
  ChatMessage as ApiChatMessage,
  Conversation
} from '../api/aiApi';

interface ChatMessage {
  role: 'user' | 'ai';
  content: string;
}

@Entry
@Component
struct AiChatPage {
  @State messages: ChatMessage[] = [];
  @State inputText: string = '';
  @State loading: boolean = false;
  @State conversations: Conversation[] = [];
  @State activeConversationId: number | null = null;
  @State showSidebar: boolean = false;
  private scroller: Scroller = new Scroller();

  scrollToBottom(): void {
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom);
    }, 80);
  }

  aboutToAppear() {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    this.loadConversations();
  }

  aboutToDisappear() {
    this.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.OFFSET);
  }

  async loadConversations() {
    try {
      const list = await listConversations();
      this.conversations = list;
      if (list.length > 0 && this.activeConversationId === null) {
        this.switchConversation(list[0].id);
      } else if (list.length === 0) {
        this.addGreeting();
      }
    } catch (_) {
      this.addGreeting();
    }
  }

  addGreeting() {
    if (this.messages.length === 0) {
      const greeting: ChatMessage = {
        role: 'ai',
        content: '你好！我是智能导购助手，可以帮你推荐商品、了解产品信息。请问有什么需要帮助的吗？'
      };
      this.messages = [greeting];
    }
  }

  async switchConversation(id: number) {
    this.activeConversationId = id;
    try {
      const detail = await getConversation(id);
      const msgs: ChatMessage[] = detail.messages.map((m): ChatMessage => ({
        role: m.role === 'assistant' ? 'ai' : 'user',
        content: m.content
      }));
      this.messages = msgs;
      if (msgs.length === 0) {
        this.addGreeting();
      }
      this.scrollToBottom();
    } catch (_) {
      this.messages = [];
      this.addGreeting();
    }
  }

  startNewConversation() {
    this.activeConversationId = null;
    this.messages = [];
    this.addGreeting();
    this.showSidebar = false;
  }

  async deleteConv(id: number) {
    try {
      await deleteConversation(id);
      this.conversations = this.conversations.filter(c => c.id !== id);
      if (this.activeConversationId === id) {
        const next = this.conversations.length > 0 ? this.conversations[0].id : null;
        if (next) {
          this.switchConversation(next);
        } else {
          this.startNewConversation();
        }
      }
    } catch (_) {}
  }

  build() {
    Stack() {
      Column() {
        if (this.showSidebar && this.conversations.length > 0) {
          this.buildConversationList()
        }
        this.buildChatArea()
        this.buildInputArea()
      }
      .width('100%')
      .height('100%')
      .padding({ top: 52 })

      Row() {
        Text('<')
          .fontSize(22)
          .fontColor('#1D2129')
          .onClick(() => router.back())
        Text('  智能导购助手')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#1D2129')
        Blank()
        if (this.conversations.length > 0) {
          Image($r('app.media.history'))
            .width(22).height(22)
            .onClick(() => { this.showSidebar = !this.showSidebar })
            .margin({ right: 16 })
        }
        Image($r('app.media.new_chat'))
          .width(22).height(22)
          .onClick(() => this.startNewConversation())
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

  @Builder buildConversationList() {
    Column() {
      ForEach(this.conversations, (conv: Conversation) => {
        Row() {
          Text(conv.title)
            .fontSize(14)
            .fontColor(this.activeConversationId === conv.id ? '#D71920' : '#1D2129')
            .fontWeight(this.activeConversationId === conv.id ? FontWeight.Medium : FontWeight.Regular)
            .layoutWeight(1)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text('✕')
            .fontSize(14)
            .fontColor('#C9CDD4')
            .onClick(() => this.deleteConv(conv.id))
        }
        .width('100%')
        .height(44)
        .padding({ left: 16, right: 12 })
        .onClick(() => {
          this.switchConversation(conv.id);
          this.showSidebar = false;
        })
      })
    }
    .width('100%')
    .backgroundColor(Color.White)
    .border({ width: { bottom: 0.5 }, color: { bottom: '#E5E6E8' } })
  }

  @Builder buildChatArea() {
    Scroll(this.scroller) {
      Column() {
        ForEach(this.messages, (msg: ChatMessage) => {
          if (msg.role === 'ai') {
            this.aiMessage(msg)
          } else {
            this.userMessage(msg)
          }
        })
        if (this.loading) {
          this.loadingIndicator()
        }
      }
      .width('100%')
      .padding({ top: 12, bottom: 12 })
    }
    .layoutWeight(1)
    .width('100%')
    .align(Alignment.Top)
  }

  @Builder buildInputArea() {
    Row() {
      TextInput({ text: this.inputText, placeholder: '输入问题...' })
        .layoutWeight(1)
        .height(44)
        .fontSize(15)
        .backgroundColor('#F2F3F5')
        .borderRadius(22)
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => { this.inputText = value })
        .onFocus(() => { this.scrollToBottom() })

      Button() {
        Text('发送')
          .fontColor(Color.White).fontSize(15)
      }
      .width(64).height(40)
      .backgroundColor('#D71920')
      .borderRadius(20)
      .margin({ left: 8 })
      .enabled(this.inputText.trim().length > 0 && !this.loading)
      .onClick(() => this.sendMessage())
    }
    .width('100%')
    .height(64)
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  async sendMessage() {
    const text = this.inputText.trim();
    if (text.length === 0 || this.loading) return;

    const userMsg: ChatMessage = { role: 'user', content: text };
    this.messages.push(userMsg);
    this.inputText = '';
    this.loading = true;
    this.scrollToBottom();

    const history: ApiChatMessage[] = [];
    for (let i = 0; i < this.messages.length - 1; i++) {
      const msg = this.messages[i];
      history.push({
        role: msg.role === 'ai' ? 'assistant' : 'user',
        content: msg.content
      });
    }

    try {
      const result = await chatWithAI(text, history, this.activeConversationId);
      this.activeConversationId = result.conversationId;
      const aiMsg: ChatMessage = { role: 'ai', content: result.reply };
      this.messages.push(aiMsg);
    } catch (_) {
      const errMsg: ChatMessage = { role: 'ai', content: '抱歉，暂时无法连接智能助手，请稍后再试。' };
      this.messages.push(errMsg);
    } finally {
      this.loading = false;
      this.scrollToBottom();
      this.refreshConversations();
    }
  }

  async refreshConversations() {
    try {
      this.conversations = await listConversations();
    } catch (_) {}
  }

  @Builder userMessage(msg: ChatMessage) {
    Row() {
      Blank()
      Column() {
        Text(msg.content)
          .fontSize(15)
          .fontColor(Color.White)
          .padding({ left: 14, right: 14, top: 10, bottom: 10 })
          .backgroundColor('#D71920')
          .borderRadius({ topLeft: 16, topRight: 4, bottomLeft: 16, bottomRight: 16 })
          .maxLines(100)
          .lineHeight(22)
      }
      .margin({ left: 60 })
      Image($r('app.media.avatar'))
        .width(28).height(28).borderRadius(14).margin({ left: 8 })
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 8 })
    .alignItems(VerticalAlign.Top)
  }

  @Builder aiMessage(msg: ChatMessage) {
    Row() {
      Image($r('app.media.ai_chat_icon'))
        .width(28).height(28).borderRadius(14).margin({ right: 8 })
        .alignSelf(ItemAlign.Start)
      Column() {
        Text(msg.content)
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

  @Builder loadingIndicator() {
    Row() {
      Image($r('app.media.ai_chat_icon'))
        .width(28).height(28).borderRadius(14).margin({ right: 8 })
        .alignSelf(ItemAlign.Start)
      Text('思考中...')
        .fontSize(14)
        .fontColor('#86909C')
        .padding({ left: 14, right: 14, top: 10, bottom: 10 })
        .backgroundColor(Color.White)
        .borderRadius({ topLeft: 4, topRight: 16, bottomLeft: 16, bottomRight: 16 })
      Blank()
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 8 })
    .alignItems(VerticalAlign.Top)
  }
}
