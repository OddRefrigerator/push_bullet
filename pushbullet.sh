#!/bin/bash

# Help message
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
  echo "Usage: $0 [TITLE] [BODY]"
  echo "  -h, --help   Display this help message"
  echo "  -c FILE       Specify config file path (default: ~/.pushbullet)"
  exit 0
fi

# Config file handling
CONFIG_FILE="~/.pushbullet"
while getopts ":c:" opt; do
  case $opt in
    c) CONFIG_FILE="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND-1))  # Remove processed options from arguments

# Function to read API token from config file
read_token() {
  if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"  # Read token from config file
  fi
  if [ -z "$PUSHBULLET_TOKEN" ]; then
    send_notification "Error: PUSHBULLET_TOKEN not found in configuration file ($CONFIG_FILE)."
    exit 1
  fi
}

# Function to send notification 
send_notification() {
  local message="$1"
  local status_code=$(curl -X POST -s -w "%{http_code}" https://api.pushbullet.pushbullet.com/v2/pushes \
    -H "Authorization: Bearer $PUSHBULLET_TOKEN" \
    -H "Content-Type: application/json" \
    -d "{\"body\":\"$BODY\", \"title\":\"$TITLE\"}")

  if [ $status_code -eq 200 ]; then
    echo "Pushbullet notification sent!"
  else
    case $status_code in
      429) echo "Error: Pushbullet rate limit exceeded." ;;
      401) echo "Error: Invalid Pushbullet API token." ;;
      *) echo "Error: Pushbullet notification failed (code: $status_code)" ;;
    esac
  fi
}

# Read token and handle errors
read_token

# Get notification arguments with defaults
TITLE="${1:-'Default Title'}"

# Validate title (optional)
if [[ -z "$TITLE" || "$TITLE" =~ [^[:alnum:][:space:]] ]]; then
  send_notification "Error: Invalid title provided."
  exit 1
fi

BODY="${2:-'Default Body'}"

# Send notification
send_notification
