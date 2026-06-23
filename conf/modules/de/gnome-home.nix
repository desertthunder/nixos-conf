{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnome-extension-manager
    gnome-tweaks
  ];

  dconf.settings = {
    "org/gnome/desktop/lockdown" = {
      disable-log-out = false;
    };

    "org/gnome/desktop/interface" = {
      icon-theme = "kora";
    };

    "org/gnome/shell" = {
      always-show-log-out = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Control><Alt>t";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty-zellij" = {
      name = "Ghostty (zellij)";
      command = "ghostty -e zellij";
      binding = "<Super>z";
    };
  };
}
