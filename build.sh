#!/bin/bash

# FamilyCalendar App Build Script
# This script helps build the iOS app

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Project directory
PROJECT_DIR="/Users/armstrong/code/github/FamilyCalendarApp"
SCHEME_NAME="FamilyCalendar"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Family Calendar Build Script${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""

# Change to project directory
cd "$PROJECT_DIR"

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if xcodebuild is available
check_xcodebuild() {
    if ! command -v xcodebuild &> /dev/null; then
        print_message "$RED" "Error: xcodebuild not found. Please install Xcode."
        exit 1
    fi
    print_message "$GREEN" "✓ xcodebuild found"
}

# Function to build the project
build_project() {
    local configuration=$1

    print_message "$YELLOW" "Building $configuration..."
    xcodebuild clean build \
        -scheme "$SCHEME_NAME" \
        -configuration "$configuration" \
        -destination 'platform=iOS Simulator,name=iPhone 15' \
        | xcpretty || exit 1

    print_message "$GREEN" "✓ $configuration build successful"
}

# Function to run tests
run_tests() {
    print_message "$YELLOW" "Running tests..."
    xcodebuild test \
        -scheme "$SCHEME_NAME" \
        -destination 'platform=iOS Simulator,name=iPhone 15' \
        | xcpretty || exit 1

    print_message "$GREEN" "✓ Tests passed"
}

# Function to archive
archive_project() {
    local archive_path="$PROJECT_DIR/build/FamilyCalendar.xcarchive"

    print_message "$YELLOW" "Archiving..."
    xcodebuild archive \
        -scheme "$SCHEME_NAME" \
        -archivePath "$archive_path" \
        -destination 'generic/platform=iOS' \
        | xcpretty || exit 1

    print_message "$GREEN" "✓ Archive created at $archive_path"
}

# Function to show help
show_help() {
    echo "Usage: ./build.sh [option]"
    echo ""
    echo "Options:"
    echo "  debug       Build debug configuration"
    echo "  release     Build release configuration"
    echo "  test        Run unit tests"
    echo "  archive     Archive the project"
    echo "  clean       Clean build folder"
    echo "  help        Show this help message"
    echo ""
}

# Main script
check_xcodebuild

case "$1" in
    debug)
        build_project "Debug"
        ;;
    release)
        build_project "Release"
        ;;
    test)
        run_tests
        ;;
    archive)
        archive_project
        ;;
    clean)
        print_message "$YELLOW" "Cleaning build folder..."
        rm -rf "$PROJECT_DIR/build"
        rm -rf "$PROJECT_DIR/DerivedData"
        print_message "$GREEN" "✓ Clean completed"
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_message "$YELLOW" "Building default configuration (Debug)..."
        build_project "Debug"
        ;;
esac

echo ""
print_message "$GREEN" "========================================${NC}"
print_message "$GREEN"  "  Build completed successfully!${NC}"
print_message "$GREEN" "========================================${NC}"
