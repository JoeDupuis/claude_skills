{ pkgs, lib, config, inputs, ... }:{

  cachix.enable = false;

  env = {
    LD_LIBRARY_PATH = "${config.devenv.profile}/lib";
  };

  packages = with pkgs; [
    git
  ];
}
