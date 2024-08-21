if (DEFINED ENV{WIFI_SSID} AND (NOT WIFI_SSID))
    set(WIFI_SSID $ENV{WIFI_SSID})
    message("Using WIFI_SSID from environment ('${WIFI_SSID}')")
endif()
if (NOT WIFI_SSID)
    message(FATAL_ERROR "Missing argument WIFI_SSID")
endif()

if (DEFINED ENV{WIFI_PASSWORD} AND (NOT WIFI_PASSWORD))
    set(WIFI_PASSWORD $ENV{WIFI_PASSWORD})
    message("Using WIFI_PASSWORD from environment ('${WIFI_PASSWORD}')")
endif()
if (NOT WIFI_PASSWORD)
    message(FATAL_ERROR "Missing argument WIFI_PASSWORD")
endif()

if (DEFINED ENV{WG_PRIVATE_KEY} AND (NOT WG_PRIVATE_KEY))
    set(WG_PRIVATE_KEY $ENV{WG_PRIVATE_KEY})
    message("Using WG_PRIVATE_KEY from environment ('${WG_PRIVATE_KEY}')")
endif()
if (NOT WG_PRIVATE_KEY)
    message(FATAL_ERROR "Missing argument WG_PRIVATE_KEY")
endif()

if (DEFINED ENV{WG_ADDRESS} AND (NOT WG_ADDRESS))
    set(WG_ADDRESS $ENV{WG_ADDRESS})
    message("Using WG_ADDRESS from environment ('${WG_ADDRESS}')")
endif()
if (NOT WG_ADDRESS)
    message(FATAL_ERROR "Missing argument WG_ADDRESS")
endif()

if (DEFINED ENV{WG_SUBNET_MASK_IP} AND (NOT WG_SUBNET_MASK_IP))
    set(WG_SUBNET_MASK_IP $ENV{WG_SUBNET_MASK_IP})
    message("Using WG_SUBNET_MASK_IP from environment ('${WG_SUBNET_MASK_IP}')")
endif()
if (NOT WG_SUBNET_MASK_IP)
    message(FATAL_ERROR "Missing argument WG_SUBNET_MASK_IP")
endif()

if (DEFINED ENV{WG_GATEWAY_IP} AND (NOT WG_GATEWAY_IP))
    set(WG_GATEWAY_IP $ENV{WG_GATEWAY_IP})
    message("Using WG_GATEWAY_IP from environment ('${WG_GATEWAY_IP}')")
endif()
if (NOT WG_GATEWAY_IP)
    message(FATAL_ERROR "Missing argument WG_GATEWAY_IP")
endif()

if (DEFINED ENV{WG_PUBLIC_KEY} AND (NOT WG_PUBLIC_KEY))
    set(WG_PUBLIC_KEY $ENV{WG_PUBLIC_KEY})
    message("Using WG_PUBLIC_KEY from environment ('${WG_PUBLIC_KEY}')")
endif()
if (NOT WG_PUBLIC_KEY)
    message(FATAL_ERROR "Missing argument WG_PUBLIC_KEY")
endif()

if (DEFINED ENV{WG_KEEPALIVE} AND (NOT WG_KEEPALIVE))
    set(WG_PUBLIC_KEY $ENV{WG_KEEPALIVE})
    message("Using WG_PUBLIC_KEY from environment ('${WG_KEEPALIVE}')")
endif()

if (DEFINED ENV{WG_ALLOWED_IP} AND (NOT WG_ALLOWED_IP))
    set(WG_ALLOWED_IP $ENV{WG_ALLOWED_IP})
    message("Using WG_ALLOWED_IP from environment ('${WG_ALLOWED_IP}')")
endif()
if (NOT WG_ALLOWED_IP)
    message(FATAL_ERROR "Missing argument WG_ALLOWED_IP")
endif()

if (DEFINED ENV{WG_ALLOWED_IP_MASK_IP} AND (NOT WG_ALLOWED_IP_MASK_IP))
    set(WG_ALLOWED_IP_MASK_IP $ENV{WG_ALLOWED_IP_MASK_IP})
    message("Using WG_ALLOWED_IP_MASK_IP from environment ('${WG_ALLOWED_IP_MASK_IP}')")
endif()
if (NOT WG_ALLOWED_IP_MASK_IP)
    message(FATAL_ERROR "Missing argument WG_ALLOWED_IP_MASK_IP")
endif()

if (DEFINED ENV{WG_ENDPOINT_IP} AND (NOT WG_ENDPOINT_IP))
    set(WG_ENDPOINT_IP $ENV{WG_ENDPOINT_IP})
    message("Using WG_ENDPOINT_IP from environment ('${WG_ENDPOINT_IP}')")
endif()
if (NOT WG_ENDPOINT_IP)
    message(FATAL_ERROR "Missing argument WG_ENDPOINT_IP")
endif()

if (DEFINED ENV{WG_ENDPOINT_PORT} AND (NOT WG_ENDPOINT_PORT))
    set(WG_ENDPOINT_PORT $ENV{WG_ENDPOINT_PORT})
    message("Using WG_ENDPOINT_PORT from environment ('${WG_ENDPOINT_PORT}')")
endif()
if (NOT WG_ENDPOINT_PORT)
    message(FATAL_ERROR "Missing argument WG_ENDPOINT_PORT")
endif()

if (DEFINED ENV{TARGET_MAC} AND (NOT TARGET_MAC))
    set(TARGET_MAC $ENV{TARGET_MAC})
    message("Using TARGET_MAC from environment ('${TARGET_MAC}')")
endif()
if (NOT TARGET_MAC)
    message(FATAL_ERROR "Missing argument TARGET_MAC")
endif()

target_compile_definitions(wowg PRIVATE
         WIFI_SSID=${WIFI_SSID}
         WIFI_PASSWORD=${WIFI_PASSWORD}
         WG_PRIVATE_KEY=${WG_PRIVATE_KEY}
         WG_ADDRESS=${WG_ADDRESS}
         WG_SUBNET_MASK_IP=${WG_SUBNET_MASK_IP}
         WG_GATEWAY_IP=${WG_GATEWAY_IP}
         WG_PUBLIC_KEY=${WG_PUBLIC_KEY}
         WG_KEEPALIVE=${WG_KEEPALIVE}
         WG_ALLOWED_IP=${WG_ALLOWED_IP}
         WG_ALLOWED_IP_MASK_IP=${WG_ALLOWED_IP_MASK_IP}
         WG_ENDPOINT_IP=${WG_ENDPOINT_IP}
         WG_ENDPOINT_PORT=${WG_ENDPOINT_PORT}
         TARGET_MAC=${TARGET_MAC}
        )

