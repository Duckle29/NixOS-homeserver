{config, pkgs, ...}:

{
  services.nginx.virtualHosts."delugeweb.mikkel.cc" = {
    useACMEHost = "mikkel.cc";
    forceSSL = true;

    locations = {
      "/" = {
        recommendedProxySettings = true;
        proxyPass = "http://127.0.0.1:8112/";
        extraConfig = ''
          proxy_set_header X-Deluge-Base "/";
          add_header X-Frame-Options SAMEORIGIN;
        '';
      };
    };
  };
}
