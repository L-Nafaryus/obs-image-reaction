cmake_minimum_required(VERSION 3.16)

project(image-reaction VERSION 1.3)

set(PLUGIN_AUTHOR "scaled")
set(PLUGIN_GIT ${PROJECT_NAME})
set(LINUX_MAINTAINER_EMAIL "scaled@scaledteam.ru")
set(PLUGIN_URL "https://obsproject.com/forum/resources/mute-filter.1478/")

set(MACOS_BUNDLEID "ru.scaledteam.image-reaction")
set(MACOS_PACKAGE_UUID "AC34BEA6-6AAB-4CAE-AE0F-222F49F0503A")
set(MACOS_INSTALLER_UUID "4F2A848B-08BE-4EED-AD7F-824BD7B97A8A")

find_package(libobs REQUIRED)
include(cmake/ObsPluginHelpers.cmake)

add_library(image-reaction MODULE src/image-reaction.c)

target_link_libraries(image-reaction OBS::libobs)

if(OS_WINDOWS)
    # Enable Multicore Builds and disable FH4 (to not depend on VCRUNTIME140_1.DLL when building with VS2019)
    if(MSVC)
        add_definitions(/MP /d2FH4-)
    endif()

    target_link_libraries(${PROJECT_NAME} OBS::w32-pthreads)

    configure_file(cmake/installer/installer-Windows.iss.in installer-Windows.generated.iss)
endif()

if(OS_LINUX)
    target_compile_options(${PROJECT_NAME} PRIVATE -Wall -Wextra)
endif()

if(APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++ -fvisibility=default")

    set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "")
    set(MACOSX_PLUGIN_GUI_IDENTIFIER "${MACOS_BUNDLEID}")
    set(MACOSX_PLUGIN_BUNDLE_VERSION "${PROJECT_VERSION}")
    set(MACOSX_PLUGIN_SHORT_VERSION_STRING "1")

    configure_file(cmake/installer/installer-macOS.pkgproj.in installer-macOS.generated.pkgproj)
endif()

setup_plugin_target(${PROJECT_NAME})

