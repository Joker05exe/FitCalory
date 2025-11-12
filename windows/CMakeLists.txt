cmake_minimum_required(VERSION 3.14)
project(calorie_tracker LANGUAGES CXX)

set(BINARY_NAME "calorie_tracker")

cmake_policy(SET CMP0063 NEW)

set(CMAKE_INSTALL_RPATH "$ORIGIN/lib")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")

add_subdirectory(${FLUTTER_MANAGED_DIR})

add_subdirectory("runner")

add_custom_target(COPY_ASSETS ALL
  COMMAND ${CMAKE_COMMAND} -E copy_directory
  "${PROJECT_BUILD_DIR}/_phx/" "${CMAKE_CURRENT_BINARY_DIR}"
)
