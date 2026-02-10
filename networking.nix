{
  pkgs,
  ...
}:

{
  networking = {
    hostName = "monotone";
    networkmanager.enable = true;
  };
  time.timeZone = "UTC";

  services.openssh = {
    enable = true;
    # For security reasons, always have PasswordAuthentication = false
    # and instead use SSH keys.
    settings.PasswordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [
    22 # SSH
    8448 # Matrix Server-to-Server, change later.
    443 # Matrix Server-to-Client
  ];
}
