# Shinri's NixOS Configuration

## Points of inconvenience

- [x] (deprecated) ~~vscode cannot input chinese (patched with `--enable-wayland-ime`)~~
- [x] (fixed) ~~numlock and capslock (change to Keyboard(Chinese) fix this)~~
- [x] (fixed) ~~chinese plasma 6~~ (logout to make it enable)
- [x] (reached) manage secrets with sops-nix (cannot directly introduced in nix config)
- [x] (fixed) ~~ThinkPad Thunderbolt Dock 3 cannot connect smoothly~~ (fix: sbctl)
- [x] (worked-around) The airplane's dns cannot resolve Tailscale (solved by disable tailscale dns functionality)

## Improvements

- [x] Declarative Plasma 6
- [ ] Declarative _2raya config (or sin_box?)
- [x] Declarative home
    - [x] ~~vscode~~ (disabled, now use vim)
    - to be updated...
- [x] mount / on tmpfs with `impermanence` on to control what is permanent

## Notes on public

> I mainly focus on my private repo.
> So the public repo of my nix-conf will be a cherry-picked version.
> The .gitskip will serve as a notice of skipped files, not serving functionaly.
> The following routine is deprecated.

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

