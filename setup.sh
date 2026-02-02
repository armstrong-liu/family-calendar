#!/bin/bash

# Setup script for FamilyCalendar App

set -e

echo "=========================================="
echo "  Family Calendar App Setup"
echo "=========================================="
echo ""

PROJECT_DIR="/Users/armstrong/code/github/FamilyCalendarApp"
cd "$PROJECT_DIR"

echo "✓ Navigated to project directory"

# Create necessary directories
echo ""
echo "Creating directory structure..."

mkdir -p build
mkdir -p DerivedData

echo "✓ Directory structure created"

# Make build script executable
echo ""
echo "Setting file permissions..."

chmod +x build.sh

echo "✓ Build script is now executable"

# Check Xcode installation
echo ""
echo "Checking Xcode installation..."

if ! command -v xcodebuild &> /dev/null; then
    echo "⚠️  Warning: xcodebuild not found. Please install Xcode from the App Store."
    exit 1
fi

XCODE_VERSION=$(xcodebuild -version | head -n 1)
echo "✓ $XCODE_VERSION found"

# Check for Swift
if ! command -v swift &> /dev/null; then
    echo "⚠️  Warning: Swift not found."
    exit 1
fi

SWIFT_VERSION=$(swift --version | head -n 1)
echo "✓ $SWIFT_VERSION found"

echo ""
echo "=========================================="
echo "  Setup Checklist"
echo "=========================================="
echo ""
echo "Before running the app, ensure you have:"
echo ""
echo "□ Apple Developer Account"
echo "□ Xcode 15.0 or later"
echo "□ iOS 16.0+ SDK"
echo "□ Enabled CloudKit in Apple Developer Portal"
echo "□ Enabled Sign in with Apple"
echo "□ Configured CloudKit Container"
echo "□ Configured Push Notifications"
echo ""
echo "See DEVELOPMENT.md for detailed instructions."
echo ""
echo "=========================================="
echo "  Setup Complete!"
echo "=========================================="
echo ""
echo "To open the project:"
echo "  open FamilyCalendar.xcodeproj"
echo ""
echo "To build the project:"
echo "  ./build.sh debug"
echo ""
