{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.unifi
  ];
 
  services.unifi.enable = true;
  services.unifi.openFirewall = true;
  services.unifi.unifiPackage = pkgs.unifi;
  services.unifi.mongodbPackage = pkgs.mongodb-ce;
}
