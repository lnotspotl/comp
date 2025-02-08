#!/bin/bash

# We only support Ubuntu
if [ "$(lsb_release -is)" != "Ubuntu" ]; then
    echo "This script is designed to run on Ubuntu"
    exit 1
fi

# We need sudo privileges
if [ "$EUID" -ne 0 ]; then
    echo "Run this script with sudo privileges"
    exit 1
fi

# Install dependencies
apt update
apt install -y --no-install-recommends \
      ssh \
      build-essential \
      wget \
      gcc \
      g++ \
      gdb \
      cmake \
      rsync \
      tar \
      python3 \
      python3-pip \
      zlib1g-dev \
      bison \
      libbison-dev \
      flex \
      lsb-release \
      software-properties-common \
      gnupg \
      time \
      less \
      zstd \
      libzstd-dev

# Install LLVM 19
wget https://apt.llvm.org/llvm.sh
chmod +x ./llvm.sh
./llvm.sh 19 all
rm llvm.sh