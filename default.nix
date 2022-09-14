let
  nixpkgs = builtins.fetchGit {
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-unstable";
    rev = "f2537a505d45c31fe5d9c27ea9829b6f4c4e6ac5"; # 27-06-2022
    # obtain via `git ls-remote https://github.com/nixos/nixpkgs nixos-unstable`
  };
  pkgs = import nixpkgs { config = {}; };
  dtcli = with pkgs; stdenv.mkDerivation rec {
    version = "1.6.3";
    name = "dtcli-${version}";
    src = fetchurl {
      url = "https://github.com/dynatrace-oss/dt-cli/releases/download/v${version}/dt";
      sha256 = "sha256-z2Apkj+ScOfbxmsAp6lTc53y9W1ZBuVKdD4gJfY+naU=";
    };

    unpackPhase = ''
      true
    '';

    installPhase = ''
      install -m755 -D $src $out/bin/dt
    '';

    meta = with lib; {
      platforms = platforms.linux;
    };
  };
  commonMake = with pkgs; stdenv.mkDerivation rec {
    version = "1feba9658f778c4e9901dc8635a6c10d1bd7ab75";
    name = "commonMake-${version}";
    src = builtins.fetchGit {
      url = "https://github.com/dynatrace-extensions/toolz.git";
      ref = "main";
      rev = version;
    };

    # TODO: how to better merge it into the environment?
    installPhase = ''
      install -m755 -D common.mk $out/bin/__dt_ext_common_make
    '';

    meta = with lib; {
      platforms = platforms.linux;
    };
  };
  pythonPkgs = python-packages: with python-packages; [
      ptpython # used for dev
      pyyaml
      jsonschema
    ] ++ internalPkgs.pythonPkgs;
  dtClusterSchema = with pkgs; stdenv.mkDerivation rec {
    version = "1-245";
    name = "dynatrace-cluster-schemas-${version}";
    src = fetchzip {
      url = "https://github.com/dynatrace-extensions/toolz/releases/download/schema-1245/dt-schemas-1-230.tar";
      sha256 = "sha256-9jc8HIZiTG9Qk/TULWNx9PAfi8M6Kq9k+7EWoJKgcHE=";
      stripRoot = false;
    };

    # TODO: how to better merge it into the environment?
    installPhase = ''
      mkdir -p $out/schemas
      cp * $out/schemas
      touch ble
      install -m755 -D ble $out/bin/__dt_cluster_schema
    '';
  };
  internalPkgs = if builtins.pathExists ./dynatrace-internal/root.nix
    then import ./dynatrace-internal/root.nix { parentPkgs = pkgs; }
    else {
      pkgs = [];
      pythonPkgs = [];
    };
  pythonCore = pkgs.python39;
  myPython = pythonCore.withPackages pythonPkgs;
  env = pkgs.buildEnv {
    name = "extension-dev-env";
    paths =
    with pkgs;
    [
      git
      gnugrep
      gnumake
      myPython
      
      # TODO: is this needed anymore?
      yq
      curl
      jq

      dtcli
      commonMake
      dtClusterSchema

      # extension-specific
      net-snmp
    ] ++ internalPkgs.pkgs;
  };
in
{
  docker = { image = pkgs.dockerTools.buildImage {
    name = "extension-env"; 
    tag = "builded"; 

    created = "now";

    contents = [ env ]; 

    runAsRoot = ''
      #!${pkgs.runtimeShell}
      mkdir -p /workdir
      ln -s ${pkgs.runtimeShell} /bin/sh
    '';

    config = { 
      Cmd = [ "${pkgs.runtimeShell}" ];
      WorkingDir = "/workdir";
    };
  };};
  shell = pkgs.mkShell {
    buildInputs = [ env ];
  };
}
