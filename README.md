# Shinri's NixOS Configuration

## Points of inconvenience

- [x] vscode cannot input chinese (patched with `--enable-wayland-ime`)
- [x] numlock and capslock (change to Keyboard(Chinese) fix this)
- [x] chinese plasma 6 (logout to make it enable)
- [x] manage secrets with sops-nix (cannot directly introduced in nix config)
- [x] laptop caps cannot be identified correctly on login screen (don't hint sddm to use wayland)
- [x] vlc / vlc via syncplay not working for nvidia gpu (offloading it solves this)
- [x] ThinkPad Thunderbolt Dock 3 cannot connect smoothly
- [x] The airplane's dns cannot resolve Tailscale (solved by disable tailscale dns functionality)

## Future Improvements

- [ ] Declarative Plasma 6
- [ ] Declarative _2raya config (or sin_box?)
- [ ] Declarative home
    - [x] vscode
    - to be updated...
- [ ] mount / on tmpfs with `impermanence` on to control what is permanent

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

