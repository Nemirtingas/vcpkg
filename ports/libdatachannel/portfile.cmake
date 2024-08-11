vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Nemirtingas/libdatachannel
    REF "v${VERSION}_cxx14"
    SHA512 c8ce30074836efc93879332b50d94c3821b1fa982fb0e9de1842b9b305bc07c7611336e001e657319dffe3dfbf228bd90da196bca83218f5bdfb309732989d69
    HEAD_REF master
    PATCHES 
        fix_dependency.patch
        library-linkage.diff
        uwp-warnings.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        stdcall CAPI_STDCALL
    INVERTED_FEATURES
        ws      NO_WEBSOCKET
        srtp    NO_MEDIA
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DPREFER_SYSTEM_LIB=ON
        -DNO_EXAMPLES=ON
        -DNO_TESTS=ON
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/LibDataChannel)
vcpkg_fixup_pkgconfig()

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/include/rtc/common.hpp" "#ifdef RTC_STATIC" "#if 1")
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include" "${CURRENT_PACKAGES_DIR}/debug/share")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
