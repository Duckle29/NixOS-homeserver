{ pkgs, lib, config, ... }:
{
  config = {
    
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = [
      factorio-headless
    ];
  
    services.factorio = {
      enable = true;
      openFirewall = true;
      # extraSettingsFile = "/var/lib/secrets/factorio.json";
      saveName = "DuckCubed";
      game-name = "DuckCubed";
      description = "A German and a Dane walks in to a biter";
      admins = [ "duckle29" "thehexacube" ];
      autosave-interval = 60;
      extraSettings = { auto_pause = true; };
      loadLatestSave = true;

      mods =
      let
        inherit (pkgs) lib;
        modDir = /opt/factorio/mods;
        modList = lib.pipe modDir [
          builtins.readDir
          (lib.filterAttrs (k: v: v == "regular"))
          (lib.mapAttrsToList (k: v: k))
          (builtins.filter (lib.hasSuffix ".zip"))
        ];
        modToDrv = modFileName:
          pkgs.runCommand "copy-factorio-mods" {} ''
             mkdir $out
             cp ${modDir + "/${modFileName}"} $out/${modFileName}
          ''
          // { deps = []; };
      in
        builtins.map modToDrv modList;
    };
  };
}
