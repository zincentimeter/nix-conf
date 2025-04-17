{ pkgs, config, ... }:

{
  # Account settings
  accounts.email.accounts = {
    outlook = {
      realName = "Shinri Kosame";
      address = "zincentimeter@outlook.com";
      userName = "zincentimeter@outlook.com";
      primary = true;
      passwordCommand = "${pkgs.oama}/bin/oama access zincentimeter@outlook.com";

      # https://support.microsoft.com/en-us/office/pop-imap-and-smtp-settings-for-outlook-com-d088b986-291d-42b8-9564-9c414e2aa040
      imap = {
        host = "outlook.office365.com";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "smtp.office365.com";
        port = 587;
        tls.enable = true;
        tls.useStartTls = true;
      };
      thunderbird = {
        enable = true;
        settings = id: {
          # https://github.com/nix-community/home-manager/issues/4988
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };
      msmtp.enable = true;
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles."default_profile" = {
      isDefault = true;
    };
  };

  # to bridge oauth2 provider (oama) and git-sendemail
  home.packages = [ pkgs.msmtp ];
  # use customized msmtp/config
  xdg.configFile."msmtp/config".text = with config.accounts.email.accounts.outlook; ''
    account outlook
    auth xoauth2
    from ${address}
    user ${address}
    host ${smtp.host}
    port ${toString smtp.port}
    passwordeval ${pkgs.oama}/bin/oama access ${address}
    tls on
    tls_starttls on
    tls_trust_file ${smtp.tls.certificatesFile}
    account default : outlook
  '';

  xdg.configFile."oama/config.yaml".text = builtins.toJSON {
    encryption.tag = "KEYRING";
    services.microsoft = {
      client_id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
      auth_endpoint = "https://login.microsoftonline.com/common/oauth2/v2.0/devicecode";
    };
  };
}
