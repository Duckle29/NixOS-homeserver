{ options, config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.sopel;
  configFile = lib.generators.toINI {} cfg.settings;
in 
{
  options.services.sopel = {
    enable = mkEnableOption "sopel";
    settings = mkOption {
      type = (pkgs.formats.ini {}).type;
      default = {};
      description = ''
        Configuration for the bot.
        See <link xlink:href="https://sopel.chat/docs/run/configuration" /> for settings.
      '';
    };
  };

  config = mkIf cfg.enable {
    
    users.users.sopel = {
      description = "Sopel IRC bot user";
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/sopel";
    };
    
    services.sopel.settings.core = {
      homedir = mkDefault "/var/lib/sopel";
      pid_dir = mkDefault "/var/lib/sopel/pid_dir";
      logdir = mkDefault "/run/";
      nick = mkDefault "SopelBot";
      host = mkDefault "irc.libera.chat";
      use_ssl = mkDefault "true";
      port = mkDefault "6697";
      owner = mkDefault "dgw";
      channels = mkDefault ''
        \"##botspam\"
      '';
    };  

    systemd.services.sopel = {
      description	= "Sopel IRC bot";
      wantedBy	= [ "multi-user.target" ];
      after	= [ "network.target" ];

      serviceConfig = {
        Type = "simple";
        User = "sopel";
        RuntimeDirectory = "sopel";
        StateDirectory = "sopel";
        LogsDirectory = "sopel";
        PIDFile = "/run/sopel/sopel.pid";
        ExecStart = "${cfg.package}/bin/sopel -c ${configFile}";
        Restart = "on-failure";
        RestartSec = "30";
        # Environment = "LC_ALL=en_US.UTF-8 SOPEL_CONFIG_DIR=/etc/sopel";
      };
    };
  };
}

