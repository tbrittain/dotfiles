#!/bin/bash

set -e
echo "🔧 Installing Node.js with asdf..."

asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest
echo "Node.js installed successfully."