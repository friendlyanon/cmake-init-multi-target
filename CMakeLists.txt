cmake_minimum_required(VERSION 3.14)

include(cmake/prelude.cmake)

project(
    multi-target
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://example.com/"
    LANGUAGES CXX
)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)

# ---- Declare dependency ----

add_library(multi-target_dependency STATIC source/dependency.cpp)
add_library(multi-target::internal::dependency ALIAS multi-target_dependency)

set_target_properties(
    multi-target_dependency PROPERTIES
    EXPORT_NAME dependency
    OUTPUT_NAME dependency
)

target_include_directories(
    multi-target_dependency ${multi-target_warning_guard}
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
)

target_compile_features(multi-target_dependency PUBLIC cxx_std_17)

# ---- Declare library ----

add_library(
    multi-target_multi-target
    source/multi-target.cpp
)
add_library(multi-target::multi-target ALIAS multi-target_multi-target)

include(GenerateExportHeader)
generate_export_header(
    multi-target_multi-target
    BASE_NAME multi-target
    EXPORT_FILE_NAME export/multi-target/multi-target_export.hpp
    CUSTOM_CONTENT_FROM_VARIABLE pragma_suppress_c4251
)

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(multi-target_multi-target PUBLIC MULTI_TARGET_STATIC_DEFINE)
endif()

set_target_properties(
    multi-target_multi-target PROPERTIES
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN YES
    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}"
    EXPORT_NAME multi-target
    OUTPUT_NAME multi-target
)

target_include_directories(
    multi-target_multi-target ${multi-target_warning_guard}
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
)

target_include_directories(
    multi-target_multi-target SYSTEM
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/export>"
)

target_compile_features(multi-target_multi-target PUBLIC cxx_std_17)

target_link_libraries(multi-target_multi-target PRIVATE multi-target_dependency)

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
  include(cmake/install-rules.cmake)
endif()

# ---- Developer mode ----

if(NOT multi-target_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
      AUTHOR_WARNING
      "Developer mode is intended for developers of multi-target"
  )
endif()

include(cmake/dev-mode.cmake)
