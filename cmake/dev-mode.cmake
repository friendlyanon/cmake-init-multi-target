include(CTest)
if(BUILD_TESTING)
  add_subdirectory(test)
endif()

include(cmake/lint-targets.cmake)
include(cmake/spell-targets.cmake)
