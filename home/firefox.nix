{ ... }:

{
  # make Firefox use xinput2 by setting the MOZ_USE_XINPUT2 environment variable.
  # This improves touchscreen support and enables additional touchpad gestures.
  # It also enables smooth scrolling as opposed to the stepped scrolling that Firefox
  # has by default.
  home.sessionVariables.MOZ_USE_XINPUT2 = "1";

  # Make Firefox use the KDE file picker.
  # Preferences source: https://wiki.archlinux.org/title/firefox#KDE_integration
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };
}