if(EXISTS "${CURRENT_INSTALLED_DIR}/share/libressl/copyright"
    OR EXISTS "${CURRENT_INSTALLED_DIR}/share/boringssl/copyright")
    message(FATAL_ERROR "Can't build openssl if libressl/boringssl is installed. Please remove libressl/boringssl, and try install openssl again if you need it.")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Nemirtingas/openssl-externalCMake
    REF "${VERSION}"
    SHA512 1ad9ef844426d5687bbe7e939aea5dc153a82d0fc65e6e2572fc8fdf73de00b3d363fa54c6329bfde1d47d961c63f6f32ba534bf7e7a0b5884c148af2cbc33e2
)

vcpkg_from_github(
    OUT_SOURCE_PATH OPENSSL_SOURCE_PATH
    REPO openssl/openssl
    REF "openssl-${VERSION}"
    SHA512 5282e078eb205ef691647e07d65186d81f9328329a06cca209a138adf10b95f12c16742ac61b4ab86e5098c153645ea413088d8263ff7054fdd40decd85b271f
)

file(COPY "${OPENSSL_SOURCE_PATH}/" DESTINATION "${SOURCE_PATH}/openssl")

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    INVERTED_FEATURES
        no-asm OPENSSL_ASM
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        ${FEATURE_OPTIONS}
)

vcpkg_cmake_install()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/OpenSSL)
vcpkg_fixup_pkgconfig()

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
#file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}/")