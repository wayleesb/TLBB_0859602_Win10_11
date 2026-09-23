# TLBB_0859602_Win10_11_VER_1.2

适用于 Windows 10/11。本次发布包含客户端、服务端、游戏资源及配套工具的完整更新。

## 完整包下载

- **文件名：** `TLBB_0859602_Win10_11_VER_1.2.7z`
- **下载：** [V1.2 完整包](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/download/1.2/TLBB_0859602_Win10_11_VER_1.2.7z)
- **使用：** 使用 7-Zip 解压完整包。
- **内容：** 客户端、服务端、GM 工具、启动工具、综合工具及 MariaDB 运行环境；保留运行所需的 `Client/Launch.bin`，排除 Git 元数据、账号缓存、运行日志、本地备份及分析文件。

## 一、新增功能

- **全图自动寻路：** 支持跨场景传送。
- **坐标寻路：** 自动寻路界面支持手动输入坐标。
- **任务与活动追踪：** 新增任务、活动追踪功能，并补充对应的数据接口、界面联动及背景设置。
- **组队跟随：** `Server.exe` 新增自动接受组队跟随功能。
- **珍兽升级：** 开放使用灵兽丹升级珍兽的功能。
- **显示设置：** 新增遮挡半透、特效等级及动画更新质量设置。
- **调试信息：** Debug 模式下使用 `Alt+G`，可显示更详细的 UI 信息。

## 二、启动器与客户端修复

- 修复连续打开两次 `Launch.exe` 时弹出报错提示的问题。
- 修复安装目录包含中文时，无法启动 `Launch.exe` 登录器的问题。
- 修复按 `Esc` 时概率误触发“系统选项”的问题。
- 修复打开包裹后，距离过远仍不会自动关闭的问题。
- 修复提交任务后，角色缺少发光特效和音效的问题。
- 修复退出打坐后 Buff 不消失的问题。
- 修复表情图标漂移的问题。
- 修复关闭客户端时出现以下 Lua 报错的问题：

```text
[string "setmetatable(_G, {__index = });"]:1: unexpected symbol near `}'
```

## 三、暗器、宝石与装备修复

- 修复暗器镶嵌宝石公告出现 `<ERRTRANS>` 的问题。
- 修复暗器重洗类功能无效的问题。
- 修复暗器强化、打孔按修炼等级计算引发的等级及材料判定异常；修复客户端显示需要“地煞”、实际却提示需要“天罡”，导致无法强化的问题。
- 修复资质说明仅显示“外攻资质 完美 +60%”等文字、缺少具体数值的问题。
- 修复少林门派套装“摩柯云铁手”未显示套装属性的问题。

### 宝石命令调整

镶嵌宝石命令增加材料位置参数：

```text
!!use_gem pos1=100 pos2=0 mat1=2
```

修复宝石合成命令：

```text
!!combound_gem gempos1=100 gempos2=101 gempos3=102 gempos4=-1 gempos5=-1 matpos=0
```

## 四、活动、道具与寻路优化

- 修复点击“领取活动奖励”后，再使用背包中的药品、双倍丹等道具，屏幕中央持续提示“您正在抽奖或兑换元宝中，不能传送”的问题。
- 修复“幸运快活三”抽奖界面状态重置后，动画定时回调可能访问无效牌号并触发 Lua 报错的问题。
- 修复征友投票者跨页菜单与无效索引返回的问题。
- 藏宝图和惩恶令支持点击坐标自动寻路。
- 藏宝图悬浮窗支持显示坐标。
- 元宝商店“珍兽百宝箱”新增灵兽丹。
- 慕容复新增掉落“寒冰星屑”。

## 五、帮会与跑商修复

- 修复使用商票购买商品后，客户端不显示物品的问题。
- 修复帮会等级丢失导致显示“规模无、商票 0”的问题。
- 修复城市商店无法通过右键出售跑商物品的问题。
- 商票栏由“每日总上限”调整为“剩余次数/总上限”。

## 六、服务端脚本与工具

- 补全服务端缺失的金币换交子脚本及相关接口：`LuaFnDoMoneyToJZ`、`DataPool::ScriptPlus`。
- 新增服务端函数：`ScriptGlobal_Format`。
- 修复爆率修改器中，不存在的异常包裹无法删除的问题。

## 七、任务与活动追踪接口

### DataPool

```text
DataPool::GetPlayerMissionTrackType
DataPool::GetLuaMissionTrackInfo
DataPool::GetDeliveryMissionTrackInfo
DataPool::GetHusongMissionTrackInfo
DataPool::GetMissionFinishInfo
DataPool::GetKillMonsterMissionTrackInfo_num
DataPool::GetKillMonsterMissionTrackInfo_MonsterInfo
DataPool::GetLootItemMissionTrackInfo_num
DataPool::GetLootItemMissionTrackInfo_ItemInfo
DataPool::GetMissionShortName
DataPool::IsMissionTrackOpen
DataPool::SetMissionTrackOpen
DataPool::IsCampaignTrackOpen
DataPool::SetCampaignTrackOpen
DataPool::IsCampaignCanTrack
DataPool::IsTrackFuncShow
DataPool::SetTrackFuncShow
DataPool::HaveMisstionTrackThisType
DataPool::HandleGameSetupAction
DataPool::CampaignTrackGotoCampaignList
DataPool::MissionTrackGotoQuestLog
DataPool::UpdateTrackStateButton
DataPool::UpdateMissionTrack
DataPool::UpdateCampaignTrack
DataPool::UpdateQuestLogByTrack
DataPool::UpdateCampaignListByTrack
```

### SystemSetup

```text
SystemSetup::Set_TrackBackground
SystemSetup::ApplyTrackBackground
```

### CVariableSystem

```text
CVariableSystem::GetTrackVariable
CVariableSystem::SetTrackVariable
```
