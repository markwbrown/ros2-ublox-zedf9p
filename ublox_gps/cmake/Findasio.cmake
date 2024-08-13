include(FindPackageHandleStandardArgs)

# Try to find ASIO headers
find_path(ASIO_INCLUDE_DIR
    NAMES asio.hpp
    PATHS
        /usr/include
        /usr/local/include
    DOC "ASIO include directory"
)

# Handle the QUIETLY and REQUIRED arguments and set ASIO_FOUND to TRUE if all listed variables are TRUE
find_package_handle_standard_args(asio
    REQUIRED_VARS ASIO_INCLUDE_DIR
    FAIL_MESSAGE "Could not find ASIO library"
)

if(ASIO_FOUND)
    set(ASIO_INCLUDE_DIRS ${ASIO_INCLUDE_DIR})
    if(NOT TARGET asio::asio)
        add_library(asio::asio INTERFACE IMPORTED)
        set_target_properties(asio::asio PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${ASIO_INCLUDE_DIRS}"
        )
    endif()
endif()

mark_as_advanced(ASIO_INCLUDE_DIR)