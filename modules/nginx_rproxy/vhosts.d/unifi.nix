{config, pkgs, ...}:

{
  services.nginx.virtualHosts."devubnt.mikkel.cc_inform" = {
    useACMEHost = "mikkel.cc";
    serverName = "devubnt.mikkel.cc";
    serverAliases = ["ubnt.mikkel.cc"];

    locations = {
      "/inform" = {
        proxyPass = "http://127.0.0.1:8080/inform";
        extraConfig = ''
          access_log off;
          log_not_found off;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
	  			proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  				proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
      "/" = {
        return = "301 https://$host$request_uri";
      };
    };
  };

  services.nginx.virtualHosts."devubnt.mikkel.cc" = {
    useACMEHost = "mikkel.cc";
    onlySSL = true;
    serverAliases = ["ubnt.mikkel.cc"];

    locations = {
      "/" = {
        proxyPass = "https://127.0.0.1:8443/";
        extraConfig = ''
          proxy_set_header Host	$host;
	        proxy_set_header		X-Forwarded-Proto   $scheme;
	        proxy_intercept_errors  on;
	        proxy_http_version      1.1;
	        proxy_set_header 		Upgrade $http_upgrade;
		      proxy_set_header		Connection "Upgrade";
  		    proxy_set_header 		X-Real-IP $remote_addr;
          proxy_set_header 		X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
    };
  };
}
