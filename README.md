# TLBB_0859602_Win10_11

[中文](#chinese) | [English](#english) | [Tiếng Việt](#vietnamese)

<a id="chinese"></a>

## 中文

适用于 Windows 10/11 的 TLBB 0859602 客户端及配套工具。

### V1.2 更新

- 新增全图跨场景自动寻路、手动坐标输入、任务与活动追踪、自动接受组队跟随及珍兽灵兽丹升级。
- 新增遮挡半透、特效等级、动画更新质量设置，增强 Debug 模式下 `Alt+G` 的 UI 调试信息。
- 修复启动器、客户端交互、暗器与宝石、活动奖励、帮会跑商、装备显示及爆率修改器相关问题。
- 补充金币换交子脚本、`ScriptGlobal_Format` 及任务与活动追踪接口。
- [完整更新说明与接口列表](CHANGELOG.md) · [V1.2 发行页面](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.2)。

### V1.1 更新

- 更新启动工具，整合自 V1.0 以来的客户端、服务端、界面、脚本和场景资源更新。
- 仓库排除 `Client/Accounts/` 全部内容、`Client/Bin/` 和 `Client/Bin64/` 下的 `CEGUI.log`、`Fairy.log`、`Game.log`，以及 `Client/Launch.log`、`Client/Launch.bin`；本地文件保留。
- V1.1 完整发行包排除 Git 元数据、账号缓存和日志，保留运行所需的 `Launch.bin`，并已通过 7-Zip 完整性测试。

版本记录：[V1.1](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.1) · [V1.0](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.0)。

### V0.9 历史更新

- 批量将客户端和服务端文本资源转换为 UTF-8，并更新模型、界面及配置资源。
- 新增八箱仓库界面及配套贴图资源。
- 新增客户端和服务端 `CombatLimits.ini` 战斗属性上限配置；修改时需同步两端配置并重启。
- 新增创建角色和进入游戏的验证码开关，默认关闭。
- 更新 64 位客户端、服务端、GM 工具、启动工具及下载程序。

历史版本：[V0.8 完整更新日志（31 项）](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/0.8)。

### 目录结构

- `Client/`：客户端、资源文件及 32 位 / 64 位程序。
- `GM/`：GM 工具及配置。
- `tlbb/`：服务端、共享数据及启动脚本。
- `TLBB_Env/`：数据库初始化文件及环境安装包。

### 下载

推荐下载 [V1.2 完整包：TLBB_0859602_Win10_11_VER_1.2.7z](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/download/1.2/TLBB_0859602_Win10_11_VER_1.2.7z)，使用 7-Zip 解压。

克隆仓库：

```powershell
git clone https://github.com/wayleesb/TLBB_0859602_Win10_11.git
cd TLBB_0859602_Win10_11
```

也可以通过 GitHub 的 **Code > Download ZIP** 下载当前版本。
仓库已包含 `雪舞天龙启动工具.exe`、完整的 MariaDB 解压目录
`TLBB_Env/mariadb-10.11.18-winx64/` 和 ODBC 安装包，无需 Git LFS。
仓库和 **Code > Download ZIP** 不含 `Client/Launch.bin`；需要完整运行文件时，请下载上述 Release 完整包。
启动工具优先校验并使用 MariaDB 目录，也兼容仅带原 ZIP 的旧整合包。
EXE 使用 .NET 内置单文件压缩，无需手动解压或预装 .NET。
仓库不跟踪运行日志、本地备份及 IDA 分析文件。

### 本地打包

安装 7-Zip 后，双击仓库根目录中的 `一键打包客户端.bat`。
脚本会在仓库目录旁的 `Packages/` 文件夹中生成带时间戳的 `.7z` 压缩包，并在完成后校验完整性。

打包时排除 Git 元数据目录和常见凭据、私钥文件名对应的文件。
本地客户端文件、启动工具、MariaDB 目录、日志和游戏 / 数据库配置会保留在压缩包中；
脚本不使用 `.gitignore` 作为打包排除列表，也不会删除本地文件。

<a id="english"></a>

## English

TLBB 0859602 client and bundled tools for Windows 10/11.

### V1.2 Update

- Adds cross-scene automatic navigation, manual coordinate input, mission and event tracking, automatic acceptance of team-follow requests, and pet leveling with Lingshou Dan.
- Adds occlusion transparency, effect-level and animation-quality settings, and more detailed UI information through `Alt+G` in Debug mode.
- Fixes launcher and client interactions, hidden weapons and gems, event rewards, guild trading, equipment displays, and the drop-rate editor.
- Completes gold-to-Jiaozi scripts and adds `ScriptGlobal_Format` and mission/event tracking interfaces.
- [Full changelog and interface list (Chinese)](CHANGELOG.md) · [V1.2 release](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.2).

### V1.1 Update

- Updates the launcher and includes client, server, interface, script, and scene resource changes since V1.0.
- Excludes all contents of `Client/Accounts/`, `CEGUI.log`, `Fairy.log`, and `Game.log` in `Client/Bin/` and `Client/Bin64/`, plus `Client/Launch.log` and `Client/Launch.bin` from Git tracking; local files are preserved.
- The full V1.1 release package excludes Git metadata, account caches, and logs, retains `Launch.bin` for runtime use, and has passed a 7-Zip integrity test.

Release history: [V1.1](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.1) · [V1.0](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.0).

### V0.9 Previous Updates

- Converts client and server text resources to UTF-8 and updates model, interface, and configuration resources.
- Adds interface and texture resources for the bank with eight storage boxes.
- Adds client and server `CombatLimits.ini` configuration for combat attribute limits; keep both configurations in sync and restart after changes.
- Adds verification-code switches for character creation and entering the game, disabled by default.
- Updates the 64-bit client, server, GM tool, launcher, and downloader.

Previous version: [complete V0.8 changelog (31 entries, in Chinese)](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/0.8).

### Directory Structure

- `Client/`: client, resources, and 32-bit / 64-bit binaries.
- `GM/`: GM tool and configuration.
- `tlbb/`: server, shared data, and startup scripts.
- `TLBB_Env/`: database initialization files and environment packages.

### Download

Recommended: download the [full V1.2 package: TLBB_0859602_Win10_11_VER_1.2.7z](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/download/1.2/TLBB_0859602_Win10_11_VER_1.2.7z) and extract it with 7-Zip.

Clone the repository:

```powershell
git clone https://github.com/wayleesb/TLBB_0859602_Win10_11.git
cd TLBB_0859602_Win10_11
```

You can also download the current version using **Code > Download ZIP** on GitHub.
The repository includes `雪舞天龙启动工具.exe`, the complete expanded MariaDB directory
`TLBB_Env/mariadb-10.11.18-winx64/`, and the ODBC installer. Git LFS is not required.
The repository and **Code > Download ZIP** do not include `Client/Launch.bin`; download the full Release package above for the complete runtime files.
The launcher verifies and uses the MariaDB directory
first, while remaining compatible with older packages containing only the original ZIP.
The EXE uses .NET single-file compression; no manual extraction or .NET installation
is needed. Runtime logs, local backups, and IDA analysis files are not tracked in the repository.

### Package Locally

Install 7-Zip and double-click `一键打包客户端.bat` in the repository root.
The script creates a timestamped `.7z` archive in `Packages/` next to the repository
directory and verifies archive integrity before reporting success.

Git metadata directories and files matching common credential/private-key filenames
are excluded. Local client files, the launcher, the MariaDB directory, logs, and game/database
settings are included in the archive. The script does not use `.gitignore` as its
packaging exclusion list and does not delete local files.

<a id="vietnamese"></a>

## Tiếng Việt

Client TLBB 0859602 và các công cụ đi kèm dành cho Windows 10/11.

### Cập nhật V1.2

- Thêm tự động tìm đường xuyên bản đồ, nhập tọa độ thủ công, theo dõi nhiệm vụ và sự kiện, tự động chấp nhận theo sau tổ đội và nâng cấp trân thú bằng Linh Thú Đan.
- Thêm cài đặt bán trong suốt khi bị che khuất, mức hiệu ứng, chất lượng hoạt ảnh và thông tin UI chi tiết qua `Alt+G` trong chế độ Debug.
- Sửa lỗi trình khởi chạy, thao tác client, ám khí và bảo thạch, phần thưởng sự kiện, bang hội và thương phiếu, hiển thị trang bị và công cụ chỉnh tỷ lệ rơi.
- Bổ sung tập lệnh đổi vàng sang giao tử, `ScriptGlobal_Format` và các giao diện theo dõi nhiệm vụ/sự kiện.
- [Nhật ký đầy đủ và danh sách giao diện (tiếng Trung)](CHANGELOG.md) · [Bản phát hành V1.2](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.2).

### Cập nhật V1.1

- Cập nhật trình khởi chạy và bao gồm các thay đổi của client, máy chủ, giao diện, tập lệnh và tài nguyên cảnh kể từ V1.0.
- Git không theo dõi toàn bộ nội dung `Client/Accounts/`, các tệp `CEGUI.log`, `Fairy.log`, `Game.log` trong `Client/Bin/` và `Client/Bin64/`, cùng với `Client/Launch.log` và `Client/Launch.bin`; các tệp cục bộ vẫn được giữ lại.
- Gói phát hành V1.1 đầy đủ loại trừ siêu dữ liệu Git, bộ nhớ đệm tài khoản và nhật ký, giữ lại `Launch.bin` để chạy trò chơi và đã vượt qua kiểm tra toàn vẹn bằng 7-Zip.

Lịch sử phát hành: [V1.1](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.1) · [V1.0](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/1.0).

### Các cập nhật trước đây của V0.9

- Chuyển hàng loạt tài nguyên văn bản của client và máy chủ sang UTF-8, đồng thời cập nhật tài nguyên mô hình, giao diện và cấu hình.
- Thêm tài nguyên giao diện và hình ảnh cho kho gồm tám rương.
- Thêm cấu hình giới hạn thuộc tính chiến đấu `CombatLimits.ini` cho client và máy chủ; cần đồng bộ hai cấu hình và khởi động lại sau khi thay đổi.
- Thêm tùy chọn bật mã xác minh khi tạo nhân vật và vào game; mặc định tắt.
- Cập nhật client 64 bit, máy chủ, công cụ GM, trình khởi chạy và trình tải xuống.

Phiên bản trước: [nhật ký thay đổi V0.8 đầy đủ (31 mục, bằng tiếng Trung)](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/0.8).

### Cấu trúc thư mục

- `Client/`: client, tài nguyên và các chương trình 32 bit / 64 bit.
- `GM/`: công cụ GM và cấu hình.
- `tlbb/`: máy chủ, dữ liệu dùng chung và các tập lệnh khởi động.
- `TLBB_Env/`: các tệp khởi tạo cơ sở dữ liệu và bộ cài môi trường.

### Tải xuống

Khuyến nghị tải [gói V1.2 đầy đủ: TLBB_0859602_Win10_11_VER_1.2.7z](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/download/1.2/TLBB_0859602_Win10_11_VER_1.2.7z) và giải nén bằng 7-Zip.

Sao chép kho mã về máy:

```powershell
git clone https://github.com/wayleesb/TLBB_0859602_Win10_11.git
cd TLBB_0859602_Win10_11
```

Bạn cũng có thể tải phiên bản hiện tại bằng **Code > Download ZIP** trên GitHub.
Kho mã đã bao gồm `雪舞天龙启动工具.exe`, toàn bộ thư mục MariaDB đã giải nén
`TLBB_Env/mariadb-10.11.18-winx64/` và bộ cài ODBC. Không cần Git LFS.
Kho mã và **Code > Download ZIP** không bao gồm `Client/Launch.bin`; hãy tải gói Release đầy đủ ở trên để có đủ các tệp cần thiết khi chạy.
Trình khởi chạy ưu tiên kiểm tra và sử dụng thư mục MariaDB,
đồng thời vẫn tương thích với các gói cũ chỉ có tệp ZIP gốc.
Tệp EXE sử dụng tính năng nén tệp đơn của .NET; không cần giải nén thủ công hoặc cài đặt .NET.
Nhật ký hoạt động, bản sao lưu cục bộ và các tệp phân tích IDA không được theo dõi trong kho mã.

### Đóng gói trên máy

Cài đặt 7-Zip, sau đó nhấp đúp vào `一键打包客户端.bat` trong thư mục gốc của kho mã.
Tập lệnh tạo tệp nén `.7z` có dấu thời gian trong thư mục `Packages/` nằm cùng cấp
với thư mục kho mã và kiểm tra tính toàn vẹn trước khi thông báo thành công.

Các thư mục siêu dữ liệu Git và các tệp có tên thường dùng để lưu thông tin xác thực
hoặc khóa riêng sẽ bị loại khỏi gói nén. Các tệp client cục bộ, trình khởi chạy, thư mục MariaDB,
nhật ký và cấu hình trò chơi / cơ sở dữ liệu vẫn được đưa vào gói nén.
Tập lệnh không dùng `.gitignore` làm danh sách loại trừ khi đóng gói và không xóa tệp cục bộ.
