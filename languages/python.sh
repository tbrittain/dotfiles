#!/bin/bash

set -e

PYTHON_VERSION="3.13.4"

echo "🔧 Installing Python ${PYTHON_VERSION} with asdf..."

sudo apt update
sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev \
  libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
  xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git

asdf plugin add python
asdf install python ${PYTHON_VERSION}
echo "Python ${PYTHON_VERSION} installed successfully."

# install uv
echo "🔧 Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
echo "uv installed successfully."
