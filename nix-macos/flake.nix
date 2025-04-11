
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    unstable.url = "nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv/latest";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "unstable";
    };
  };

  outputs = { self, nixpkgs, unstable, devenv, fenix }: {
    packages."aarch64-darwin".default = let
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      unstablePkgs = unstable.legacyPackages."aarch64-darwin";
    in pkgs.buildEnv {
      name = "home-packages";
      paths = with pkgs; [
        bat
        brotli
        git
        htop
        jq
        ripgrep
        silver-searcher
        tmux
        zstd

        devenv

        ldns
        knot-dns

        postgresql
        prometheus
        prometheus.cli

        blocky
        curlie
        delta
        difftastic
        dnscontrol
        duckdb
        lazygit
        lego
        minio-client
        nebula
        rclone
        syncthing
        tig
        zola

      ];
    };
  };

}
