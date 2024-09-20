{config, pkgs, ... }:

{
  services.nginx.virtualHosts."devlounge.mikkel.cc" = {
      useACMEHost = "mikkel.cc";
      forceSSL = true;

      locations = {
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
      };
  };  
}
