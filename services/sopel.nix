{ options, config, lib, pkgs, ...}:

let
  cfg = config.services.sopel;
  configFile = pkgs.writeText "sopel.cfg" (lib.generators.toINI {} cfg.settings);
in 
{
  options.services.sopel = {
    enable = lib.mkEnableOption "sopel";
    
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file used with the service, 
        This is intended to be used for secrets. 
        See <link xlink:href="https://sopel.chat/docs/run/cli#supported-environment-variables" />
        for how to use environment varibles to override settings.

        For example: 
        ```
        SOPEL_CORE_AUTH_USERNAME="SopelBot"
        SOPEL_CORE_AUTH_PASSWORD="hunter2"
        ```
      '';
    };

    settings = lib.mkOption {
      type = (pkgs.formats.ini {}).type;
      default = {};
      description = ''
        Configuration for the bot.
        See <link xlink:href="https://sopel.chat/docs/run/configuration" /> for settings.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    
    users.groups.sopel = {};

    users.users.sopel = {
      description = "Sopel IRC bot user";
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/sopel";
      group = "sopel";
    };
    
    services.sopel.settings.core = {
      homedir = lib.mkDefault "/var/lib/sopel";
      pid_dir = lib.mkDefault "/var/lib/sopel";
      logdir = lib.mkDefault "/var/log/sopel";
      nick = lib.mkDefault "SopelBot";
      host = lib.mkDefault "irc.libera.chat";
      use_ssl = lib.mkDefault "true";
      port = lib.mkDefault "6697";
      owner = lib.mkDefault "NickServ";
      channels = lib.mkDefault ''
        ''\n''\t"##botspam"
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
        PIDFile = "/var/lib/sopel/sopel.pid";
        #ExecStart = "${pkgs.python312Packages.sopel}/bin/sopel -c ${configFile}";
        ExecStart = "/run/current-system/sw/bin/sopel -c ${configFile}";
        Restart = "on-failure";
        RestartSec = "30";
        EnvironmentFile = cfg.environmentFile;
        # Environment = "LC_ALL=en_US.UTF-8 SOPEL_CONFIG_DIR=/etc/sopel";
      };
    };
  };
}

