{ pkgs, lib, config, ... }:
{
  users.groups.sftponly = {};
  users.users.otaserv = {
    home = "/var/lib/otaserv";
    createHome = false;
    isSystemUser = true;
    group = "sftponly";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC+Z5ULcei+UAC+oznrHOnEmEtYAwLU9hqaMydDfTQAx ghActions"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/otaserv/inkli 0755 otaserv sftponly"
    "d /var/lib/otaserv 0755 root root"
  ];

  services.openssh.extraConfig = ''
    Match User otaserv
      ForceCommand internal-sftp
      ChrootDirectory /var/lib/otaserv
  '';

  services.nginx.virtualHosts."otaserv.mikkel.cc" = {
    useACMEHost = "mikkel.cc";
    forceSSL = true;
    root = "/var/lib/otaserv";

    locations = {
      "/" = {
      };
    };
  };

}
