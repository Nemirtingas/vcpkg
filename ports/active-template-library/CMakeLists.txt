cmake_minimum_required(VERSION 3.0)
project(Find_active_template_library)

try_compile(COMPILE_SUCCEEDED
  SOURCES ${CMAKE_SOURCE_DIR}/main.cpp
  OUTPUT_VARIABLE COMPILE_OUTPUT)

if(NOT ${COMPILE_SUCCEEDED})
  message(FATAL_ERROR "Failed to find ATL: ${COMPILE_OUTPUT}")
endif()