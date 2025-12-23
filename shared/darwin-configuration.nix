{ config, pkgs, ... }:
{
  time.timeZone = "America/Chicago";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nix.optimise.automatic = true;

  programs.zsh.enable = true;

  users.users.owais = {
    name = "owais";
    home = "/Users/owais";
    shell = pkgs.zsh;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.commit-mono
      nerd-fonts.hack
      nerd-fonts.monaspace
      nerd-fonts._0xproto
      nerd-fonts.im-writing
      maple-mono.NF

      # TODO: averia-libre, newsreader, noto-sans, nunito-sans
      comic-mono
      open-sans
      fira-mono
      jetbrains-mono
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    neovim
    zsh
    nixfmt-rfc-style
    mas
    delta
    apple-sdk_15
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    # NOTE: Use 'dtruss' (built-in) instead of strace
    # NOTE: Use 'Activity Monitor' or 'top' instead of iotop
    brews = [ "iftop" ];

    casks = [
      "firefox"
      "visual-studio-code"
      "ghostty"
      "skim"
      "zed"
    ];
  };

  # Used for backwards compatibility, please read the changelog before changing
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
