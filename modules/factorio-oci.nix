{ pkgs, lib, config, ... }:
{

  networking.firewall.allowedUDPPorts = [ 34197 ];

  users.groups.factorio = {};
  users.users.factorio = {
    home = "/var/lib/factorio_oci";
    createHome = true;
    uid = 845;
    isSystemUser = true;
    group = "factorio";
  };

  virtualisation.oci-containers.containers = {
    factorio = {
      image = "docker.io/factoriotools/factorio:2.0.9";
      autoStart = true;
      ports = [
        "34197:34197/udp"
      ];
      volumes = [
        "/var/lib/factorio_oci:/factorio"
      ];
      environment = {
        SAVE_NAME = "cubular";
      };
      #extraOptions = [ "--restart=unless-stopped" ];
    };
  };
}
