#!/bin/sh

# Check if a username was passed as an argument, otherwise default to 'nannoda'
GITHUB_USER=${1:-nannoda}

# URL to fetch the keys
KEYS_URL="https://github.com/$GITHUB_USER.keys"

# Destination for authorized keys
AUTHORIZED_KEYS="$HOME/.ssh/authorized_keys"

# Create the .ssh directory if it doesn't exist
mkdir -p "$HOME/.ssh"

# Fetch public keys from the GitHub account
echo "Fetching public keys from GitHub user: $GITHUB_USER"
curl -s "$KEYS_URL" > /tmp/github_keys

# Check if the fetch was successful
if [ $? -ne 0 ]; then
  echo "Failed to fetch keys from GitHub."
  exit 1
fi

# Ensure the file is non-empty
if [ ! -s /tmp/github_keys ]; then
  echo "No keys found for user $GITHUB_USER."
  exit 1
fi

# Add the keys to the authorized_keys file
echo "Adding keys to $AUTHORIZED_KEYS..."
cat /tmp/github_keys >> "$AUTHORIZED_KEYS"

# Set correct permissions for .ssh directory and authorized_keys file
chmod 700 "$HOME/.ssh"
chmod 600 "$AUTHORIZED_KEYS"

# Clean up temporary file
rm /tmp/github_keys

echo "Public keys successfully added to authorized_keys for user $GITHUB_USER."
