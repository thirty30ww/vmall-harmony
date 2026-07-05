import { router } from '@kit.ArkUI';
import { loginByCode, loginByPassword, LoginResult, sendLoginCode } from '../api/authApi';

@Entry
@Component
struct LoginPage {
  @State phone: string = '';
  @State code: string = '';
  @State password: string = '';
  @State message: string = '';
  @State loading: boolean = false;
  @State loginMode: number = 0;

  canSubmit(): boolean {
    if (this.phone.trim().length !== 11 || this.loading) {
      return false;
    }
    if (this.loginMode === 0) {
      return this.code.trim().length > 0;
    }
    return this.password.trim().length > 0;
  }

  saveLoginResult(result: LoginResult) {
    AppStorage.setOrCreate('token', result.token);
    AppStorage.setOrCreate('phone', result.user.phone);
    AppStorage.setOrCreate('username', result.user.username);
  }

  async handleSendCode() {
    if (this.phone.trim().length !== 11) {
      this.message = '\u8bf7\u8f93\u5165\u6b63\u786e\u7684\u624b\u673a\u53f7';
      return;
    }

    this.loading = true;
    this.message = '';
    try {
      await sendLoginCode(this.phone.trim());
      this.message = '\u9a8c\u8bc1\u7801\u5df2\u751f\u6210\uff0c\u8bf7\u67e5\u770b IDEA \u540e\u7aef\u63a7\u5236\u53f0';
    } catch (error) {
      this.message = '\u9a8c\u8bc1\u7801\u83b7\u53d6\u5931\u8d25\uff1a\u624b\u673a\u53f7\u4e0d\u5b58\u5728\u6216\u540e\u7aef\u672a\u8fde\u63a5';
    } finally {
      this.loading = false;
    }
  }

  async handleLogin() {
    if (!this.canSubmit()) {
      this.message = this.loginMode === 0
        ? '\u8bf7\u8f93\u5165\u624b\u673a\u53f7\u548c\u9a8c\u8bc1\u7801'
        : '\u8bf7\u8f93\u5165\u624b\u673a\u53f7\u548c\u5bc6\u7801';
      return;
    }

    this.loading = true;
    this.message = '';
    try {
      const result: LoginResult = this.loginMode === 0
        ? await loginByCode(this.phone.trim(), this.code.trim())
        : await loginByPassword(this.phone.trim(), this.password.trim());
      this.saveLoginResult(result);
      router.replaceUrl({ url: 'pages/HomePage' });
    } catch (error) {
      this.message = this.loginMode === 0
        ? '\u767b\u5f55\u5931\u8d25\uff0c\u8bf7\u68c0\u67e5\u9a8c\u8bc1\u7801'
        : '\u767b\u5f55\u5931\u8d25\uff0c\u8bf7\u68c0\u67e5\u624b\u673a\u53f7\u6216\u5bc6\u7801';
    } finally {
      this.loading = false;
    }
  }

  @Builder
  modeButton(title: string, mode: number) {
    Text(title)
      .fontSize(16)
      .fontWeight(this.loginMode === mode ? FontWeight.Bold : FontWeight.Regular)
      .fontColor(this.loginMode === mode ? '#007DFF' : 'rgba(0,0,0,0.55)')
      .textAlign(TextAlign.Center)
      .layoutWeight(1)
      .height(42)
      .onClick(() => {
        this.loginMode = mode;
        this.message = '';
      })
  }

  build() {
    Column() {
      Column({ space: 8 }) {
        Image($r('app.media.hwlogo'))
          .width(44)
          .height(44)
          .margin({ bottom: 16 })

        Text('\u534e\u4e3a\u8d26\u53f7')
          .fontColor('#191919')
          .textAlign(TextAlign.Center)
          .width('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)

        Text('\u767b\u5f55\u8d26\u53f7\u4ee5\u4f7f\u7528\u4e91\u7a7a\u95f4\u3001\u5e94\u7528\u5e02\u573a\u53ca\u66f4\u591a\u670d\u52a1')
          .fontColor('rgba(0,0,0,0.6)')
          .textAlign(TextAlign.Center)
          .width('100%')
          .fontSize(14)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .margin({ bottom: 32 })

      Row() {
        this.modeButton('\u9a8c\u8bc1\u7801\u767b\u5f55', 0)
        this.modeButton('\u5bc6\u7801\u767b\u5f55', 1)
      }
      .width('100%')
      .height(42)
      .margin({ bottom: 18 })

      Column({ space: 12 }) {
        Row() {
          Text('\u56fd\u5bb6/\u5730\u533a')
            .fontSize(15)
            .fontColor('#191919')
          Blank()
          Text('\u4e2d\u56fd +86 >')
            .fontSize(14)
            .fontColor('rgba(0,0,0,0.6)')
        }
        .width('100%')
        .height(44)

        TextInput({ placeholder: '\u624b\u673a\u53f7', text: this.phone })
          .height(48)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .type(InputType.PhoneNumber)
          .onChange((value: string) => {
            this.phone = value;
          })

        if (this.loginMode === 0) {
          Row() {
            TextInput({ placeholder: '\u77ed\u4fe1\u9a8c\u8bc1\u7801', text: this.code })
              .layoutWeight(1)
              .height(48)
              .backgroundColor(Color.Transparent)
              .showUnderline(true)
              .type(InputType.Number)
              .onChange((value: string) => {
                this.code = value;
              })

            Text('\u83b7\u53d6\u9a8c\u8bc1\u7801')
              .fontColor(this.phone.trim().length === 11 ? '#007DFF' : 'rgba(0,125,255,0.5)')
              .fontSize(14)
              .onClick(() => {
                this.handleSendCode();
              })
              .padding({ left: 10 })
          }
          .width('100%')
          .height(48)
        } else {
          TextInput({ placeholder: '\u5bc6\u7801', text: this.password })
            .height(48)
            .backgroundColor(Color.Transparent)
            .showUnderline(true)
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value;
            })
        }

        if (this.message.length > 0) {
          Text(this.message)
            .fontSize(13)
            .fontColor('#E84026')
            .width('100%')
        }

        Button(this.loading ? '\u5904\u7406\u4e2d' : '\u767b\u5f55')
          .width('100%')
          .height(44)
          .margin({ top: 18 })
          .backgroundColor(this.canSubmit() ? '#007DFF' : 'rgba(0,125,255,0.45)')
          .onClick(() => {
            this.handleLogin();
          })

        Button('\u6ce8\u518c\u8d26\u53f7')
          .width('100%')
          .height(44)
          .fontColor('#007DFF')
          .backgroundColor(Color.White)
          .onClick(() => {
            router.pushUrl({ url: 'pages/RegisterPage' });
          })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding({ left: 24, right: 24, top: 96 })
    .backgroundColor(Color.White)
  }
}