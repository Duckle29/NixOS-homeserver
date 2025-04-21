{ config, lib, pkgs, ... }:
  
{
  environment.systemPackages = [
    pkgs.deluged
  ];

  users.users.deluge.extraGroups= [ "keys" ];

  networking.firewall.allowedTCPPorts = [ 58846 ];

  systemd.tmpfiles.rules = [
    "d /mnt/hexos/deluged 0755 3000 3000"
  ];

  services.deluge = {
    enable = true;
    declarative = true;
    openFirewall = true;
    config = {
      listen_ports = [ 6881 6889 ];
      download_location = "/mnt/hexos/deluged/";
      max_upload_speed = 25000;
      max_download_speed = 25000;
      max_upload_slots_global = 10;
      allow_remote = true;
      daemon_port = 58846;
      random_port = false;
    };
    authFile = "/var/src/secrets/deluge-auth";

    web = {
      enable = true;
      openFirewall = false; # Use a reverse proxy instead
      port = 8112;
    };
  };
}
