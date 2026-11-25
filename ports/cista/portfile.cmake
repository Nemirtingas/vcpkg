vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO felixguendling/cista
    REF 1d45f71aa50633b283443eacdf449d47c367787c # master, with CISTA_64BIT_OFFSET (#290)
    SHA512 abe73412a5ca7738e1f1fec069f7b8b30cc146b0dee283ccc09c2debed923824b6ecfa4d8a2a680fddba2959c6b65b861ea28a53a761f196aef7848486b60f32
    HEAD_REF master
)

set(VCPKG_BUILD_TYPE release) # header-only port

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCISTA_INSTALL=ON
        -DCISTA_64BIT_OFFSET=ON
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/cista)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
