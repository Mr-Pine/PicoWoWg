if (DEFINED ENV{PICO_WIREGUARD_PATH} AND (NOT PICO_WIREGUARD_PATH))
    set(PICO_WIREGUARD_PATH $ENV{PICO_WIREGUARD_PATH})
    message("Using PICO_WIREGUARD_PATH from environment ('${PICO_WIREGUARD_PATH}')")
endif ()

if (NOT PICO_WIREGUARD_PATH)
  message(FATAL_ERROR "No pico wireguard found")
endif ()

add_subdirectory(${PICO_WIREGUARD_PATH} build/lib/pico_wireguard)
