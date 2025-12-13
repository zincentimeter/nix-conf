{ pkgs, config, ... }:

{
  programs.fish = {
    enable = true;
    plugins = [
      # Enable a plugin (here grc for colorized command output) from nixpkgs
      { name = "forgit"; src = pkgs.fishPlugins.forgit.src; }
      { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "bass"; src = pkgs.fishPlugins.bass.src; }
      # Manually packaging and enable a plugin
      #   {
      #     name = "z";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "jethrokuan";
      #       repo = "z";
      #       rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
      #       sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      #     };
      #   }
    ];
  };

  home.packages = with pkgs; [
    # generic colorizer
    grc
  ];

  programs.fzf = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    enableBashIntegration = config.programs.bash.enable;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.shellAliases = {
    # abbr
    jr       = "journalctl";
    jrf      = "journalctl --follow";
    jru      = "journalctl --unit";
    jrfu     = "journalctl --follow --unit";
    jruser   = "journalctl --user";
    jruserf  = "journalctl --user --follow";
    jruserfu = "journalctl --user --follow --unit";
    jrsudo   = "sudo journalctl";
    sc = "systemctl";
    scuser = "systemctl --user";
    scsudo = "sudo systemctl";
    # semantic
    unit = "journalctl --unit";
    stat = "systemctl status";
    restart = "sudo systemctl restart";
    start = "sudo systemctl start";
    stop = "sudo systemctl stop";
  };
}
