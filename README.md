# TLBB_0859602_Win10_11

[中文](#chinese) | [English](#english) | [Tiếng Việt](#vietnamese)

<a id="chinese"></a>

## 中文

适用于 Windows 10/11 的 TLBB 0859602 客户端及配套工具。

### V0.9 更新

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

克隆仓库：

```powershell
git clone https://github.com/wayleesb/TLBB_0859602_Win10_11.git
cd TLBB_0859602_Win10_11
```

也可以通过 GitHub 的 **Code > Download ZIP** 下载当前版本。
仓库已包含 `雪舞天龙启动工具.exe`、完整的 MariaDB 解压目录
`TLBB_Env/mariadb-10.11.18-winx64/` 和 ODBC 安装包，无需 Git LFS 或另外下载 Release 附件。
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

### V0.9 Update

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

Clone the repository:

```powershell
git clone https://github.com/wayleesb/TLBB_0859602_Win10_11.git
cd TLBB_0859602_Win10_11
```

You can also download the current version using **Code > Download ZIP** on GitHub.
The repository includes `雪舞天龙启动工具.exe`, the complete expanded MariaDB directory
`TLBB_Env/mariadb-10.11.18-winx64/`, and the ODBC installer. No Git LFS or separate
release assets are required. The launcher verifies and uses the MariaDB directory
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

### Cập nhật V0.9

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

Sao chép kho mã về máy:

```powershell
git clone https://github.com/wayleesb/TLBB_0859602_Win10_11.git
cd TLBB_0859602_Win10_11
```

Bạn cũng có thể tải phiên bản hiện tại bằng **Code > Download ZIP** trên GitHub.
Kho mã đã bao gồm `雪舞天龙启动工具.exe`, toàn bộ thư mục MariaDB đã giải nén
`TLBB_Env/mariadb-10.11.18-winx64/` và bộ cài ODBC. Không cần Git LFS hay tải riêng
tệp đính kèm bản phát hành. Trình khởi chạy ưu tiên kiểm tra và sử dụng thư mục MariaDB,
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
