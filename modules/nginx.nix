{
  ...
}:

{
  services.nginx = {
    enable = true;
    root = "/var/www/crystalwobsite.gay";
    virtualHosts = {
      "0.0.0.0" = {
        listen = [
          {
            port = 443;
            ssl = false;
          }
          {
            port = 8448;
            ssl = false;
          }
        ];
        location."/_matrix/" = {
          extraConfig = ''
            proxy_pass http://127.0.0.1:6167$request_uri;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };
}
