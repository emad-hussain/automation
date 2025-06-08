# 📦 brotli_nginx_installer.sh

## Overview
`brotli_nginx_installer.sh` is an automated Bash script that **installs the Brotli compression module** for an existing Nginx installation.  
It covers **installation, building, and configuration** of the Brotli dynamic module in one go.

---

## ✨ Features
- Detects your currently installed Nginx version automatically.
- Downloads and compiles the Brotli module without touching existing Nginx installation.
- Dynamically builds and installs Brotli as a loadable module.
- Automatically edits `nginx.conf` to load Brotli modules.
- Verifies Brotli activation after installation.
- Clean, idempotent, and production-safe process.

---

## Usage

### Run the Script

```bash
./brotli_nginx_installer.sh
```

You will see:
- Dependencies installation
- Nginx source download
- Brotli module download and build
- Module loading into nginx.conf
- Verification steps

---

## 🔢 Steps Performed

1. Install required build dependencies.
2. Detect your installed Nginx version.
3. Download the corresponding Nginx source code.
4. Clone the Brotli module from GitHub.
5. Configure linker paths for Brotli libraries.
6. Build only the dynamic modules, not the full Nginx.
7. Copy the built `.so` files to `/etc/nginx/modules`.
8. Insert `load_module` directives automatically in `nginx.conf`.
9. Test and reload Nginx.
10. Remove the source files from `/usr/local/src` directory.
11. Enable the brotli compression in virtual host (manual)
    ```bash
    # Enable Brotli compression for better performance than gzip (if supported by client)
    brotli on;
    brotli_comp_level 5; # Set Brotli compression level (1-11, 5 is balanced)
    brotli_static on; # Serve pre-compressed .br versions if available
    brotli_types
        text/plain
        text/css
        text/xml
        application/json
        application/javascript
        image/svg+xml
        application/font-woff2; # Define the MIME types to compress with Brotli
    ```
12. Verify Brotli compression using `curl`.
    ```bash
    curl -H "Accept-Encoding: br" -I https://yourdomain.com
    ```

---

## Requirements
- **Nginx** must already be installed.
- **dnf/yum** package manager (tested on RHEL 9 / CentOS 9).
- Sudo privileges.

---

## Notes
- This script does **NOT** overwrite your existing Nginx binary.
- Dynamic modules ensure that you don't need to recompile Nginx.
- If Nginx is upgraded, you must rebuild the module again.
- Make sure your firewall or security policies allow outbound traffic to GitHub and nginx.org.

---

## Output Example

```bash
Detected nginx version: 1.28.0
Downloading nginx source code...
Cloning Brotli module...
Building dynamic modules...
Modules added to nginx.conf
Testing Nginx configuration: successful
Reloading Nginx: successful
Verifying Brotli activation...
HTTP/2 200 
content-encoding: br
Brotli module installation and configuration complete!
```

---

## Exit Codes

| Code | Meaning |
|:----:|:--------|
| `0`  | Success |
| `1`  | Error (e.g., build failure, nginx reload failure) |

---

## 📜 License
This script is free to use and modify under your own terms.

---

## 🏷️ Badges

![Shell Script](https://img.shields.io/badge/script-bash-green.svg)
![Nginx](https://img.shields.io/badge/server-Nginx-blue.svg)
![Brotli](https://img.shields.io/badge/compression-Brotli-brightgreen.svg)

---

## ✍️ Author
Crafted with ❤️ by Emad Hussain @ Mecarvi Technologies  
Feel free to improve and contribute!
