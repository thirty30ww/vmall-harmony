import { router } from '@kit.ArkUI';
import { loginByCode, sendLoginCode } from '../api/authApi';

@Entry
@Component
struct LoginPage {
  @State phone: string = '';
  @State code: string = '';
  @State message: string = '';
  @State loading: boolean = false;

  canSubmit(): boolean {
    return this.phone.trim().length === 11 && this.code.trim().length > 0 && !this.loading;
  }

  async handleSendCode() {
    if (this.phone.trim().length !== 11) {
      this.message = '请输入正确的手机号';
      return;
    }

    this.loading = true;
    this.message = '';
    try {
      await sendLoginCode(this.phone.trim());
      this.message = '验证码已生成，请查看 IDEA 后端控制台';
    } catch (error) {
      this.message = '验证码获取失败：手机号不存在或后端未连接';
    } finally {
      this.loading = false;
    }
  }

  async handleLogin() {
    if (!this.canSubmit()) {
      this.message = '请输入手机号和验证码';
      return;
    }

    this.loading = true;
    this.message = '';
    try {
      const result = await loginByCode(this.phone.trim(), this.code.trim());
      AppStorage.setOrCreate('token', result.token);
      AppStorage.setOrCreate('phone', result.user.phone);
      AppStorage.setOrCreate('username', result.user.username);
      router.replaceUrl({ url: 'pages/HomePage' });
    } catch (error) {
      this.message = '登录失败，请检查验证码';
    } finally {
      this.loading = false;
    }
  }

  build() {
    Column() {
      Column({ space: 8 }) {
        Image($r('app.media.hwlogo'))
          .width(44)
          .height(44)
          .margin({ bottom: 16 })

        Text('华为账号')
          .fontColor('#191919')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)

        Text('登录账号以使用云空间、应用市场及更多服务')
          .fontColor('rgba(0,0,0,0.6)')
          .fontSize(14)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 46 })

      Column({ space: 12 }) {
        Row() {
          Text('国家/地区')
            .fontSize(15)
            .fontColor('#191919')
          Blank()
          Text('中国 +86 >')
            .fontSize(14)
            .fontColor('rgba(0,0,0,0.6)')
        }
        .width('100%')
        .height(44)

        TextInput({ placeholder: '手机号', text: this.phone })
          .height(48)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .type(InputType.PhoneNumber)
          .onChange((value: string) => {
            this.phone = value;
          })

        Row() {
          TextInput({ placeholder: '短信验证码', text: this.code })
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.Transparent)
            .showUnderline(true)
            .type(InputType.Number)
            .onChange((value: string) => {
              this.code = value;
            })

          Text('获取验证码')
            .fontColor(this.phone.trim().length === 11 ? '#007DFF' : 'rgba(0,125,255,0.5)')
            .fontSize(14)
            .onClick(() => {
              this.handleSendCode();
            })
            .padding({ left: 10 })
        }
        .width('100%')
        .height(48)

        if (this.message.length > 0) {
          Text(this.message)
            .fontSize(13)
            .fontColor('#E84026')
            .width('100%')
        }

        Button(this.loading ? '处理中' : '登录')
          .width('100%')
          .height(44)
          .margin({ top: 18 })
          .backgroundColor(this.canSubmit() ? '#007DFF' : 'rgba(0,125,255,0.45)')
          .onClick(() => {
            this.handleLogin();
          })

        Button('注册账号')
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