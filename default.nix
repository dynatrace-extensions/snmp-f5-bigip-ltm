let
  nixpkgs = builtins.fetchGit {
    url = "https://github.com/nixos/nixpkgs/";
    ref = "refs/heads/nixos-unstable";
    rev = "f2537a505d45c31fe5d9c27ea9829b6f4c4e6ac5"; # 27-06-2022
    # obtain via `git ls-remote https://github.com/nixos/nixpkgs nixos-unstable`
  };
  pkgs = import nixpkgs { config = {}; };
  pythonPkgs = python-packages: with python-packages; [
      ptpython # used for dev
      pyyaml
      jsonschema
    ];
  dtcli = with pkgs; stdenv.mkDerivation rec {
    version = "1.6.10";
    name = "dtcli-${version}";
    src = fetchurl {
      url = "https://github.com/dynatrace-oss/dt-cli/releases/download/v${version}/dt";
      sha256 = "1adcvhb464z9hfhygfrzrkb4qsa8vfx7lhsvj615ni7md1g1nx71";
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
    version = "1a61b557d4d7064180d407e1da16e20bd98f02b1";
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
  dtClusterSchema = with pkgs; stdenv.mkDerivation rec {
    version = "1-230";
    name = "dynatrace-cluster-schemas-${version}";
    src = fetchzip {
      url = "https://github.com/dynatrace-extensions/toolz/releases/download/schema-1230/dt-schemas-1-230.tar";
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
      yq
      curl
      jq
      myPython
      entr
      commonMake

      bzip2
      openssl
      zip

      dtcli
      dtClusterSchema

      # datasources
      # temporary disabled, until we figure out how to share it properly
      #snmpDatasource

      # extension-specific
      net-snmp
    ];
  };
in
{
  shell = pkgs.mkShell {
    buildInputs = [ env ];
  };
}
