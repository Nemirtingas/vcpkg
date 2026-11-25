vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Nemirtingas/cista
    REF b515c08ea32647530293283d9ac3b3a10713b5ac # master: upstream + felixguendling/cista#291, #292, #293
    SHA512 b729746825627fa425f5ba8f50d9d476f4120111b55d5c4126b5bf863e87563645bc689cce5780ef8e63f64563319d87c3020fc7833b33a9c0e5c355f9ce38a7
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

# The layout of the serialized types is checked member by member (felixguendling/cista#292): the global check that int64_t and
# double are 8 byte aligned would reject 32bit x86 Linux, where the i386 ABI aligns them to 4 bytes.
vcpkg_replace_string("${CURRENT_PACKAGES_DIR}/share/${PORT}/cistaTargets.cmake" ";CISTA_64BIT_OFFSET\"" ";CISTA_64BIT_OFFSET;CISTA_SKIP_ALIGNMENT_CHECK\"")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
