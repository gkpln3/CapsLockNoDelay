#!/bin/bash
set -e

# Build
xcodebuild -project CapsLockNoDelay.xcodeproj

# Clean up
rm -rf dmg 2>/dev/null || true
mkdir -p dmg
rm CapsLockNoDelay.dmg 2>/dev/null || true

# Package
cp -r build/Release/CapsLockNoDelay.app dmg/CapsLockNoDelay.app
ln -s /Applications dmg/Applications
cp README.md dmg/README.md
hdiutil create -fs HFSX -layout SPUD -size 40m -srcfolder dmg -volname "CapsLockNoDelay" -format UDZO "CapsLockNoDelay.dmg"