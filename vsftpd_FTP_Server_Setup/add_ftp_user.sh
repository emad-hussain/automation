#!/bin/bash

# Usage: ./add_ftp_user.sh <username> [password]
USER_NAME="$1"
USER_PASS="$2"
FTP_ROOT="/var/www"
VSFTPD_USER_CONF_DIR="/etc/vsftpd_user_conf"

if [ -z "$USER_NAME" ]; then
  echo "Usage: $0 <username> [password]"
  exit 1
fi

# Create user with no login shell
sudo useradd -d /home/$USER_NAME -s /sbin/nologin "$USER_NAME"

# Use provided password or generate random one
if [ -n "$USER_PASS" ]; then
  PASSWORD="$USER_PASS"
else
  PASSWORD=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | head -c9)
fi

# Set the password
echo "$USER_NAME:$PASSWORD" | sudo chpasswd

# Show the password
echo "🔐 Password for $USER_NAME: $PASSWORD"

# Ensure /sbin/nologin is in /etc/shells
grep -qxF /sbin/nologin /etc/shells || echo "/sbin/nologin" | sudo tee -a /etc/shells

# Create vsftpd per-user config directory if it doesn't exist
sudo mkdir -p "$VSFTPD_USER_CONF_DIR"

# Set FTP root for the user
echo "local_root=$FTP_ROOT" | sudo tee "$VSFTPD_USER_CONF_DIR/$USER_NAME" > /dev/null

# Add to nginx group (optional for chown compatibility)
sudo usermod -aG nginx "$USER_NAME"

echo "✅ FTP user '$USER_NAME' configured with directory '$FTP_ROOT'."