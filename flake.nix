{
  description = "sd-image";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = nixpkgs.legacyPackages."aarch64-linux";
      sdImageAarch64 = "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel.nix";
    in
    rec {
      nixosConfigurations.edge2-native = nixpkgs.lib.nixosSystem {
        modules = [
          {
            boot.supportedFilesystems.zfs = nixpkgs.lib.mkForce false;
            imports = [
              sdImageAarch64
            ];
            sdImage = {
              # at least 500MiB otherwise kernel updates wont fit into /boot
              firmwareSize = 500; # MiB
            };
            hardware.firmware = [
              (pkgs.runCommand "bcm43752-firmware" { }
                "mkdir -p $out/lib/firmware; cp -r ${./firmware}/* $out/lib/firmware"
              )
            ];
            boot.loader = {
              grub.enable = false;
              generic-extlinux-compatible.enable = true;
            };
            nixpkgs.hostPlatform.system = "aarch64-linux";
            hardware.enableRedistributableFirmware = true;
          }
          {
            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
            networking.networkmanager.enable = true;
            environment.systemPackages = [ ];
            system.stateVersion = "26.05";
            services.openssh.enable = true;
            networking.hostName = "edge2";
            # user:asdf
            users.users.user = {
              password = "asdf";
              isNormalUser = true;
              extraGroups = [
                "networkmanager"
                "wheel"
                "input"
                "users"
              ];
            };
          }
        ];
      };
      images.edge2-native = nixosConfigurations.edge2-native.config.system.build.sdImage;
    };
}
