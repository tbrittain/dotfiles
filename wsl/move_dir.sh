#!/bin/bash

# move_dir.sh is for moving an existing directory on the Windows filesystem to a new directory
# on the WSL distro filesystem. See https://learn.microsoft.com/en-us/windows/wsl/setup/environment#file-storage
set -e

if [ -z "$1" ]; then
  echo "❌ Usage: $0 <path-to-git-repo>"
  exit 1
fi

SRC_PATH="$1"
REPO_NAME=$(basename "$SRC_PATH")
DEST_DIR="$HOME/source/repos"

if [ ! -d "$SRC_PATH" ]; then
  echo "❌ Error: '$SRC_PATH' does not exist or is not a directory."
  exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
  echo "📂 Creating target directory: $DEST_DIR"
  mkdir -p "$DEST_DIR"
fi

DEST_PATH="$DEST_DIR/$REPO_NAME"

if [ -e "$DEST_PATH" ]; then
  echo "⚠️ Destination '$DEST_PATH' already exists. Aborting to prevent overwrite."
  exit 1
fi

echo "🚚 Moving '$SRC_PATH' to '$DEST_PATH'..."
mv "$SRC_PATH" "$DEST_PATH"

echo "✅ Successfully moved to: $DEST_PATH"
