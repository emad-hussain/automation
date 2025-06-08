
# 📁 vsftpd FTP Server Setup with Auto-Chown Script

This script automates the installation and configuration of `vsftpd` on CentOS 9, including user setup, file ownership correction using `inotify`, and custom port and permissions setup.

## 🔧 What It Does

- Installs `vsftpd` and enables the service.
- Configures:
  - Writable local users
  - Chroot jailing
  - Per-user root directories
  - Logging options
  - Custom umask and file permissions
  - Custom listening port (`3123`)
- Creates an FTP user `ftpuser1` with no shell access.
- Adds `ftpuser1` to `nginx` group.
- Installs `inotify-tools` to monitor uploads.
- Creates a daemon that fixes ownership of uploaded files to `nginx:nginx`.

## 🛠️ Requirements

- OS: CentOS 9 or RHEL 9
- User must have `sudo` privileges

## 🏃‍♂️ How to Use

1. Save the script as `setup_vsftpd.sh`.
2. Make it executable:

   ```bash
   chmod +x setup_vsftpd.sh
   ```

3. Run it:

   ```bash
   ./setup_vsftpd.sh
   ```

4. You will be prompted to set a password for `ftpuser1`.

## 📂 Folder Structure

```
/etc/vsftpd_user_conf/
└── ftpuser1          # Specifies custom root directory for this user

/usr/local/bin/
└── fix_ftp_ownership.sh    # Watches and fixes file ownerships

/etc/systemd/system/
└── fix-ftp-owner.service   # Systemd unit to run the watcher as a service
```

## ⚙️ Key Configuration Highlights

### `/etc/vsftpd/vsftpd.conf` (snippets)

```conf
local_enable=YES
write_enable=YES
chroot_local_user=YES
force_dot_files=YES
allow_writeable_chroot=YES
user_config_dir=/etc/vsftpd_user_conf
log_ftp_protocol=YES
xferlog_enable=YES
file_open_mode=0764
local_umask=002
listen=YES
listen_port=3123
listen_ipv6=NO
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30009
```

### `/etc/vsftpd_user_conf/ftpuser1`

```conf
local_root=/var/www
```

## 🔄 Auto Ownership Fixer

The script `/usr/local/bin/fix_ftp_ownership.sh` runs as a background service using `systemd` and automatically:

- Watches `/var/www`
- Changes ownership of newly created/modified files to `nginx:nginx`
- Logs the action for each file

## ✅ Post-Setup Checklist

- Confirm `vsftpd` is running:

  ```bash
  sudo systemctl status vsftpd
  ```

- Confirm watcher service is active:

  ```bash
  sudo systemctl status fix-ftp-owner.service
  ```

- Test FTP connection to port `3123`
- Verify uploaded file ownership under `/var/www`

---

## ➕ Adding New FTP Users (Future Use)

You can use the script included: `add_ftp_user.sh`

### 📝 Syntax

```bash
sudo bash add_ftp_user.sh <username>
```

### 📌 Example

```bash
sudo bash add_ftp_user.sh ftpuser2
```

This will:
- Create a user with `/sbin/nologin` shell and no home directory
- Generates a random password for new user
- Configure `/etc/vsftpd_user_conf/<username>` with `local_root`
- Provide the user access to `/var/www` directory 
- Add user to the `nginx` group for compatibility with the auto-chown service

Ensure you restart `vsftpd` if changes to the global config are made:

```bash
sudo systemctl restart vsftpd
```

---

## ❌ Remove FTP Users (Using `remove_ftp_user.sh`)

To safely remove a user added via `add_ftp_user.sh`, use the companion removal script.

### 📝 Syntax

```bash
sudo bash remove_ftp_user.sh <username>
```

### 📌 Example

```bash
sudo bash remove_ftp_user.sh ftpuser2
```

This will:
- Remove the user and their home directory
- Remove the user from `nginx` group
- Remove the `vsftp` configuration file `/etc/vsftpd_user_conf/<username>` with `local_root`

Ensure you restart `vsftpd` if changes to the global config are made:

```bash
sudo systemctl restart vsftpd
```

---

## 📜 License
This script is free to use and modify under your own terms.

---

## 🏷️ Badges

![Shell Script](https://img.shields.io/badge/script-bash-green.svg)
![vsftpd](https://img.shields.io/badge/service-vsftpd-blue.svg)

---

## ✍️ Author
Crafted with ❤️ by Emad Hussain @ Mecarvi Technologies  
Feel free to improve and contribute!
