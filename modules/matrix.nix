{
  ...
}:

{
  services.matrix-continuwuity = {
    enable = true;
    settings = {
      global = {
        server_name = "matrix.crystalwobsite.gay";
        allow_registration = true;
        allow_encryption = false;
        registration_token = "1722 e6f1 150c be1f 4bce ff00 007c 32eb";
        url_preview_url_contains_allowlist = [ "*" ];
        allow_federation = false;
      };
    };
  };
}
