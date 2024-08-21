cmake_minimum_required(VERSION 3.13)

set(PICO_BOARD pico_w)
include(pico_sdk_import.cmake)
project(test_project C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

pico_sdk_init()
include(pico_wireguard_import.cmake)

add_executable(wowg
  wowg.c
)

target_include_directories(wowg PRIVATE
  ${CMAKE_CURRENT_LIST_DIR}
  ${pico_wireguard_SOURCE_DIR}/src
)

include(arguments.cmake)

# Uncomment if you want to flash your board via picotool.
pico_enable_stdio_usb(wowg 1)
pico_add_extra_outputs(wowg)

target_link_libraries(wowg
  pico_stdlib
  # Uncomment when using Pico W
  # pico_cyw43_arch_none
  pico_cyw43_arch_lwip_threadsafe_background
  pico_wireguard
)


target_link_libraries(pico_stdlib)
