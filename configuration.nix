{
  lib,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [
    ./networking.nix
  ]
  # Required for Digital Ocean droplets.
  ++ lib.optional (builtins.pathExists ./do-userdata.nix) ./do-userdata.nix
  ++ [
    (modulesPath + "/virtualisation/digital-ocean-config.nix")
  ];

  # Enable flakes.
  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel" # Allow sudoers to push Nix closures.
      ];
    };
  };

  # Set your default locale, as you wish.
  i18n.defaultLocale = "C.UTF-8";

  # System-wide packages.
  environment.systemPackages = with pkgs; [
    curl
    fastfetch # Fetch backend.
    fd
    fish
    hyfetch # Fetch to show our system is working.
    iotop
    neovim # Change to your favourite tiny text editor.
    ripgrep
    tree
  ];

  programs.neovim = {
    defaultEditor = true;
  };

  users.users.lixy = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO42UEA9H6mEndCG/q7VpspuOOMorfVtMQTk3XuyZFXV"
      ];
    };
  };

  # Passwordless sudo.
  # WARNING!
  # If you decide to change this, remember you NEED to set a password
  # for the chosen user with an "authorizedKeys" setting. Passwords are
  # public in the nix store, so know what you're doing!
  security.sudo.wheelNeedsPassword = false;

  # Set this to whichever system state version you're installing now.
  # Afterwards, don't change this lightly. It doesn't need to change to
  # upgrade.
  system.stateVersion = "26.05";
}
