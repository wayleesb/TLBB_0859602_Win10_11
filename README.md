# TLBB_0859602_Win10_11

TLBB 0859602 client and bundled tools for Windows 10/11.

- `Client/`: client, resources, and 32-bit/64-bit binaries.
- `GM/`: GM tool and configuration.
- `tlbb/`: server, shared data, and startup scripts.
- `TLBB_Env/`: database setup files and environment packages.

## Download

Clone the repository:

```powershell
git clone https://github.com/wayleesb/TLBB_0859602_Win10_11.git
cd TLBB_0859602_Win10_11
```

Download both large files from the
[initial release](https://github.com/wayleesb/TLBB_0859602_Win10_11/releases/tag/initial-import):

- Place the `.exe` asset in the repository root.
- Place `mariadb-10.11.18-winx64.zip` in `TLBB_Env/`.

With GitHub CLI installed, download them directly to those locations:

```powershell
gh release download initial-import --repo wayleesb/TLBB_0859602_Win10_11 --pattern "*.exe" --dir .
gh release download initial-import --repo wayleesb/TLBB_0859602_Win10_11 --pattern "*.zip" --dir TLBB_Env
```

Git LFS is not required. The source archive does not include release assets.
Runtime logs, local backups, and IDA analysis files are excluded.
