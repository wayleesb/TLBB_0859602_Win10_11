# TLBB_0859602_Win10_11

[中文](#chinese) | [English](#english) | [Tiếng Việt](#vietnamese)

<a id="chinese"></a>

## 中文

适用于 Windows 10/11 的 TLBB 0859602 客户端及配套工具。

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

MariaDB 安装包 `TLBB_Env/mariadb-10.11.18-winx64.zip` 已包含在仓库中。
从 [Release 页面](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/initial-import) 下载启动程序：

- 将 `TLBB_Launcher.exe` 放到仓库根目录，并重命名为 `雪舞天龙启动工具.exe`。

已安装 GitHub CLI 的用户，也可以在仓库根目录执行：

```powershell
gh release download initial-import --repo wayleesb/TLBB_0859602_Win10_11 --pattern "*.exe" --dir .
Rename-Item -LiteralPath TLBB_Launcher.exe -NewName '雪舞天龙启动工具.exe'
```

无需 Git LFS。GitHub 自动生成的源码压缩包不包含启动程序，需要单独下载。
仓库不跟踪运行日志、本地备份及 IDA 分析文件。

### 本地打包

安装 7-Zip 后，双击仓库根目录中的 `一键打包客户端.bat`。
脚本会在仓库目录旁的 `Packages/` 文件夹中生成带时间戳的 `.7z` 压缩包，并在完成后校验完整性。

打包时排除 Git 元数据目录和常见凭据、私钥文件名对应的文件。
本地客户端文件、已下载的 Release 附件、日志和游戏 / 数据库配置会保留在压缩包中；
脚本不使用 `.gitignore` 作为打包排除列表，也不会删除本地文件。

<a id="english"></a>

## English

TLBB 0859602 client and bundled tools for Windows 10/11.

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

The MariaDB package `TLBB_Env/mariadb-10.11.18-winx64.zip` is included in the repository.
Download the launcher from the [release page](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/initial-import):

- Place `TLBB_Launcher.exe` in the repository root and rename it to `雪舞天龙启动工具.exe`.

With GitHub CLI installed, you can also run these commands from the repository root:

```powershell
gh release download initial-import --repo wayleesb/TLBB_0859602_Win10_11 --pattern "*.exe" --dir .
Rename-Item -LiteralPath TLBB_Launcher.exe -NewName '雪舞天龙启动工具.exe'
```

Git LFS is not required. GitHub's automatically generated source archives do not include
the launcher; download it separately. Runtime logs, local backups, and IDA
analysis files are not tracked in the repository.

### Package Locally

Install 7-Zip and double-click `一键打包客户端.bat` in the repository root.
The script creates a timestamped `.7z` archive in `Packages/` next to the repository
directory and verifies archive integrity before reporting success.

Git metadata directories and files matching common credential/private-key filenames
are excluded. Local client files, downloaded release assets, logs, and game/database
settings are included in the archive. The script does not use `.gitignore` as its
packaging exclusion list and does not delete local files.

<a id="vietnamese"></a>

## Tiếng Việt

Client TLBB 0859602 và các công cụ đi kèm dành cho Windows 10/11.

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

Gói MariaDB `TLBB_Env/mariadb-10.11.18-winx64.zip` đã có sẵn trong kho mã.
Tải trình khởi chạy từ [trang phát hành](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/initial-import):

- Đặt `TLBB_Launcher.exe` vào thư mục gốc của kho mã và đổi tên thành `雪舞天龙启动工具.exe`.

Nếu đã cài GitHub CLI, bạn cũng có thể chạy các lệnh sau tại thư mục gốc của kho mã:

```powershell
gh release download initial-import --repo wayleesb/TLBB_0859602_Win10_11 --pattern "*.exe" --dir .
Rename-Item -LiteralPath TLBB_Launcher.exe -NewName '雪舞天龙启动工具.exe'
```

Không cần Git LFS. Các gói mã nguồn do GitHub tự động tạo không bao gồm trình khởi chạy;
bạn cần tải riêng. Nhật ký hoạt động, bản sao lưu cục bộ
và các tệp phân tích IDA không được theo dõi trong kho mã.

### Đóng gói trên máy

Cài đặt 7-Zip, sau đó nhấp đúp vào `一键打包客户端.bat` trong thư mục gốc của kho mã.
Tập lệnh tạo tệp nén `.7z` có dấu thời gian trong thư mục `Packages/` nằm cùng cấp
với thư mục kho mã và kiểm tra tính toàn vẹn trước khi thông báo thành công.

Các thư mục siêu dữ liệu Git và các tệp có tên thường dùng để lưu thông tin xác thực
hoặc khóa riêng sẽ bị loại khỏi gói nén. Các tệp client cục bộ, tệp đính kèm bản phát hành
đã tải xuống, nhật ký và cấu hình trò chơi / cơ sở dữ liệu vẫn được đưa vào gói nén.
Tập lệnh không dùng `.gitignore` làm danh sách loại trừ khi đóng gói và không xóa tệp cục bộ.
