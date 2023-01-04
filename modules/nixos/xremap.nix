{
  config,
  pkgs,
  lib,
  ...
}: {
  services.xremap = {
    serviceMode = "system";
    # withSway = true;
    # withGnome = true;
    withX11 = true;
    watch = true;
    config = {
      modmap = [
        {
          name = "CapsLock -> Ctrl_L";
          remap = {
            CapsLock = "Ctrl_L";
          };
        }
      ];
      keymap = [
        {
          name = "C-[ -> Esc";
          remap = {
            "C-Leftbrace" = "Esc";
          };
        }
      ];
    };
  };
}
