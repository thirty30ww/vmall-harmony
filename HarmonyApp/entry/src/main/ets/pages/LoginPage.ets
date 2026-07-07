// 登录页面 —— 支持验证码登录和密码登录两种方式
import { router } from '@kit.ArkUI';
import { loginByCode, loginByPassword, LoginResult, sendLoginCode } from '../api/authApi';

@Entry
@Component
struct LoginPage {
  @State phone: string = '';          // 手机号
  @State code: string = '';           // 验证码
  @State password: string = '';       // 密码
  @State message: string = '';        // 提示消息
  @State loading: boolean = false;    // 加载状态
  @State loginMode: number = 0;       // 登录模式：0=验证码登录，1=密码登录

  // 判断是否可以提交登录
  canSubmit(): boolean {
    if (this.phone.trim().length !== 11 || this.loading) {
      return false;
    }
    if (this.loginMode === 0) {
      return this.code.trim().length > 0;
    }
    return this.password.trim().length > 0;
  }

  // 保存登录结果到全局存储
  saveLoginResult(result: LoginResult) {
    AppStorage.setOrCreate('token', result.token);
    AppStorage.setOrCreate('phone', result.user.phone);
    AppStorage.setOrCreate('username', result.user.username);
  }

  // 发送验证码
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

  // 执行登录
  async handleLogin() {
    if (!this.canSubmit()) {
      this.message = this.loginMode === 0
        ? '请输入手机号和验证码'
        : '请输入手机号和密码';
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
        ? '登录失败，请检查验证码'
        : '登录失败，请检查手机号或密码';
    } finally {
      this.loading = false;
    }
  }

  // ===== 登录模式切换按钮 Builder =====
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
          .textAlign(TextAlign.Center)
          .width('100%')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)

        Text('登录账号以使用云空间、应用市场及更多服务')
          .fontColor('rgba(0,0,0,0.6)')
          .textAlign(TextAlign.Center)
          .width('100%')
          .fontSize(14)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Center)
      .margin({ bottom: 32 })

      // 登录模式切换（验证码登录 / 密码登录）
      Row() {
        this.modeButton('验证码登录', 0)
        this.modeButton('密码登录', 1)
      }
      .width('100%')
      .height(42)
      .margin({ bottom: 18 })

      // 登录表单
      Column({ space: 12 }) {
        // 国家/地区选择
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

        // 手机号输入
        TextInput({ placeholder: '手机号', text: this.phone })
          .height(48)
          .backgroundColor(Color.Transparent)
          .showUnderline(true)
          .type(InputType.PhoneNumber)
          .onChange((value: string) => {
            this.phone = value;
          })

        // 验证码登录：验证码输入 + 获取验证码按钮
        if (this.loginMode === 0) {
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
        } else {
          // 密码登录：密码输入
          TextInput({ placeholder: '密码', text: this.password })
            .height(48)
            .backgroundColor(Color.Transparent)
            .showUnderline(true)
            .type(InputType.Password)
            .onChange((value: string) => {
              this.password = value;
            })
        }

        // 错误提示消息
        if (this.message.length > 0) {
          Text(this.message)
            .fontSize(13)
            .fontColor('#E84026')
            .width('100%')
        }

        // 登录按钮
        Button(this.loading ? '处理中' : '登录')
          .width('100%')
          .height(44)
          .margin({ top: 18 })
          .backgroundColor(this.canSubmit() ? '#007DFF' : 'rgba(0,125,255,0.45)')
          .onClick(() => {
            this.handleLogin();
          })

        // 注册账号按钮
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
