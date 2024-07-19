{
  description = "My NixOS for Desktop and Laptop";

  inputs = {
    # source for nixpackages, could be a version, but I prefer the latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # necesary packages for flakes
    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # home-manager package
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # index db for nixpackages
    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #@HERE: continue

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccinifier = {
      url = "github:lighttigerXIV/catppuccinifier";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi.url = "github:sxyazi/yazi";

    matugen = {
      url = "github:InioX/matugen/module";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper.url = "github:hyprwm/hyprpaper";

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun.url = "github:fufexan/anyrun";

    chaotic.url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland/fe7b748eb668136dd0558b7c8279bfcd7ab4d759";

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # What systems to build for, I currently only own 64bit systems
      systems = ["x86_64-linux"];

      # modular flakes to import
      imports = [
        ./home/profiles
        ./hosts
        ./lib
        ./modules
        ./pkgs

        ### Extra Stuff
        inputs.flake-parts.flakeModules.easyOverlay # Provides 'perSystem' functionality
        inputs.pre-commit-hooks.flakeModule
        inputs.treefmt-nix.flakeModule # formatter for the whole project tree
      ];

      perSystem = {
        inputs',
        config,
        pkgs,
        ...
      }: {
        formatter = pkgs.alejandra;

        pre-commit = {
          settings.excludes = ["flake.lock"];

          settings.hooks = {
            alejandra.enable = true;
          };
        };

        treefmt = {
          projectRootFile = "flake.nix";

          programs = {
            alejandra.enable = true;
            deadnix.enable = true;
            shellcheck.enable = true;
            shfmt = {
              enable = true;
              indent_size = 4;
            };
          };
        };
      };
    };
}
