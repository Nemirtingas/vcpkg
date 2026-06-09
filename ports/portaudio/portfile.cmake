vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Nemirtingas/portaudio
    REF a47ad714ff479cc6ad3152f032994ee2ed76cb7c
    SHA512 48019aad8dbd26025dab72eb3aa4819ea49bfcc12c3020128ef4ef7c6964950d014842862dc52c7f5fdb2aed3033c07ef9c3379a5b1f2a903f3004e4b0727c7a
    PATCHES
        jack.diff
        fix-guid-linker-errors.patch
        use-vcpkg-asiosdk.patch
)

string(COMPARE EQUAL "${VCPKG_CRT_LINKAGE}" "static" PA_DLL_LINK_WITH_STATIC_RUNTIME)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" PA_BUILD_SHARED)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" PA_BUILD_STATIC)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        asio PA_USE_ASIO
)

vcpkg_list(SET options)
if(VCPKG_TARGET_IS_WINDOWS)
    vcpkg_list(APPEND options
        -DPA_DLL_LINK_WITH_STATIC_RUNTIME=${PA_DLL_LINK_WITH_STATIC_RUNTIME}
        -DPA_LIBNAME_ADD_SUFFIX=OFF
    )
elseif(VCPKG_TARGET_IS_IOS OR VCPKG_TARGET_IS_OSX)
    vcpkg_list(APPEND options
        # avoid absolute paths
        -DCOREAUDIO_LIBRARY:STRING=-Wl,-framework,CoreAudio
        -DAUDIOTOOLBOX_LIBRARY:STRING=-Wl,-framework,AudioToolbox
        -DAUDIOUNIT_LIBRARY:STRING=-Wl,-framework,AudioUnit
        -DCOREFOUNDATION_LIBRARY:STRING=-Wl,-framework,CoreFoundation
        -DCORESERVICES_LIBRARY:STRING=-Wl,-framework,CoreServices
    )
else()
    vcpkg_list(APPEND options
        -DPA_USE_JACK=ON
        -DCMAKE_REQUIRE_FIND_PACKAGE_Jack=ON
        -DPA_USE_ALSA=OFF
    )
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${options}
        -DPA_BUILD_SHARED=${PA_BUILD_SHARED}
        -DPA_BUILD_STATIC=${PA_BUILD_STATIC}
        -DPA_USE_ASIO=${PA_USE_ASIO}
    OPTIONS_DEBUG
        -DPA_ENABLE_DEBUG_OUTPUT:BOOL=ON
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})
vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
    "${CURRENT_PACKAGES_DIR}/share/doc"
)

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
