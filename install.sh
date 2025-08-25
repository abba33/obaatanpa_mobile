#!/bin/bash

# Install Flutter
cd /tmp
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:/tmp/flutter/bin"

# Navigate back to project
cd $VERCEL_PROJECT_PATH

# Get dependencies and build
flutter pub get
flutter build web --release