import argparse
import configparser
import requests

def read_token(config_file="~/.pushbullet"):
  """Reads API token from the specified configuration file."""
  config = configparser.ConfigParser()
  try:
    config.read(config_file)
    return config["pushbullet"]["api_token"]
  except (configparser.NoSectionError, configparser.NoOptionError, FileNotFoundError):
    print(f"Error: PUSHBULLET_TOKEN not found in configuration file ({config_file}).")
    exit(1)

def send_notification(message, title="Default Title", api_token=None):
  """Sends a notification using Pushbullet API."""
  if api_token is None:
    api_token = read_token()

  url = "https://api.pushbullet.pushbullet.com/v2/pushes"
  headers = {
      "Authorization": f"Bearer {api_token}",
      "Content-Type": "application/json"
  }
  data = {"body": message, "title": title}
  response = requests.post(url, headers=headers, json=data)

  if response.status_code == 200:
    print("Pushbullet notification sent!")
  else:
    error_message = {
        429: "Error: Pushbullet rate limit exceeded.",
        401: "Error: Invalid Pushbullet API token.",
    }.get(response.status_code, f"Error: Pushbullet notification failed (code: {response.status_code})")
    print(error_message)

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description="Pushbullet notification sender")
  parser.add_argument("-c", "--config", help="Specify config file path (default: ~/.pushbullet)")
  parser.add_argument("-h", "--help", action="help", default=argparse.SUPPRESS, help="Display this help message")
  parser.add_argument("title", nargs="?", help="Notification title (default: Default Title)")
  parser.add_argument("body", nargs="?", help="Notification body (default: Default Body)")
  args = parser.parse_args()

  if args.title and not args.title.isalnum() and not any(char.isspace() for char in args.title):
    print("Error: Invalid title provided.")
    exit(1)

  send_notification(args.body, args.title)
