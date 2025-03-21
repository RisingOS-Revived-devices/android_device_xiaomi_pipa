#!/bin/bash

# Define repositories and their target directories
declare -A REPOS=(
    ["device/xiaomi/sm8250-common"]="https://github.com/Matrixx-Devices/android_device_xiaomi_sm8250-common"
    ["vendor/xiaomi/pipa"]="https://github.com/Matrixx-Devices/proprietary_vendor_xiaomi_pipa"
    ["vendor/xiaomi/sm8250-common"]="https://github.com/Matrixx-Devices/proprietary_vendor_xiaomi_sm8250-common"
    ["kernel/xiaomi/sm8250"]="https://github.com/Matrixx-Devices/android_kernel_xiaomi_pipa"
)

# Hardware/xiaomi (check if it's already crDroid)
HW_XIAOMI_DIR="hardware/xiaomi"
CRDROID_REPO="https://github.com/crdroidandroid/android_hardware_xiaomi.git"

if [ -d "$HW_XIAOMI_DIR" ]; then
    # Check if it's the crDroid repo
    if git -C "$HW_XIAOMI_DIR" remote get-url origin 2>/dev/null | grep -q "$CRDROID_REPO"; then
        echo "[INFO] hardware/xiaomi is already tracking crDroid, skipping..."
    else
        echo "[INFO] hardware/xiaomi is tracking a different repo. Replacing it with crDroid..."
        rm -rf "$HW_XIAOMI_DIR"
        git clone --depth 1 "$CRDROID_REPO" "$HW_XIAOMI_DIR" || { echo "[ERROR] Failed to clone crDroid hardware/xiaomi"; exit 1; }
    fi
else
    echo "[INFO] Cloning crDroid hardware/xiaomi..."
    git clone --depth 1 "$CRDROID_REPO" "$HW_XIAOMI_DIR" || { echo "[ERROR] Failed to clone crDroid hardware/xiaomi"; exit 1; }
fi

# Continue with other repos
for DIR in "${!REPOS[@]}"; do
    if [ -d "$DIR" ] && [ "$(ls -A "$DIR")" ]; then
        echo "[INFO] Skipping $DIR - already exists."
    else
        echo "[INFO] Cloning ${REPOS[$DIR]} into $DIR..."
        git clone --depth 1 "${REPOS[$DIR]}" "$DIR" || { echo "[ERROR] Failed to clone ${REPOS[$DIR]}"; exit 1; }
    fi
done

echo "[INFO] All repositories are set up!"

# Define Clang directory
CLANG_DIR="prebuilts/clang/host/linux-x86/zyc_clang"

# Check if Clang is fully set up (not just the directory)
if [ -d "$CLANG_DIR" ] && [ -f "$CLANG_DIR/bin/clang" ]; then
    echo "ZyC Clang is already set up, skipping installation."
else
    echo "Setting up ZyC Clang..."

    # Remove incomplete downloads if any
    rm -rf "$CLANG_DIR"
    mkdir -p "$CLANG_DIR"

    # Get the latest release tarball URL from GitHub API
    LATEST_RELEASE=$(curl -s https://api.github.com/repos/ZyCromerZ/Clang/releases/latest | grep "browser_download_url" | cut -d '"' -f 4 | grep "tar.gz")

    if [ -z "$LATEST_RELEASE" ]; then
        echo "Failed to fetch latest Clang release. Exiting..."
        exit 1
    fi

    # Download and extract latest ZYC Clang
    echo "Downloading latest Clang release..."
    wget --progress=bar:force -O "$CLANG_DIR/clang.tar.gz" "$LATEST_RELEASE"

    echo "Extracting Clang..."
    tar -xvzf "$CLANG_DIR/clang.tar.gz" -C "$CLANG_DIR"

    # Verify successful extraction
    if [ -f "$CLANG_DIR/bin/clang" ]; then
        echo "ZyC Clang setup complete!"
    else
        echo "Clang setup failed, cleaning up..."
        rm -rf "$CLANG_DIR"
        exit 1
    fi

    # Clean up tarball
    rm "$CLANG_DIR/clang.tar.gz"
fi

# AOSP recovery screen fix
ORIG_DIR=$(pwd)

# Navigate to bootable/recovery
cd bootable/recovery || exit

# Get the commit message of the commit we want to cherry-pick
COMMIT_MSG=$(git log -1 --format=%s 2e3bf15b0a249be01da27f7ceb3fdbfe0f5e9a82)

# Check if a commit with the same message is already in history
if git log --format=%s | grep -Fxq "$COMMIT_MSG"; then
    echo "Recovery fix commit already applied, skipping cherry-pick..."
else
    echo "Fetching and applying recovery fix commit..."
    git fetch https://github.com/CuriousNom/android_bootable_recovery.git
    if git cherry-pick 2e3bf15b0a249be01da27f7ceb3fdbfe0f5e9a82; then
        echo "Cherry-pick successful!"
    else
        echo "Cherry-pick failed! Aborting..."
        git cherry-pick --abort
    fi
fi

# Return to the original directory
cd "$ORIG_DIR"
