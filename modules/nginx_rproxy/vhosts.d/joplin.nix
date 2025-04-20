{config, pkgs, ...}:

{
  services.nginx.virtualHosts."joplin.mikkel.cc" = {
    useACMEHost = "mikkel.cc";
    forceSSL = true;
    extraConfig = ''
      client_max_body_size 100000M;
      
      # Set headers
      proxy_set_header Host              $host;
      proxy_set_header X-Real-IP         $remote_addr;
      proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto $scheme;

      # enable websockets: http://nginx.org/en/docs/http/websocket.html
      proxy_http_version 1.1;
      proxy_set_header   Upgrade    $http_upgrade;
      proxy_set_header   Connection "upgrade";
      proxy_redirect     off;

      # set timeout
      proxy_read_timeout 600s;
      proxy_send_timeout 600s;
      send_timeout       600s;
    '';

    locations = {
      "/" = {
        recommendedProxySettings = false;
        proxyPass = "http://192.168.6.220:30027/";
      };
    };
  };
}
