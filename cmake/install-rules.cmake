if(PROJECT_IS_TOP_LEVEL)
  set(CMAKE_INSTALL_INCLUDEDIR include/multi-target CACHE PATH "")
endif()

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

# find_package(<package>) call for consumers to find this project
set(package multi-target)

install(
    DIRECTORY
    include/
    "${PROJECT_BINARY_DIR}/export/"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    COMPONENT multi-target_Development
    PATTERN private/* EXCLUDE
)

install(
    TARGETS multi-target_multi-target
    EXPORT multi-targetTargets
    RUNTIME #
    COMPONENT multi-target_Runtime
    LIBRARY #
    COMPONENT multi-target_Runtime
    NAMELINK_COMPONENT multi-target_Development
    ARCHIVE #
    COMPONENT multi-target_Development
    INCLUDES #
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

write_basic_package_version_file(
    "${package}ConfigVersion.cmake"
    COMPATIBILITY SameMajorVersion
)

# Allow package maintainers to freely override the path for the configs
set(
    multi-target_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATADIR}/${package}"
    CACHE PATH "CMake package config location relative to the install prefix"
)
mark_as_advanced(multi-target_INSTALL_CMAKEDIR)

configure_file(cmake/install-config.cmake.in "${package}Config.cmake" @ONLY)

install(
    FILES
    "${PROJECT_BINARY_DIR}/${package}Config.cmake"
    "${PROJECT_BINARY_DIR}/${package}ConfigVersion.cmake"
    DESTINATION "${multi-target_INSTALL_CMAKEDIR}"
    COMPONENT multi-target_Development
)

install(
    EXPORT multi-targetTargets
    NAMESPACE multi-target::
    DESTINATION "${multi-target_INSTALL_CMAKEDIR}"
    COMPONENT multi-target_Development
)

if(NOT BUILD_SHARED_LIBS)
  install(
      TARGETS multi-target_dependency
      EXPORT multi-targetInternalTargets
      # multi-target_dependency is always STATIC, so ARCHIVE only will do
      ARCHIVE COMPONENT multi-target_Development
  )

  install(
      EXPORT multi-targetInternalTargets
      NAMESPACE multi-target::internal::
      DESTINATION "${multi-target_INSTALL_CMAKEDIR}"
      COMPONENT multi-target_Development
  )
endif()

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
