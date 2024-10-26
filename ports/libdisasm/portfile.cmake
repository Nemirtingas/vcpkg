vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Nemirtingas/libdisasm
    REF "v${VERSION}"
    SHA512 b2ba0efc24195b906e16e30f639572defbe5686e03c9238a426aa522ccf4def47b6b9c9920019c9592031cfdfd8edf342435051cd2e9fbbd15f0a8fedc0fecd3
    HEAD_REF main
    PATCHES sizeofvoid.patch
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"
  OPTIONS_DEBUG
    -DDISABLE_INSTALL_HEADERS=ON
)

vcpkg_cmake_install()

# Handle copyright
file(INSTALL "${SOURCE_PATH}/COPYING" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
