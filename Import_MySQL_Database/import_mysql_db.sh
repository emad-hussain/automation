#!/bin/bash

# -----------------------------------------------------------------------------
# Script Name: import_mysql_db.sh
# Description: Imports a MySQL database from a .sql file, supports interactive
#              and non-interactive modes using flags.
#
# Usage (Interactive): ./import_mysql_db.sh
# Usage (Flags): ./import_mysql_db.sh --host localhost --user root --pass secret \
#                --db testdb --file /path/to/file.sql
#
# Options:
#   -h, --help         Display this help message and exit
#   --host             MySQL Host (e.g., localhost)
#   --user             MySQL Username
#   --pass             MySQL Password
#   --db               Database Name
#   --file             Path to SQL File
# -----------------------------------------------------------------------------

# Function to show usage/help
show_usage() {
  echo "Usage: $0 [--host <host>] [--user <username>] [--pass <password>] [--db <database>] [--file <sql_file>]"
  echo
  echo "Interactive mode will prompt you for inputs if no flags are used."
  echo
  echo "Options:"
  echo "  -h, --help           Show this help message"
  echo "  --host               MySQL Host (e.g., localhost)"
  echo "  --user               MySQL Username"
  echo "  --pass               MySQL Password"
  echo "  --db                 Database Name"
  echo "  --file               Path to SQL File"
}

# Parse flags
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -h|--help) show_usage; exit 0 ;;
    --host) DB_HOST="$2"; shift ;;
    --user) DB_USER="$2"; shift ;;
    --pass) DB_PASS="$2"; shift ;;
    --db) DB_NAME="$2"; shift ;;
    --file) SQL_FILE="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; show_usage; exit 1 ;;
  esac
  shift
done

# If any value is missing, prompt interactively
[ -z "$DB_HOST" ] && read -p "Enter MySQL Host (e.g., localhost): " DB_HOST
[ -z "$DB_USER" ] && read -p "Enter MySQL Username: " DB_USER
[ -z "$DB_PASS" ] && read -sp "Enter MySQL Password: " DB_PASS && echo
[ -z "$DB_NAME" ] && read -p "Enter Database Name: " DB_NAME
[ -z "$SQL_FILE" ] && read -p "Enter Path to SQL File (e.g., /path/to/file.sql): " SQL_FILE

# Check if SQL file exists
if [ ! -f "$SQL_FILE" ]; then
  echo "❌ Error: SQL file '$SQL_FILE' does not exist."
  exit 1
fi

# Create the database if it doesn't exist
echo "🔵 Creating database '$DB_NAME' if it doesn't exist..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;"

if [ $? -ne 0 ]; then
  echo "❌ Error: Failed to create or verify database."
  exit 1
fi

# Import the database
echo "🟢 Importing database into '$DB_NAME'..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" < "$SQL_FILE"

# Check if import succeeded
if [ $? -eq 0 ]; then
  echo "✅ Database imported successfully!"
else
  echo "❌ Failed to import the database."
fi
