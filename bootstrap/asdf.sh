#!/bin/bash

set -e

echo "🔧 Installing asdf..."

ASDF_VERSION="v0.17.0"
ASDF_TAR="asdf-${ASDF_VERSION}-linux-amd64.tar.gz"

curl -LO https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/${ASDF_TAR}

mkdir -p ~/.local/bin
tar -xzf $ASDF_TAR -C ~/.local/bin

rm $ASDF_TAR

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
