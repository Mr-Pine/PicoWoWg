# WakeOnLan Wireguard Proxy on a Pi Pico W
---

### Building
0. Get your https://github.com/raspberrypi/pico-sdk set up (clone it to a directory of your choice)
1. Clone https://github.com/Mr-Pine/pi-pico-wireguard-lwip to a directory of your choice
2. Create your build directory (i.e. ./build) and enter it
3. run `cmake ..`. You'll have to specify extra arguments like locations of pico_wireguard (the directory you cloned it to), the sdk location, ssid, ... . For an overview see [here](arguments.cmake) but cmake should also error if you are missing required arguments
4. run `make`
5. Flash your image to the chip with `picotool load -f *.uf2`, if you don't already have picotool installed use the one in `./_deps/picotool/picotool`. If this is the first time you're flashing this image (or any other with usb support) you'll have to unplug your chip and plug it back in again while holding the BOOTSEL button before running picotool. In that case you'll also have to run `picotool reboot`
