{ ... }:
let
  domain = "snuletek.org";
  secrets_file = "cert_${domain}";
  secrets_folder = "/var/lib/secrets";
in
{
  systemd.services.acme_secrets_oneshot_snuletek = {
    requiredBy = ["acme-${domain}.service"];
    before = ["acme-${domain}.service"];
    unitConfig = {
      ConditionPathExists = "!${secrets_folder}/${secrets_file}";
    };
    serviceConfig = {
      Type = "oneshot";
      UMask = 0077;
    };

    script = ''
      mkdir -p ${secrets_folder}
      chmod 755 ${secrets_folder}
      echo "CLOUDFLARE_DNS_API_TOKEN=\"\"" > ${secrets_folder}/${secrets_file}
      chown root:root ${secrets_folder}/${secrets_file}
      chmod 400 ${secrets_folder}/${secrets_file}
    '';
  };
  
  security.acme = {
    acceptTerms = true;
    # Use staging server
    # defaults.server = "https://acme-staging-v02.api.letsencrypt.org/directory";
    defaults.email = "mikkel+acme@mikkel.cc";
    certs."${domain}" = {
      domain = "*.${domain}";
      dnsProvider = "cloudflare";
      environmentFile = "${secrets_folder}/${secrets_file}";
      group = "nginx";
    };
  };
}
