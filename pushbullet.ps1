# Help message
if ($args[0] -eq "-h" -or $args[0] -eq "--help") {
  Write-Host "Usage: $PScriptName [TITLE] [BODY]"
  Write-Host "  -h, --help   Display this help message"
  Write-Host "  -c FILE       Specify config file path (default: ~$HOME\.pushbullet)"
  exit 0
}

# Config file handling
$CONFIG_FILE = "$HOME\.pushbullet"

while ($opt = Switch -Parameter "-c") {
  switch ($opt.Parameter) {
    "c" { $CONFIG_FILE = $args[0] }
    default { Write-Error "Invalid option: -$opt.Parameter" ; exit 1 }
  }
  $args = $args[1..($args.Length)]  # Remove processed options from arguments
}

# Function to read API token from config file
function Read-Token {
  if (Test-Path $CONFIG_FILE) {
    Import-CliXml -Path $CONFIG_FILE  # Read token from config file
  }
  if (-not $PUSHBULLET_TOKEN) {
    Send-Notification "Error: PUSHBULLET_TOKEN not found in configuration file ($CONFIG_FILE)."
    exit 1
  }
}

# Function to send notification
function Send-Notification {
  param(
    [Parameter(Mandatory=$true)]
    [string] $message
  )
  
  $body = $BODY
  $title = $TITLE

  $response = Invoke-RestMethod -Uri 'https://api.pushbullet.pushbullet.com/v2/pushes' -Method Post -Body @{
    body = $body
    title = $title
  } -Headers @{
    Authorization = "Bearer $PUSHBULLET_TOKEN"
    ContentType = "application/json"
  }

  if ($response.StatusCode -eq 200) {
    Write-Host "Pushbullet notification sent!"
  } else {
    switch ($response.StatusCode) {
      429 { Write-Error "Error: Pushbullet rate limit exceeded." }
      401 { Write-Error "Error: Invalid Pushbullet API token." }
      default { Write-Error "Error: Pushbullet notification failed (code: $($response.StatusCode))" }
    }
  }
}

# Read token and handle errors
Read-Token

# Get notification arguments with defaults
$title = if ($args.Length -gt 0) { $args[0] } else { "Default Title" }

# Validate title (optional)
if ((-z $title) -or $title -match "[^a-zA-Z0-9\s]") {
  Send-Notification "Error: Invalid title provided."
  exit 1
}

$body = if ($args.Length -gt 1) { $args[1] } else { "Default Body" }

# Send notification
Send-Notification
