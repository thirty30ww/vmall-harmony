// 应用入口 Ability —— 负责应用生命周期管理和主窗口创建
import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  // Ability 创建时调用，设置颜色模式
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', '设置颜色模式失败: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 创建');
  }

  // Ability 销毁时调用
  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 销毁');
  }

  // 主窗口创建时调用，加载首页（登录页）
  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 主窗口创建');

    windowStage.loadContent('pages/LoginPage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', '加载页面失败: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', '页面加载成功');
    });
  }

  // 主窗口销毁时调用
  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 主窗口销毁');
  }

  // 应用切换到前台时调用
  onForeground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 进入前台');
  }

  // 应用切换到后台时调用
  onBackground(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 进入后台');
  }
}