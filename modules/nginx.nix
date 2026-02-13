{
  ...
}:
let
  # TODO: Thread this through from the flake?
  domainName = "matrix.crystalwobsite.gay";
in
{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "${domainName}" = {
        addSSL = true;
        useACMEHost = "${domainName}";
        listen = [
          {
            addr = "0.0.0.0";
            port = 80;
            ssl = false;
          }
          {
            addr = "[::]";
            port = 80;
            ssl = false;
          }
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "[::]";
            port = 443;
            ssl = true;
          }
          {
            addr = "0.0.0.0";
            port = 8448;
            ssl = true;
          }
          {
            addr = "[::]";
            port = 8448;
            ssl = true;
          }
        ];
        locations."/_matrix/" = {
          extraConfig = ''
            proxy_pass http://127.0.0.1:6167$request_uri;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
        locations."/_conduwuit/" = {
          extraConfig = ''
            proxy_pass http://127.0.0.1:6167$request_uri;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
        locations."/.well-known/".root = "/var/lib/acme/acme-challenge/";
      };
    };
  };
}
