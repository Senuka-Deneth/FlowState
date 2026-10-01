#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
xcrun swift-format lint --strict --recursive App Features Packages Tests Package.swift
swift test
xcodebuild -project FlowState.xcodeproj -scheme FlowState \
    -configuration Debug -destination 'platform=macOS' -derivedDataPath .build/xcode build
codesign --verify --deep --strict .build/xcode/Build/Products/Debug/FlowState.app
plutil -lint App/Info.plist App/FlowState.entitlements App/PrivacyInfo.xcprivacy

