vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO paullouisageneau/libjuice
    REF "v${VERSION}"
    SHA512 9433db78b3caaab6aa974c47e812d1f337c804b217a1cbfef612dac97430d0bbc5d79cdca5f2493a09dd26f2451f8c31ab319c5fcdf080b0a49d8ae166440eb2
    HEAD_REF master
    PATCHES
        fix-for-vcpkg.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        nettle USE_NETTLE
)

string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" LIBJUICE_STATIC_LINKAGE)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
        -DNO_TESTS=ON
        -DLIBJUICE_STATIC_LINKAGE=${LIBJUICE_STATIC_LINKAGE}
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

vcpkg_cmake_config_fixup(PACKAGE_NAME libjuice CONFIG_PATH lib/cmake/LibJuice)
vcpkg_fixup_pkgconfig()

file(READ "${CURRENT_PACKAGES_DIR}/share/libjuice/LibJuiceConfig.cmake" DATACHANNEL_CONFIG)
file(WRITE "${CURRENT_PACKAGES_DIR}/share/libjuice/LibJuiceConfig.cmake" "
include(CMakeFindDependencyMacro)
find_dependency(Threads)
${DATACHANNEL_CONFIG}")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
