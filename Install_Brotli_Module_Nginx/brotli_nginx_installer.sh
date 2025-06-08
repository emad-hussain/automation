#!/bin/bash

# Bash script to install Brotli dynamic module for nginx

set -e  # Exit immediately if a command exits with a non-zero status

# Step 1: Install build dependencies
sudo dnf install -y gcc gcc-c++ make zlib-devel pcre-devel openssl-devel wget git brotli brotli-devel

# Step 2: Find your nginx version
NGINX_VERSION=$(nginx -v 2>&1 | grep -o '[0-9.]*')
echo "Detected nginx version: $NGINX_VERSION"

# Step 3: Download nginx source code
cd /usr/local/src/
sudo wget -c http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
sudo tar -zxvf nginx-$NGINX_VERSION.tar.gz

# Step 4: Download Brotli module
cd /usr/local/src/
sudo git clone https://github.com/google/ngx_brotli.git
cd ngx_brotli
sudo git submodule update --init --recursive

# Step 5: Install Brotli libraries and configure linker
echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/local-lib.conf
sudo ldconfig

# Step 6: Build the Brotli dynamic module
cd /usr/local/src/nginx-$NGINX_VERSION
sudo ./configure --with-compat --add-dynamic-module=../ngx_brotli
sudo make modules

# Step 7: Copy modules to nginx modules directory
sudo mkdir -p /etc/nginx/modules
sudo cp objs/ngx_http_brotli_filter_module.so /etc/nginx/modules/
sudo cp objs/ngx_http_brotli_static_module.so /etc/nginx/modules/

# Step 8: Load the modules in nginx.conf
NGINX_CONF="/etc/nginx/nginx.conf"

if ! grep -q "load_module modules/ngx_http_brotli_filter_module.so;" "$NGINX_CONF"; then
    sudo sed -i '1iload_module modules/ngx_http_brotli_filter_module.so;
load_module modules/ngx_http_brotli_static_module.so;' "$NGINX_CONF"
    echo "Modules added to nginx.conf"
else
    echo "Modules already present in nginx.conf"
fi

# Step 9: Test and Reload Nginx
sudo nginx -t && sudo systemctl reload nginx

# Step 10: Remove source files

sudo rm -rf /usr/local/src/nginx-$NGINX_VERSION*
sudo rm -rf /usr/local/src/ngx_brotli

echo "Brotli module installation and configuration complete!"
