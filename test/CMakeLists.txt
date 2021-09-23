cmake_minimum_required(VERSION 3.14)

project(multi-targetTests LANGUAGES CXX)

include(../cmake/project-is-top-level.cmake)
include(../cmake/windows-set-path.cmake)

if(PROJECT_IS_TOP_LEVEL)
  find_package(multi-target REQUIRED)
  enable_testing()
endif()

add_executable(multi-target_test source/multi-target_test.cpp)
target_link_libraries(multi-target_test PRIVATE multi-target::multi-target)
target_compile_features(multi-target_test PRIVATE cxx_std_17)

add_test(NAME multi-target_test COMMAND multi-target_test)
windows_set_path(multi-target_test multi-target::multi-target)
