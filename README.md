Pushbullet Notification Script

This Bash script offers a convenient way to send notifications to your Pushbullet devices directly from your command line.

Features:

Configurability: Specify the Pushbullet API token either in a configuration file (~/.pushbullet by default) or as a command-line argument using the -c option.

Help Message: Get usage instructions and information about available options with -h or --help.

Error Handling: The script checks for various potential issues, including:
Missing or invalid Pushbullet API token
Invalid title format (optional validation)
HTTP errors returned by the Pushbullet API (rate limit exceeded, authentication failure, etc.)

Default Values: If no title or body is provided, the script uses sensible defaults ("Default Title" and "Default Body").
Usage:

Bash
# Send a notification with default title and body:
./pushbullet_notification.sh

# Send a notification with custom title and body:
./pushbullet_notification.sh "My Custom Title" "This is the message content."

# Specify a different config file path:
./pushbullet_notification.sh -c /path/to/your/config.file

Use code with caution.

Installation:
Save the script as a file (e.g., pushbullet_notification.sh).
Make the script executable: chmod +x pushbullet_notification.sh.
(Optional) Create a configuration file (~/.pushbullet) containing your Pushbullet API token on a single line: PUSHBULLET_TOKEN="your_api_token".

Important:
Replace your_api_token with your actual Pushbullet API token obtained from your account settings.
For enhanced security, consider storing the API token in a password manager or encrypting the configuration file.
I hope this summary provides all the necessary information for users to effectively utilize this script!