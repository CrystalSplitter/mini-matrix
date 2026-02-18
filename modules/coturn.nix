{
  ...
}:

{
  services.coturn = {
    enable = true;
    use-auth-secret = true;
    # Generate this with 'pwgen -s 64 1'
    static-auth-secret= "";
    realm = "matrix.crystalwobsite.gay";
  };
}
