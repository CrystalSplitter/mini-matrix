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
        allow_federation = false;
      };
    };
  };
}
