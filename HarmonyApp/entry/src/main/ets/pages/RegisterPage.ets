import { router } from '@kit.ArkUI';
import promptAction from '@ohos.promptAction';
import { registerUser, sendRegisterCode } from '../api/authApi';

@Entry
@Component
struct RegisterPage {
  @State username: string = '';
  @State contact: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State code: string = '';
  @State message: string = '';
  @State loading: boolean = false;
  @State sendingCode: boolean = false;

  canSendCode(): boolean {
    return this.contact.trim().length === 11 && !this.sendingCode && !this.loading;
  }

  canRegister(): boolean {
    return this.username.trim().length >= 2
      && this.contact.trim().length === 11
      && this.password.trim().length >= 6
      && this.confirmPassword.trim().length >= 6
      && this.code.trim().length === 6
      && !this.loading;
  }

  showMessage(text: string) {
    this.message = text;
    promptAction.showToast({ message: text, duration: 2000 });
  }

  async handleSendCode() {
    if (!this.canSendCode()) {
      this.showMessage('请输入正确的手机号');
      return;
    }

    this.sendingCode = true;
    this.message = '';
    try {
      await sendRegisterCode(this.contact.trim());
      this.showMessage('验证码已生成，请查看 IDEA 后端控制台');
    } catch (error) {
      this.showMessage('验证码获取失败：手机号可能已注册或后端未连接');
    } finally {
      this.sendingCode = false;
    }
  }

  async handleRegister() {
    if (!this.canRegister()) {
      this.showMessage('请完整填写注册信息');
      return;
    }
    if (this.password !== this.confirmPassword) {
      this.showMessage('密码和确认密码不一致');
      return;
    }

    this.loading = true;
    this.message = '';
    try {
      const result = await registerUser(this.username.trim(), this.contact.trim(), this.password.trim(), this.code.trim());
      AppStorage.setOrCreate('token', result.token);
      AppStorage.setOrCreate('phone', result.user.phone);
      AppStorage.setOrCreate('username', result.user.username);
      promptAction.showToast({ message: '注册成功', duration: 1500 });
      router.replaceUrl({ url: 'pages/HomePage' });
    } catch (error) {
      this.showMessage('注册失败：验证码错误、手机号已注册或后端未连接');
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

        Text('注册账号以使用云空间、应用市场及更多服务')
          .fontColor('rgba(0,0,0,0.6)')
          .fontSize(14)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 42 })

      Column({ space: 12 }) {
        TextInput({ placeholder: '用户名', text: this.username })
          .height(48)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .onChange((value: string) => {
            this.username = value;
          })
          .padding({ top: '12.00vp', right: '16.00vp', bottom: '12.00vp', left: '16.00vp' })

        TextInput({ placeholder: '手机号', text: this.contact })
          .height(48)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .type(InputType.PhoneNumber)
          .onChange((value: string) => {
            this.contact = value;
          })

        Row() {
          TextInput({ placeholder: '验证码', text: this.code })
            .layoutWeight(1)
            .height(48)
            .backgroundColor(Color.Transparent)
            .showUnderline(true)
            .type(InputType.Number)
            .onChange((value: string) => {
              this.code = value;
            })

          Text(this.sendingCode ? '生成中' : '获取验证码')
            .fontSize(14)
            .fontColor(this.canSendCode() ? '#007DFF' : 'rgba(0,125,255,0.5)')
            .padding({ left: 10 })
            .onClick(() => {
              this.handleSendCode();
            })
        }
        .width('100%')
        .height(48)

        TextInput({ placeholder: '密码', text: this.password })
          .height(48)
          .type(InputType.Password)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .onChange((value: string) => {
            this.password = value;
          })

        TextInput({ placeholder: '确认密码', text: this.confirmPassword })
          .height(48)
          .type(InputType.Password)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .onChange((value: string) => {
            this.confirmPassword = value;
          })

        if (this.message.length > 0) {
          Text(this.message)
            .fontSize(13)
            .fontColor('#E84026')
            .width('100%')
        }

        Button(this.loading ? '注册中' : '注册')
          .height(44)
          .width('100%')
          .margin({ top: 18 })
          .enabled(this.canRegister())
          .backgroundColor(this.canRegister() ? '#007DFF' : 'rgba(0,125,255,0.45)')
          .onClick(() => {
            this.handleRegister();
          })

        Button('返回登录')
          .height(44)
          .width('100%')
          .fontColor('#007DFF')
          .backgroundColor(Color.White)
          .onClick(() => {
            router.back();
          })
      }
      .width('100%')
    }
    .height('100%')
    .width('100%')
    .padding({ left: 24, right: 24, top: 72 })
    .backgroundColor(Color.White)
  }
}