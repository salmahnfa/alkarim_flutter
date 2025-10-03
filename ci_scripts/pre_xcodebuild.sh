#!/bin/sh
echo "Cleaning Pods..."
rm -rf ios/Pods ios/Podfile.lock
cd ios
pod install
cd ..
echo "Running flutter pub get..."
flutter pub get
