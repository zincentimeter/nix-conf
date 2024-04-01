{ config, pkgs, ... }:

let
  vscode-utils = pkgs.vscode-utils;
  existing-extensions = pkgs.vscode-extensions;
  continueConfigFile = ".vscode/.continue.json";
  continueConfigPath = "${config.home.homeDirectory}/${continueConfigFile}";
in
{

  programs.vscode = {
    enable = true;
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
        version = "1.19.8";
        sha256 = "fY9ada+pQpk+RgzbmPe5FgOSdsxz0GpHwRnjjvd8CrI=";
      }
      # Copilot
      {
        name = "continue";
        publisher = "Continue";
        version = "0.9.100";
        sha256 = "ITUmEYuHD2x8x4u0nZwiPobOcNW2KgC5OSHUjzWagT8=";
      }
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
      "continue.remoteConfigServerUrl" = "file://${continueConfigPath}";
    };
  };

  # Configure continue extension to use ollama
  home.file = {
    ${continueConfigFile}.text = builtins.toJSON {
      "models" = [
        {
          "title" = "Ollama";
          "provider" = "ollama";
          "model" = "codellama";
          "completionOptions" = {};
        }
      ];
    };
  };
}
