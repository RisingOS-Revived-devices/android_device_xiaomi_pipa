/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_dalvik_heap.h>
#include <libinit_variant.h>

#include "vendor_init.h"

static const variant_info_t pipain_info = {
    .hwc_value = "INDIA",
    .sku_value = "",

    .brand = "Mi",
    .device = "pipain",
    .marketname = "Mi 11X",
    .model = "M2012K11AI",
    .build_fingerprint = "Mi/pipain/pipain:13/TKQ1.221114.001/V816.0.2.0.TKHINXM:user/release-keys",

    .nfc = false,
};

static const variant_info_t pipa_global_info = {
    .hwc_value = "GLOBAL",
    .sku_value = "",

    .brand = "POCO",
    .device = "pipa",
    .marketname = "POCO F3",
    .model = "M2012K11AG",
    .build_fingerprint = "POCO/pipa_global/pipa:13/TKQ1.221114.001/V816.0.3.0.TKHMIXM:user/release-keys",

    .nfc = true,
};

static const variant_info_t pipa_info = {
    .hwc_value = "",
    .sku_value = "",

    .brand = "Redmi",
    .device = "pipa",
    .marketname = "Redmi K40",
    .model = "M2012K11AC",
    .build_fingerprint = "Redmi/pipa/pipa:13/TKQ1.221114.001/V816.0.6.0.TKHCNXM:user/release-keys",

    .nfc = true,
};

static const std::vector<variant_info_t> variants = {
    pipain_info,
    pipa_global_info,
    pipa_info,
};

void vendor_load_properties() {
    search_variant(variants);
    set_dalvik_heap();
}
