{
  config,
  pkgs,
  lib,
  self,
  inputs,
  ...
}: {
  imports = [./base.nix];

  system.stateVersion = "22.11";

  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.autoRepeatDelay = 200;
  services.xserver.autoRepeatInterval = 25;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
