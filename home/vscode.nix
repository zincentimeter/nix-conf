{ config, pkgs, ... }:

let
  vscode-utils = pkgs.vscode-utils;
  existing-extensions = pkgs.vscode-extensions;
  # continueConfigFile = ".continue/config.json";
  # continueConfigPath = "${config.home.homeDirectory}/${continueConfigFile}";
in
{

  programs.vscode = {
    enable = false;
    package = pkgs.vscode.override { commandLineArgs = "--enable-wayland-ime"; };

    mutableExtensionsDir = false;
    extensions = with existing-extensions; [
      bbenoist.nix
    ] ++ vscode-utils.extensionsFromVscodeMarketplace [
      # Git-related
      {
        name = "gitless";
        publisher = "maattdd";
        version = "11.7.2";
        sha256 = "rYeZNBz6HeZ059ksChGsXbuOao9H5m5lHGXJ4ELs6xc=";
      }
      # Nix-related
      {
        name = "nix-ide";
        publisher = "jnoortheen";
        version = "0.3.1";
        sha256 = "05oMDHvFM/dTXB6T3rcDK3EiNG2T0tBN9Au9b+Bk7rI=";
      }
      # Coq-related
      {
        name = "vscoq";
        publisher = "maximedenes";
        version = "2.1.2";
        sha256 = "cjpDKrn1BhC66tNJM86cMuLrCWgxen+MfSIZ8cmzIDE=";
      }
      # Remote-dev-related
      {
        name = "remote-ssh";
        publisher = "ms-vscode-remote";
        version = "0.110.2024030815";
        sha256 = "ZgU1IxnZDEF/H6O4d86qjCysK/deiLlHDUCbLIvcT7E=";
      }
      {
        name = "remote-server";
        publisher = "ms-vscode";
        version = "1.6.2024032009";
        sha256 = "tCMWfhnL7+rC9IQV3Umi/IyMvefd/KPud+oigtkBEJU=";
      }
      # C-related
      {
        name = "cpptools";
        publisher = "ms-vscode";
        version = "1.20.0";
        sha256 = "hnLIvqKXCwrVCPCX5zriZWf5om0m073qK19gubvgaq8=";
        arch = "linux-x64";
      }
      # {
      #   name = "vim";
      #   publisher = "vscodevim";
      #   version = "1.27.2";
      #   sha256 = "O5G4yhvD2HvKb4Vbvr1v20nMEQq88f5RE+X50bZvr1Q=";
      # }
    ] ++ [
      # Copilot
      # Refer to:
      # 1. https://github.com/NixOS/nixpkgs/pull/289289/files
      # 2. https://github.com/continuedev/continue/issues/821
      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "continue";
          publisher = "Continue";
          version = "0.9.101";
          sha256 = "2lZOiK2c2mnJ79QN4+bWAyyM6i8YNdX1L881XlMn4Gg=";
          arch = "linux-x64";
        };
        nativeBuildInputs = [ pkgs.autoPatchelfHook ];
        buildInputs = [ pkgs.stdenv.cc.cc.lib ];
        postInstall = ''
          cd "$out/$installPrefix"
          substituteInPlace "out/extension.js" \
            --replace-fail 'await showTutorial();' '//await showTutorial();'
        '';
      })
    ];

    userSettings = {
      "git.confirmSync" = false;
      "nix.serverPath" = "nil";
      "nix.enableLanguageServer" = true;
      "nix.serverSettings"."nil"."formatting"."command" = ["${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"];
      "workbench.colorTheme" = "Default Light Modern";
      "editor.fontFamily" = "'Red Hat Mono', 'Droid Sans Mono', 'monospace', monospace";
      "files.autoSave" = "afterDelay";
      "workbench.tree.indent" = 16;
      "continue.enableTabAutocomplete" = true;
      "continue.telemetryEnabled" = false;
    };
  };

}
