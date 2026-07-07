// 注册页面 —— 用户注册，需填写用户名、手机号、验证码、密码
import { router } from '@kit.ArkUI';
import promptAction from '@ohos.promptAction';
import { registerUser, sendRegisterCode } from '../api/authApi';

@Entry
@Component
struct RegisterPage {
  @State username: string = '';              // 用户名
  @State contact: string = '';               // 手机号
  @State password: string = '';              // 密码
  @State confirmPassword: string = '';       // 确认密码
  @State code: string = '';                  // 验证码
  @State message: string = '';               // 提示消息
  @State loading: boolean = false;           // 注册中
  @State sendingCode: boolean = false;       // 发送验证码中

  // 是否可以发送验证码
  canSendCode(): boolean {
    return this.contact.trim().length === 11 && !this.sendingCode && !this.loading;
  }

  // 是否可以提交注册
  canRegister(): boolean {
    return this.username.trim().length >= 2
      && this.contact.trim().length === 11
      && this.password.trim().length >= 6
      && this.confirmPassword.trim().length >= 6
      && this.code.trim().length === 6
      && !this.loading;
  }

  // 显示提示消息（同时更新状态和弹出 Toast）
  showMessage(text: string) {
    this.message = text;
    promptAction.showToast({ message: text, duration: 2000 });
  }

  // 发送注册验证码
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

  // 执行注册
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

  // ===== 页面主构建 =====
  build() {
    Column() {
      // 顶部 Logo + 标题
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

      // 注册表单
      Column({ space: 12 }) {
        // 用户名
        TextInput({ placeholder: '用户名', text: this.username })
          .height(48)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .onChange((value: string) => {
            this.username = value;
          })
          .padding({ top: '12.00vp', right: '16.00vp', bottom: '12.00vp', left: '16.00vp' })

        // 手机号
        TextInput({ placeholder: '手机号', text: this.contact })
          .height(48)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .type(InputType.PhoneNumber)
          .onChange((value: string) => {
            this.contact = value;
          })

        // 验证码 + 获取验证码按钮
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

        // 密码
        TextInput({ placeholder: '密码', text: this.password })
          .height(48)
          .type(InputType.Password)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .onChange((value: string) => {
            this.password = value;
          })

        // 确认密码
        TextInput({ placeholder: '确认密码', text: this.confirmPassword })
          .height(48)
          .type(InputType.Password)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .onChange((value: string) => {
            this.confirmPassword = value;
          })

        // 错误提示
        if (this.message.length > 0) {
          Text(this.message)
            .fontSize(13)
            .fontColor('#E84026')
            .width('100%')
        }

        // 注册按钮
        Button(this.loading ? '注册中' : '注册')
          .height(44)
          .width('100%')
          .margin({ top: 18 })
          .enabled(this.canRegister())
          .backgroundColor(this.canRegister() ? '#007DFF' : 'rgba(0,125,255,0.45)')
          .onClick(() => {
            this.handleRegister();
          })

        // 返回登录按钮
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
