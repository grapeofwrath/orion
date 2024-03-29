{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:Mic92/sops-nix";
    hyprland.url = "github:hyprwm/Hyprland";
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib; #// home-manager.lib;
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
  in {
    inherit lib;

    # 'nix fmt'
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    # devshell for working with nixconfig
    devShells = forAllSystems (pkgs: import ./shell.nix {inherit pkgs;});

    nixosConfigurations = {
      # nixos-rebuild --flake .#your-hostname
      grapestation = lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/machines/grapestation
        ];
      };
      grapepad = lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./nixos/machines/grapepad
        ];
      };
    };
  };
}
