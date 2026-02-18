{
  ...
}:

let serverName = "matrix.crystalwobsite.gay";

in
{
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        server_name = serverName;
        allow_registration = true;
        allow_encryption = false;
        allow_federation = true;
        registration_token = "1722 e6f1 150c be1f 4bce ff00 007c 32eb";
        url_preview_url_contains_allowlist = [ "*" ];

        # TURN config.
        turn_secret = ""; # Must match the coturn.nix file.
        turn_urls = [
          "turns:${serverName}?transport=udp"
          "turns:${serverName}?transport=tcp"
        ];
      };
    };
  };
}
