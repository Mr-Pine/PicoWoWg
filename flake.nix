{
  description = "WakeOnLan Wireguard Proxy on a Pi Pico W";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs"; };

  outputs = { self, nixpkgs }:
    let forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          pico-sdk = pkgs.pico-sdk.override { withSubmodules = true; };
        in {
          default = pkgs.stdenv.mkDerivation {
            pname = "pi-pico-wireguard-lwip";
            version = "0.1.0";

            src = ./.;

            buildInputs =
              [ pkgs.cmake pkgs.makeWrapper pkgs.gcc pkgs.python3 pico-sdk ];

            cmakeFlags = [
              "-DPICO_SDK_PATH=${pico-sdk}"
              "-DSOME_OTHER_FLAGS=values" # Replace with relevant arguments
            ];

            installPhase = ''
              mkdir -p $out/bin
              cp *.uf2 $out/bin/
            '';
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          pico-sdk = pkgs.pico-sdk.override { withSubmodules = true; };
        in {
          default = pkgs.mkShell {
            buildInputs =
              [ pkgs.cmake pkgs.gcc pkgs.python3 pkgs.picotool pico-sdk ];

            shellHook = ''
              echo "Development environment for pi-pico-wireguard-lwip is ready."
              echo "Make sure to set the required arguments for cmake."
              export PICO_SDK_PATH=${pico-sdk}/lib/pico-sdk/
            '';
          };
        });
    };
}
