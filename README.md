# TLBB_0859602_Win10_11

[中文](#chinese) | [English](#english) | [Tiếng Việt](#vietnamese)

<a id="chinese"></a>

## 中文

适用于 Windows 10/11 的 TLBB 0859602 客户端及配套工具。

### V0.8 更新

修复客户端崩溃、网络断开、模型与特效显示、界面缩放、任务及寻路等问题；
修复 GM 工具暗器技能编辑，新增 GM BUFF 2691 / 2692，优化启动工具日志占用并新增“强制停服”。

查看 [V0.8 完整更新日志（31 项）](CHANGELOG.md#v08)。

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

### V0.8 Update

Fixes client crashes, disconnections, model and effect rendering, UI scaling, quests, and pathfinding.
Also fixes hidden-weapon skill editing in the GM tool, adds GM buffs 2691 / 2692,
reduces launcher log disk usage, and adds a force-stop server option.

See the [complete V0.8 changelog (31 entries, in Chinese)](CHANGELOG.md#v08).

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

### Cập nhật V0.8

Sửa lỗi client bị văng, mất kết nối, hiển thị mô hình và hiệu ứng, tỷ lệ giao diện, nhiệm vụ và tìm đường.
Sửa lỗi chỉnh sửa kỹ năng ám khí trong công cụ GM, thêm buff GM 2691 / 2692,
giảm dung lượng nhật ký của trình khởi chạy và thêm tùy chọn buộc dừng máy chủ.

Xem [nhật ký thay đổi V0.8 đầy đủ (31 mục, bằng tiếng Trung)](CHANGELOG.md#v08).

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
