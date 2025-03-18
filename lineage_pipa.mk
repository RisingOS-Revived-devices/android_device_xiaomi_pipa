#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Inherit some common lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Rising Flags
PRODUCT_BUILD_PROP_OVERRIDES += \
    RisingChipset="Snapdragon 870" \
    RisingMaintainer="Aryan"

RISING_MAINTAINER := Aryan
TARGET_ENABLE_BLUR := true
WITH_GMS := true
TARGET_CORE_GMS := true
TARGET_CORE_GMS_EXTRAS := true
PRODUCT_PACKAGES += \
    Photos \
    AiWallpapers \
    LatinIMEGooglePrebuilt \
    WallpaperEmojiPrebuilt \
    PrebuiltDeskClockGoogle \
    CalculatorGooglePrebuilt \
    CalendarGooglePrebuilt \
    Velvet

# Inherit from pipa device
$(call inherit-product, device/xiaomi/pipa/device.mk)

# Inherit Camera-related flags
TARGET_USES_MIUI_CAMERA := true
TARGET_INCLUDES_MIUI_CAMERA := true

PRODUCT_NAME := lineage_pipa
PRODUCT_DEVICE := pipa
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 23043RP34G

PRODUCT_CHARACTERISTICS := tablet
TARGET_SUPPORTS_QUICK_TAP := false

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildFingerprint=Android/missi_pad_cn/missi:14/UKQ1.240624.001OS2.0.7.0.UMZCNXM:user/release-keys
