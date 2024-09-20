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
    ./ssl_certs.nix
    ./vhosts.d/thelounge.nix
  ];
}
