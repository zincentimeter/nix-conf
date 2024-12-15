{ config, sops, ... }:

{
  # Account settings
  accounts.email.accounts = {
    outlook = {
      realName = "Shinri Kosame";
      address = "zincentimeter@outlook.com";
      userName = "zincentimeter@outlook.com";
      primary = true;

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
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles."default_profile" = {
      isDefault = true;
    };
  };

  # Oama client_{id,secret} of Outlook is acquired from:
  # https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationsListBlade
  # xdg.configFile."oama/config.yaml".source = config.lib.file.mkOutOfStoreSymlink sops.templates."oama_config.yaml".path;
}
