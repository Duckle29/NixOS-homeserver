{ config, pkgs, ... }:
{
  config = {
    environment.systemPackages = [
      pkgs.thelounge
    ];

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  
    services.thelounge = {
      enable = true;
      public = false;
      port = 9000;

      extraConfig = {
        reverseProxy = true;
        maxHistory = 10000;
        https = {
          enable = false;
        };

        theme = "morning";
        prefetch = true;
        prefetchStorage = true;
        prefetchMaxImageSize = 10240;

        fileUpload = {
          enable = true;
          maxFileSize = 102400;
          baseUrl = "https://lounge.mikkel.cc/uploads/";
        };
        leaveMessage = "Poof goes the quack";

        messageStorage = [ "sqlite" ];
        storagePolicy = {
          enabled = false;
        };
      };
    };
  };  
}
