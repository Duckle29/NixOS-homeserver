{ config, pkgs, ... }:
{
  fileSystems."/mnt/hexos" = {
    device = "hexos1.home:/mnt/HDDs/nix_uservices";
    fsType = "nfs";
  };
}
