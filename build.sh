#!/bin/bash

# List of target OS options
os_options=("linux" "windows" "darwin" "Exit")
# List of architecture options
arch_options=("amd64" "386" "arm64" "arm" "Reset" "Exit")

# CGO options
cgo_options=("Enabled" "Disabled" "Reset" "Exit")

# Function to select the target OS
select_os() {
    while true; do
        echo "Select the target OS for the build:"
        select os in "${os_options[@]}"; do
            case $os in
                "linux"|"windows"|"darwin")
                    echo "Selected OS: $os"
                    TARGET_OS=$os
                    return
                    ;;
                "Exit")
                    echo "Exiting..."
                    exit 0
                    ;;
                *)
                    echo "Invalid option. Try again."
                    ;;
            esac
        done
    done
}

# Function to select the architecture
select_arch() {
    while true; do
        echo "Select the architecture for the build:"
        select arch in "${arch_options[@]}"; do
            case $arch in
                "amd64"|"386"|"arm64"|"arm")
                    echo "Selected Architecture: $arch"
                    TARGET_ARCH=$arch
                    return
                    ;;
                "Reset")
                    echo "Resetting architecture selection..."
                    break
                    ;;
                "Exit")
                    echo "Exiting..."
                    exit 0
                    ;;
                *)
                    echo "Invalid option. Try again."
                    ;;
            esac
        done
    done
}

# Function to select CGO option
select_cgo() {
    while true; do
        echo "Select CGO option:"
        select cgo in "${cgo_options[@]}"; do
            case $cgo in
                "Enabled")
                    echo "CGO is enabled"
                    CGO_ENABLED=1
                    return
                    ;;
                "Disabled")
                    echo "CGO is disabled"
                    CGO_ENABLED=0
                    return
                    ;;
                "Reset")
                    echo "Resetting CGO selection..."
                    break
                    ;;
                "Exit")
                    echo "Exiting..."
                    exit 0
                    ;;
                *)
                    echo "Invalid option. Try again."
                    ;;
            esac
        done
    done
}

# Run the selection functions
select_os
select_arch
select_cgo

# Set up output binary name
output="./cmd"

if [ "$TARGET_OS" == "windows" ]; then
    output+=".exe"
fi

# Run the Go build command
echo "Building for OS: $TARGET_OS, Architecture: $TARGET_ARCH..."
GOOS=$TARGET_OS GOARCH=$TARGET_ARCH CGO_ENABLED=$CGO_ENABLED go build -o "$output" .

# Check if the build was successful
if [ $? -eq 0 ]; then
    echo "Build successful! Output binary: $output"
else
    echo "Build failed!"
fi
