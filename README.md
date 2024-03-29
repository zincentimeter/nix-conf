# Shinri's NixOS Configuration

## Points of inconvenience

- [x] vscode cannot input chinese (use Xwayland fix this)
- [x] numlock and capslock (change to Keyboard(Chinese) fix this)
- [ ] chinese plasma 6 (Bad Locale may also trigger the problem of numlock and capslock)
- [x] manage secrets with sops-nix (cannot directly introduced in nix config)
- [x] laptop caps cannot be identified correctly on login screen (don't hint sddm to use wayland)

## Future Improvements

- [ ] Declarative Plasma 6
- [ ] Declarative _2raya config (or sin_box?)

## Note

- Private items are skipped by

    ```fish
    git update-index --skip-worktree $file
    ```

    To cancel, `--no-skip-worktree`

- To switch to the private items again,

    1. update-index on all skipped work tree files as `no-skip-worktree`
    2. stash them
    3. git checkout
    4. stash pop
    5. edit on private branch
    6. commit
    7. `git checkout main`
    8. `git checkout private <file>`
    9. update-index with `skip-worktree`