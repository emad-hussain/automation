#!/bin/bash

# Usage: ./remove_ftp_user.sh <username>

USER_NAME="$1"

if [ -z "$USER_NAME" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Remove user from nginx group
sudo gpasswd -d "$USER_NAME" nginx

# Remove user and their home directory (optional: remove -r flag to retain home)
sudo userdel -r "$USER_NAME"

# Remove vsftpd per-user config
sudo rm -f "/etc/vsftpd_user_conf/$USER_NAME"

echo "✅ FTP user '$USER_NAME' and related configuration removed."
