{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.nginx
  ];

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;
  };

  imports = [
    ./ssl_certs_mikkel.cc.nix
    ./ssl_certs_snuletek.org.nix
    ./vhosts.d/thelounge.nix
  ];
}
