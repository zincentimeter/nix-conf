{ ... }:

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
      thunderbird.enable = true;
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles."default_profile" = {
      isDefault = true;
    };
  };
}
