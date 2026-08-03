vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Nemirtingas/cista
    REF "feature/arch-interop"
    SHA512 978b30a05983b4e72e71e17c7b6bb6c92996b027abaf06fb0c981869fb659a1e000760444691bc34aaaae84031bf6dd691c2cb0fbb577ebdee3db67ab004767b
    HEAD_REF master
)

set(VCPKG_BUILD_TYPE release) # header-only port

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DCISTA_INSTALL=ON
		-DCISTA_CUSTOM_OFFSET_T_UNDERLYING_TYPE=std::int64_t
)

vcpkg_cmake_install()

vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/cista)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/lib")

vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
