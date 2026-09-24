# Omac

A keyboard-driven tiling window manager for macOS. It brings
[Omarchy](https://omarchy.org)'s window keys to the Mac: windows tile
themselves, never overlap, and move with the keyboard.

This repository holds the **downloads**. The source code is private.

## Install

Paste this into **Terminal** (Applications → Utilities → Terminal):

```bash
curl -fsSL https://raw.githubusercontent.com/evanscastonguay/omac/main/install.sh | bash
```

Omac then starts and macOS asks you to let it control your windows. Click
**Open System Settings** and turn **Omac** on under **Privacy & Security →
Accessibility**. No hotkey works until you do.

Check it with `omac status` in a new Terminal window — `accessibility` and
`tap` should both be `true`.

**Needs** a Mac with Apple silicon and macOS 14 or later. Nothing else — no
Homebrew, no developer tools.

<details>
<summary><b>What the install command does</b></summary>

<br>

1. Downloads the latest release from this repository.
2. Checks its SHA-256 checksum, so a broken download is never installed.
3. Checks that the app is signed with Omac's Developer ID (team `5GB46V9555`),
   so a modified app is never installed.
4. Removes any old copy in `/Applications` — two copies conflict and stop every
   hotkey. If that copy belongs to another user, macOS asks for your password.
5. Installs `Omac.app` to `~/Applications` and the `omac` command to
   `~/.local/bin`, adding that folder to your `PATH` in your shell's startup file.
6. Starts Omac and, on a first install, sets it to start when you log in.

You can read the script before running it:

```bash
curl -fsSL https://raw.githubusercontent.com/evanscastonguay/omac/main/install.sh -o install.sh
less install.sh
bash install.sh
```

</details>

<details>
<summary><b>Install without Terminal</b></summary>

<br>

1. Download **`Omac-arm64.zip`** from the
   [latest release](https://github.com/evanscastonguay/omac/releases/latest) and open it.
2. Drag **`Omac.app`** from the folder that appears into your **Applications** folder.
3. Open Omac. macOS says it *cannot verify* it — click **Done**, then open
   **System Settings → Privacy & Security**, scroll down, and click
   **Open Anyway** next to Omac.

This way does not set up the `omac` command; run the Terminal command above
later if you want it. It also does not start Omac at login — choose **Launch at login** from Omac's
menu-bar icon for that.

That extra step happens because Omac is signed but not notarized by Apple, and
macOS checks files downloaded by a web browser. Files downloaded by the Terminal
command above are not checked this way, so it has no such step.

</details>

## Update

Run the install command again. Your settings and your Accessibility permission
are kept.

To install a specific version instead of the latest:

```bash
curl -fsSL https://raw.githubusercontent.com/evanscastonguay/omac/main/install.sh | bash -s -- v1.4.4
```

## Uninstall

```bash
omac login off; omac quit
rm -rf ~/Applications/Omac.app ~/.local/bin/omac
```

Your settings stay in `~/.config/omac` and `~/.local/state/omac`; delete those
too to remove everything. The installer also added one line marked
`# Added by the Omac installer` to your shell's startup file (`~/.zshrc` by
default), which you can delete. Remove Omac from **System Settings → Privacy &
Security → Accessibility** as well.

## Why "signed but not notarized"?

Omac is signed with a Developer ID certificate, so macOS knows who built it and
that it has not been changed since. It is not notarized — notarization is a
separate scan by Apple that needs a paid Apple Developer membership. The
installer checks the signature itself before installing.
