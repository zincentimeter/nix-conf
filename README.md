# Shinri's NixOS Configuration

## Points of inconvenience

- [x] vscode cannot input chinese
- [ ] numlock
- [ ] chinese plasma 6
- [x] manage secrets with sops-nix
- [x] laptop caps cannot be identified correctly on login screen

## Future Improvements

- [ ] Declarative Plasma 6
- [ ] Declarative _2raya config (or sin_box?)

## Note

- Private items are skipped by

    ```fish
    git update-index --skip-worktree $file
    ```

    To cancel, `--no-skip-worktree`