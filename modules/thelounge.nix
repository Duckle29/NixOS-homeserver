{ config, pkgs, lib, ... }:
let
  thelounge = pkgs.thelounge.overrideAttrs {
    version = "4.4.3";
      src = lib.fetchFromGitHub {
      owner = "thelounge";
      repo = "thelounge";
      rev = "v4.4.3";
      hash = "";
    };
  };
in
{
  config = {
    environment.systemPackages = [
      thelounge
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
          enabled = true;
          maxAgeDays = 30;
          deletionPolicy = "statusOnly";
        };
      };
    };
  };  
}
