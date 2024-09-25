{config, pkgs, ... }:

let
  locations_cfg = {
    "/" = {
      recommendedProxySettings = false;
      proxyPass = "http://127.0.0.1:9000/";
      extraConfig = ''
        proxy_http_version 1.1;
        proxy_set_header Connection "upgrade";
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_read_timeout 1d;
      '';
    };

    "~ \"/uploads/([a-f0-9]{2})([a-f0-9]*)/(.*)\"" = {
      extraConfig = ''
        #include mime.types;
        alias /var/lib/thelounge/uploads/$1/$1$2;
      '';
    };
  };

  extra_cfg = ''
    client_max_body_size 50M;
  '';

in
{
  users.groups.thelounge = {};
  users.users.nginx.extraGroups = [ "thelounge" ];

  services.nginx.virtualHosts."lounge.mikkel.cc" = {
    useACMEHost = "mikkel.cc";
    forceSSL = true;

    extraConfig = extra_cfg;
    locations = locations_cfg;
  };

  services.nginx.virtualHosts."lounge.snuletek.org" = {
    useACMEHost = "snuletek.org";
    forceSSL = true;

    extraConfig = extra_cfg;
    locations = locations_cfg;
  };
}
