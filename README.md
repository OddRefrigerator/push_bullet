# Push Bullet

Push Bullet is a simple application that allows you to send notifications and messages to your devices using the Pushbullet API. This tool is designed for developers who want to integrate Pushbullet notifications into their applications or automate notification delivery.

## Features

- **Send Notifications:** Easily send notifications to any device linked to your Pushbullet account.
- **Customizable Messages:** Tailor your notifications with custom titles, messages, and more.
- **Multi-Platform Support:** Works across different operating systems and devices.
- **Easy Integration:** Simple API to integrate into your existing applications or scripts.

## Requirements

- Python 3.x
- A valid Pushbullet account and API key.

## Installation

To install Push Bullet, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/OddRefrigerator/push_bullet.git
   cd push_bullet
   ```

2. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

To send a notification using Push Bullet, you can use the following example script:

```python
import requests

API_KEY = 'YOUR_PUSHBULLET_API_KEY'
DEVICE_IDENTIFIER = 'YOUR_DEVICE_IDENTIFIER'

def send_notification(title, message):
    url = 'https://api.pushbullet.com/v2/pushes'
    headers = {
        'Access-Token': API_KEY,
        'Content-Type': 'application/json'
    }
    data = {
        'type': 'note',
        'title': title,
        'body': message,
        'device_iden': DEVICE_IDENTIFIER
    }
    response = requests.post(url, headers=headers, json=data)
    return response.json()

# Example usage
response = send_notification('Hello!', 'This is a test notification.')
print(response)
```

Replace `YOUR_PUSHBULLET_API_KEY` and `YOUR_DEVICE_IDENTIFIER` with your actual Pushbullet API key and device identifier.

## API Reference

For more information about the Pushbullet API and its capabilities, visit the [Pushbullet API Documentation](https://docs.pushbullet.com/).

## Contributing

Contributions are welcome! If you would like to contribute, please fork the repository and submit a pull request.

### Steps for Contribution

1. Fork the repository.
2. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Description of your feature or fix"
   ```
4. Push to your branch:
   ```bash
   git push origin feature-name
   ```
5. Open a Pull Request with a description of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

This project was created by [OddRefrigerator](https://github.com/OddRefrigerator).

## Contact

For any inquiries or issues, feel free to open an issue on GitHub or contact the repository owner.
