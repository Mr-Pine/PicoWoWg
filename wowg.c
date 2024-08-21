/**
 * Copyright (c) 2022 Raspberry Pi (Trading) Ltd.
*
 * SPDX-License-Identifier: BSD-3-Clause
 */

#include "pico/cyw43_arch.h"
#include "pico/stdio.h"
#include "pico/stdlib.h"
#include "wireguardif.h"
#include <lwip/ip.h>
#include <lwip/ip_addr.h>
#include <lwip/netif.h>
#include <lwip/pbuf.h>
#include <lwip/udp.h>
#include <pico/time.h>
#include <stdbool.h>
#include <stdint.h>

#include "argument_definitions.h"

static struct netif wg_netif_struct = {0};
static struct netif *wg_netif = NULL;
static uint8_t wireguard_peer_index = WIREGUARDIF_INVALID_INDEX;

#define STRINGIFY(x) #x
#define TO_STRING(x) STRINGIFY(x)
#define SPLIT_MAC(mac) STRINGIFY(mac)

int connect_wifi() {
  printf("Connecting to Wi-Fi...\n");
  if (cyw43_arch_wifi_connect_timeout_ms(TO_STRING(WIFI_SSID),
                                         TO_STRING(WIFI_PASSWORD),
                                         CYW43_AUTH_WPA2_AES_PSK, 30000)) {
    printf("failed to connect.\n");
    return 1;
  } else {
    char *ip = ipaddr_ntoa(netif_ip4_addr(netif_list));
    printf("Connected at %s.\n", ip);
  }
  return 0;
}

void connect_wireguard() {
  struct wireguardif_init_data wg;
  struct wireguardif_peer peer;
  ip_addr_t ipaddr;
  ipaddr_aton(TO_STRING(WG_ADDRESS), &ipaddr);
  ip_addr_t netmask;
  ipaddr_aton(TO_STRING(WG_SUBNET_MASK_IP), &netmask);
  ip_addr_t gateway;
  ipaddr_aton(TO_STRING(WG_GATEWAY_IP), &gateway);

  wg.private_key = TO_STRING(WG_PRIVATE_KEY);
  wg.listen_port = 51820;
  wg.bind_netif = NULL;

  wg_netif = netif_add(&wg_netif_struct, &ipaddr, &netmask, &gateway, &wg,
                       &wireguardif_init, &ip_input);

  netif_set_up(wg_netif);

  wireguardif_peer_init(&peer);
  peer.public_key = TO_STRING(WG_PUBLIC_KEY);
  peer.preshared_key = NULL;
  peer.keep_alive = WG_KEEPALIVE;
  peer.allowed_ip = ipaddr;
  peer.allowed_mask = netmask;
  ipaddr_aton(TO_STRING(WG_ENDPOINT_IP), &peer.endpoint_ip);
  peer.endport_port = WG_ENDPOINT_PORT;

  wireguardif_add_peer(wg_netif, &peer, &wireguard_peer_index);

  if ((wireguard_peer_index != WIREGUARDIF_INVALID_INDEX) &&
      !ip_addr_isany(&peer.endpoint_ip)) {
    wireguardif_connect(wg_netif, wireguard_peer_index);
  }
}

static struct udp_pcb *udp_wol;
#define WOL_PORT 9

void setup_wol() { udp_wol = udp_new(); }

void send_wol(uint8_t *mac, ip_addr_t *ip) {
  struct pbuf *packet = pbuf_alloc(PBUF_TRANSPORT, 102, PBUF_RAM);
  char *payload = (char *)packet->payload;
  memset(payload, 255, 6);

  for (int i = 6; i < 102; i++) {
    payload[i] = mac[(i - 6) % 6];
  }

  err_t error = udp_sendto(udp_wol, packet, ip, WOL_PORT);
  pbuf_free(packet);
  if (error != ERR_OK) {
    printf("Failed to send UDP packet! error=%d", error);
  } else {
    printf("Sent packet\n");

    cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 1);
    sleep_ms(500);
    cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 0);
  }
}

void udp_receive_packet(void *arg, struct udp_pcb *pcb, struct pbuf *p,
                        const ip_addr_t *addr, u16_t port) {
  printf("Received packet: \"%s\"\n", p->payload);
  if (strncmp("wake", p->payload, 4) == 0) {
    printf("Waking!\n");
    char *mac_string = TO_STRING(TARGET_MAC);
    uint8_t mac[6];
    sscanf(mac_string, "%2hhx:%2hhx:%2hhx:%2hhx:%2hhx:%2hhx",
           &mac[0], &mac[1], &mac[2], &mac[3], &mac[4], &mac[5]);
    send_wol(mac, &ip_addr_broadcast);
  }
}

void setup_udp() {
  struct udp_pcb *udp = udp_new();
  int port = 1234;
  printf("Binding udp port %d\n", 1234);
  udp_bind(udp, IPADDR_ANY, port);
  udp_recv(udp, udp_receive_packet, NULL);
}

int main() {
  stdio_init_all();
  if (cyw43_arch_init()) {
    printf("Wi-Fi init failed");
    return -1;
  }

  cyw43_arch_enable_sta_mode();

  if (connect_wifi()) while (true) {
    // :(
    cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 1);
    sleep_ms(200);
    cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 0);
    sleep_ms(200);
  };

  connect_wireguard();

  setup_wol();
  setup_udp();

  for (int i = 0; i < 3; i++) {
    cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 1);
    sleep_ms(500);
    cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 0);
    sleep_ms(500);
  }

  while (true) {
    sleep_ms(800);
  }
}
