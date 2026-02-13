{
  pkgs,
  config,
  ...
}:
let
  # TODO: Thread this through from the flake?
  domainName = "matrix.crystalwobsite.gay";
in
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
    80 # HTTP Web server (needed for ACME)
    443 # SSL Matrix Server-to-Client
    8448 # Matrix Server-to-Server, change later?
  ];

  # SSL Certificates
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "crystal@crystalwobsite.gay";
      webroot = "/var/lib/acme/acme-challenge/";
    };
    certs = {
      "${domainName}" = {
        group = config.services.nginx.group;
        # environmentFile = "/etc/cloudflare_token"
      };
    };
  };
}
