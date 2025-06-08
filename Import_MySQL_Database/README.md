# 📦 import_mysql_db.sh

## Overview
`import_mysql_db.sh` is a simple and interactive Bash script that **imports a MySQL database** from a `.sql` file.  
It supports both **interactive prompts** and **non-interactive usage** via command-line flags.

---

## ✨ Features
- Prompt-driven user input for database import (interactive mode).
- Accepts command-line flags for automation (non-interactive mode).
- Automatically creates the database if it does not exist.
- Simple success/error feedback.
- Hidden password input for security.
- Basic error handling.

---

## Usage

### Interactive Mode

```bash
./import_mysql_db.sh
```

You will be prompted to enter:
- MySQL Host (e.g., `localhost`)
- MySQL Username
- MySQL Password (input hidden)
- Database Name
- Path to the SQL File (e.g., `/path/to/yourfile.sql`)

### Non-Interactive Mode (Flags)

```bash
./import_mysql_db.sh --host localhost --user root --pass yourpassword --db testdb --file /path/to/file.sql
```

---

## Options

| Option | Description |
|:------:|:------------|
| `-h`, `--help` | Display help message and exit |
| `--host` | MySQL Host (e.g., localhost) |
| `--user` | MySQL Username |
| `--pass` | MySQL Password |
| `--db` | Database Name |
| `--file` | Path to the SQL file to import |

---

## Example (Interactive)

```bash
$ ./import_mysql_db.sh
Enter MySQL Host (e.g., localhost): localhost
Enter MySQL Username: root
Enter MySQL Password: 
Enter Database Name: testdb
Enter Path to SQL File (e.g., /path/to/file.sql): /home/user/backup.sql

🔵 Creating database 'testdb' if it doesn't exist...
🟢 Importing database into 'testdb'...
✅ Database imported successfully!
```

## Example (Non-Interactive)

```bash
$ ./import_mysql_db.sh --host localhost --user root --pass mypassword --db mydb --file /home/user/backup.sql

🔵 Creating database 'mydb' if it doesn't exist...
🟢 Importing database into 'mydb'...
✅ Database imported successfully!
```

---

## Requirements
- **MySQL Client Tools** (`mysql`) must be installed and accessible in the system PATH.
- User must have privileges to **create databases** and **import data**.

---

## Notes
- The SQL file must exist and be accessible at the provided path.
- The password prompt hides the input for better security if using interactive mode.
- Database creation is **idempotent** (won't fail if the DB already exists).

---

## Exit Codes

| Code | Meaning |
|:----:|:--------|
| `0`  | Success |
| `1`  | Error (e.g., SQL file not found, database creation/import failed) |

---

## 📜 License
This script is free to use and modify under your own terms.

---

## 🏷️ Badges

![Shell Script](https://img.shields.io/badge/script-bash-green.svg)
![MySQL](https://img.shields.io/badge/database-MySQL-blue.svg)

---

## ✍️ Author
Crafted with ❤️ by Emad Hussain @ Mecarvi Technologies  
Feel free to improve and contribute!
