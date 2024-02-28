{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv.url = "github:cachix/devenv";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # What systems to build for
      systems = [ "x86_64-linux" ];

      # modular flakes to import
      imports = [
        ./home/profiles
        ./hosts
        ./lib
        ./modules
        ./pkgs
        inputs.devenv.flakeModule
        inputs.flake-parts.flakeModules.easyOverlay
        inputs.pre-commit-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        formatter = pkgs.alejandra;

        pre-commit = {
          settings.excludes = [ "flake.lock" ];

          settings.hooks = {
            alejandra.enable = true;
            prettier.enable = true;
          };
        };

        treefmt = {
          enable = true;
          
          projectRootFile = "flake.nix";

          programs = {
            alejandra.enable = true;
            ruff.enable = true;
            deadnix.enable = true;
            shellcheck.enable = true;
            shfmt = {
              enable = true;
              indent_size = 4;
            };
	  };
        };

        devenv.shells.dots = {
          packages = with pkgs; [
            inputs'.agenix.packages.default
            inputs'.catppuccinifier.packages.cli
            config.treefmt.build.wrapper
            git
            alejandra
            nodePackages.prettier
          ];

          languages.nix.enable = true;
          langagues.python.enable = true;

          enterShell = ''
            dots devenv shell
          '';
        };
      };
    };
}
