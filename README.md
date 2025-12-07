# Shinri's NixOS Configuration

## 1. Points of inconvenience

- [x] when switching light/dark from colorschemeswapper-plasmoid, cannot change for kitty and neovim.
  - Kitty now [supports](https://sw.kovidgoyal.net/kitty/kittens/themes/#change-color-themes-automatically-when-the-os-switches-between-light-and-dark) auto changing color.
  - [Claude](https://claude.ai/chat/22eee9e5-3a23-49bb-9503-4b0f9464db27)
  - useful commands:
  ```sh
  # get color scheme for now
  kreadconfig5 --group "General" --key "ColorScheme"
  # know when to trigger the change of shell
  dbus-monitor --session 'type=signal,interface=org.kde.KGlobalSettings,member=notifyChange'
  ```

- [x] (deprecated) ~~vscode cannot input chinese (patched with `--enable-wayland-ime`)~~
- [x] (fixed) ~~numlock and capslock (change to Keyboard(Chinese) fix this)~~
- [x] (fixed) ~~chinese plasma 6~~ (logout to make it enable)
- [x] (reached) manage secrets with sops-nix (cannot directly introduced in nix config)
- [x] (fixed) ~~ThinkPad Thunderbolt Dock 3 cannot connect smoothly~~ (fix: sbctl)
- [x] (worked-around) The airplane's dns cannot resolve Tailscale (solved by disable tailscale dns functionality)

## 2. Improvements

- [x] Declarative Plasma 6
  - [x] declare plasmashell and default theme (`plasma-org.kde.plasma.desktop-appletsrc` and `kwinoutputconfig.json`)
  - [ ] persist dolphin explorer initial setup
- [x] Workable cinny-desktop, still broken for now (24/08/23) nixpkgs#334805
- [ ] Declarative _2raya config (or sin_box?, or dae?)
- [x] Declarative home
    - [x] ~~vscode~~ (disabled, now use vim)
    - to be updated...
- [x] mount / on tmpfs with `impermanence` on to control what is permanent
- [x] Broken OAMA v0.14 conf to Outlook, v0.16 fails to build
  - Fixed git-send-email with Outlook.
  - This relates to git-send-email, crucial
    - git-send-email relates to submission to stratosphere (including one neovim plugin addition and a update for now)
- [x] ghostty cursor is so BIG in KDE...

## Appendix A. Notes on public

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

## Appendix B. A Journey on "tmpfs on root"

> ( machine translation is used )

The process of setting up tmpfs on the root in NixOS is full of pitfalls.
Some of these issues are due to NixOS itself,
but most arise from the combination of various requirements.

1. When only the `/home` and `/nix` directories are available,
   `nixos-enter` (hereafter referred to as enter) fails to work on `/mnt`,
   giving a "not a NixOS installation" error.
   The solution is to create an empty file in `/mnt/etc/NIXOS`.

2. The issue with `nixos-rebuild` (hereafter referred to as `rebuild`) is that
   it uses the `$SUDO_USER` variable and then fails with a PAM authentication error.
   > The solution is to delete this environment variable.

3. Flake-based `rebuild` fails due to a missing git.
   > The solution is to directly open a nix-shell with git (e.g., `nix-shell -p git`).

4. Because `enter` sets the environment's hostname to nixos,
   running rebuild directly results in a flake not found error.
   > The solution is to either change the hostname or the flake (e.g., `hostname <your_name>`).

5. When using the impermanence module, you must be especially careful.
   If you change the directory specified in the configuration
   (e.g., from `/persist` to `/nix/persist`),
   the mounts managed by impermanence will fail since enter uses your existing system build.
   > Necessary files during the rebuild process must be manually copied or mounted.

6. When configuring secure boot during the `rebuild` process, 
   due to the issue mentioned in point 5,
   the lanzaboote module fails to load the files required to sign the target kernel,
   leading to a failed build that cannot be installed into the bootloader.
   > The solution is:
   ```sh
   cp -ar /nix/persist/etc/secureboot/ /etc/. # -a preserves permissions information
   ```

   Incidentally, this took me nearly an hour.
   The error messages were useless,
   stating that a file was missing but not specifying which one.
   I had to use `strace` to check each one,
   and during the process, the LiveCD crashed, so I had to redo points 1-6 all over again.

7. The system cannot handle the default option when mounting `tmpfs`,
   causing it to freeze at NixOS stage 1.
   > The solution is to remove the default option from the disko module configuration.
   This also took me over an hour due to the difficulty of using the LiveCD
   to change the configuration.
   Points 1-6 had to be addressed, and the LiveCD loads very slowly.

8. During enter, since I use the sops-nix module to load encrypted information,
   and due to the issue mentioned in point 5 where `~/.ssh` cannot be loaded, an error occurs.
   Although I can still enter the `chroot` environment with `enter`,
   I configure GitHub API access with sops-nix via `nix.conf`,
   which could cause problems if internet access is needed.
   > The solution is to manually copy the keys over:
   ```sh
   cp -ar /nix/persist/home/shinri/.ssh/ /home/shinri
   ```

This has been one of the most "Nix exercise" I've ever had.
It took over a month from the initial idea to full implementation.
Adding to that, this week, I spent time troubleshooting `/var`, `/etc`, `~/.config`, and `~/.local`,
and also tuning with the `plasma-manager` module rarely used before.
It was like a ripple effect.
However, I'm glad I finally moved everything to this setup smoothly
and avoided reinstalling the system.
