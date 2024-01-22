{
  description = "Bcachefs enabled installation media";
  inputs.nixos.url = "github:nixos/nixpkgs/nixos-23.11";
  outputs = { self, nixos }: {
    nixosConfigurations = {
      exampleIso = nixos.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
          ({ lib, pkgs, ... }: {
	    nixpkgs.hostPlatform = {
              gcc.arch = "skylake";
              gcc.tune = "skylake";
              system = "x86_64-linux";
            };
            boot.supportedFilesystems = [ "bcachefs" ];
            boot.kernelPackages = lib.mkOverride 0 pkgs.linuxPackages_latest;
          })
        ];
      };
    };
  };
}
