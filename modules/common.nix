{
  self,
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    experimental-features = ["nix-command" "flakes"];
  };

  environment.systemPackages = with pkgs; [python3];

  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    (nerdfonts.override {fonts = ["RobotoMono"];})
  ];
}
