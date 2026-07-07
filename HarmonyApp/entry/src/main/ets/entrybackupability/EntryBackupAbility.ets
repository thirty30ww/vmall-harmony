// 备份恢复扩展 Ability —— 支持应用数据备份与恢复
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BackupExtensionAbility, BundleVersion } from '@kit.CoreFileKit';

const DOMAIN = 0x0000;

export default class EntryBackupAbility extends BackupExtensionAbility {
  // 备份回调
  async onBackup() {
    hilog.info(DOMAIN, 'testTag', '备份成功');
    await Promise.resolve();
  }

  // 恢复回调
  async onRestore(bundleVersion: BundleVersion) {
    hilog.info(DOMAIN, 'testTag', '恢复成功 %{public}s', JSON.stringify(bundleVersion));
    await Promise.resolve();
  }
}