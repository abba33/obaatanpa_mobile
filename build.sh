#!/bin/bash
set -e

# Download and extract Flutter
curl -fsSL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.27.0-stable.tar.xz | tar -xJ

# Fix git ownership issues
git config --global --add safe.directory $PWD/flutter

# Add Flutter to PATH
export PATH="$PWD/flutter/bin:$PATH"

# Disable analytics
flutter config --no-analytics

# Get dependencies
flutter pub get

# Build web app
flutter build web --release