#!/bin/bash

# Exit on error
set -e

# Install vsftpd
sudo dnf install vsftpd -y

# Enable and start vsftpd service
sudo systemctl enable vsftpd
sudo systemctl start vsftpd

# Update vsftpd main config
sudo tee -a /etc/vsftpd/vsftpd.conf > /dev/null <<EOF
local_enable=YES
write_enable=YES
chroot_local_user=YES
force_dot_files=YES
allow_writeable_chroot=YES
user_config_dir=/etc/vsftpd_user_conf
log_ftp_protocol=YES
xferlog_enable=YES
xferlog_std_format=NO
xferlog_file=/var/log/vsftpd.log
dual_log_enable=YES
file_open_mode=0764
local_umask=002
listen=YES
listen_port=3123
listen_ipv6=NO
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=30009
EOF

# Restart vsftpd service
sudo systemctl restart vsftpd

# Create directory for per-user config
sudo mkdir -p /etc/vsftpd_user_conf

# # Add user config for ftpuser1
# echo "local_root=/var/www" | sudo tee /etc/vsftpd_user_conf/ftpuser1 > /dev/null

# # Create ftp user with no shell access
# sudo useradd -d /home/ftpuser1 -s /sbin/nologin ftpuser1

# # Prompt to set password
# echo "Set password for ftpuser1:"
# sudo passwd ftpuser1

# # Ensure /sbin/nologin is in valid shells list
# grep -qxF /sbin/nologin /etc/shells || echo "/sbin/nologin" | sudo tee -a /etc/shells > /dev/null

# # Add ftpuser1 to nginx group
# sudo usermod -aG nginx ftpuser1

# Install inotify-tools for watching uploads
sudo dnf install inotify-tools -y

# Create ownership fixer script
sudo tee /usr/local/bin/fix_ftp_ownership.sh > /dev/null <<'EOF'
#!/bin/bash
WATCH_DIR="/var/www"
inotifywait -m -r -e create -e moved_to -e close_write "$WATCH_DIR" --format '%w%f' |
while read NEWFILE
do
  chown nginx:nginx "$NEWFILE"
  echo "[FIXED] Ownership set to nginx:nginx for $NEWFILE"
done
EOF

# Make it executable
sudo chmod +x /usr/local/bin/fix_ftp_ownership.sh

# Create systemd service to run the watcher script
sudo tee /etc/systemd/system/fix-ftp-owner.service > /dev/null <<EOF
[Unit]
Description=Auto chown FTP uploads to nginx:nginx
After=network.target

[Service]
ExecStart=/usr/local/bin/fix_ftp_ownership.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reexec
sudo systemctl enable --now fix-ftp-owner.service

# Final vsftpd restart
sudo systemctl restart vsftpd

echo "vsftpd setup and ownership auto-fixer deployed successfully."
