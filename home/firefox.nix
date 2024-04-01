{ ... }:

{
  # make Firefox use xinput2 by setting the MOZ_USE_XINPUT2 environment variable.
  # This improves touchscreen support and enables additional touchpad gestures.
  # It also enables smooth scrolling as opposed to the stepped scrolling that Firefox
  # has by default.
  home.sessionVariables.MOZ_USE_XINPUT2 = "1";

  # Make Firefox use the KDE file picker.
  # Preferences source: https://wiki.archlinux.org/title/firefox#KDE_integration

  # https://wiki.archlinux.org/title/firefox
  # https://discourse.nixos.org/t/combining-best-of-system-firefox-and-home-manager-firefox-settings/37721
  programs.firefox = {
    enable = true;
    policies = {
      Preferences = {
        # instruct Firefox to use the file picker offered by the
        # XDG Desktop Portal framework
        # The value 1 means "always".
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };
}