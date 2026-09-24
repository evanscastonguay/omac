# Omac

A tiling window manager for macOS. Your windows arrange themselves side by
side, never overlap, and you move between them with the keyboard. It brings
[Omarchy](https://omarchy.org)'s window keys to the Mac.

## Install

**Needs** a Mac with Apple silicon and macOS 14 or later. Nothing else — no
Homebrew, no developer tools, no GitHub account.

**1. Paste this into Terminal** (⌘ Space, type *Terminal*, press Return):

```bash
curl -fsSL https://raw.githubusercontent.com/evanscastonguay/omac/main/install.sh | bash
```

If an old copy of Omac is in `/Applications`, Terminal asks for your Mac
password to remove it. Two copies conflict.

**2. Let Omac control your windows.** A macOS dialog appears: click **Open
System Settings**, then turn **Omac** on under **Privacy & Security →
Accessibility**. Omac notices within two seconds — no restart needed.

**3. Check it.** Open a **new** Terminal window and run:

```bash
omac status
```

You should see:

```
accessibility        true
tap                  true
```

Done. Omac also starts by itself when you log in.

## Try it

The Omac key is **Left ⌘**. Right ⌘ still works as a normal ⌘.

| Press | What happens |
|---|---|
| Left ⌘ **K** | Shows every shortcut |
| Left ⌘ **Return** | Opens a terminal |
| Left ⌘ **← ↑ → ↓** | Moves between windows |
| Left ⌘ **Shift ← ↑ → ↓** | Swaps a window with its neighbour |
| Left ⌘ **1 … 0** | Switches to workspace 1–10 |
| Left ⌘ **Shift 1 … 0** | Sends the window to that workspace |
| Left ⌘ **Shift Space** | Lets a window float freely |

**To stop it:** Left ⌘ **Ctrl ⌥ Esc** pauses the tiling; press it again to
resume. `omac quit` quits Omac.

## If something is wrong

| You see | What to do |
|---|---|
| Left ⌘ shortcuts do nothing | Omac needs the Accessibility permission (step 2). `omac status` says `accessibility false` until it has it. |
| `omac: command not found` | Open a **new** Terminal window. The installer set this up for new windows only. |
| *"Apple could not verify Omac…"* | Omac was downloaded with a web browser. Use the Terminal command in step 1 instead. |
| `Omac was not installed: …` | The message says why. Run the command again; if it happens again, send the full output. |

**Reporting a problem:** send the output of `omac status` and what you pressed.

## Update

Run the install command from step 1 again. Your settings and the Accessibility
permission are kept.

## Uninstall

```bash
omac login off; omac quit
rm -rf ~/Applications/Omac.app ~/.local/bin/omac
```

Then remove Omac from **System Settings → Privacy & Security → Accessibility**.
Your settings stay in `~/.config/omac` and `~/.local/state/omac` — delete them to
remove everything. The installer may also have added two lines, starting with
`# Added by the Omac installer`, to `~/.zshrc`; you can delete them.

<details>
<summary><b>What the install command does</b></summary>

<br>

1. Downloads the latest release from this repository.
2. Checks its SHA-256 checksum, so a broken download is never installed.
3. Checks the app is signed with Omac's Developer ID (team `5GB46V9555`), so a
   modified app is never installed.
4. Removes an old copy in `/Applications`, if there is one.
5. Installs `Omac.app` to `~/Applications` and the `omac` command to
   `~/.local/bin`, adding that folder to your `PATH` if it is not already there.
6. Starts Omac. On a first install it also turns on *start at login*.

To read the script before running it:

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
2. Drag **`Omac.app`** from the folder that appears into **Applications**.
3. Open Omac. macOS says it *cannot verify* it — click **Done**, open **System
   Settings → Privacy & Security**, scroll down and click **Open Anyway**.
4. Continue with step 2 above.

This way does not set up the `omac` command or start at login. Choose **Launch
at login** from Omac's menu-bar icon for that.

</details>

<details>
<summary><b>Why "signed but not notarized"?</b></summary>

<br>

Omac is signed with a Developer ID, so macOS knows who built it and that it has
not been changed since — the installer checks that before installing. It is not
*notarized*, a separate Apple scan that needs a paid Apple Developer
membership. macOS only asks about that for files downloaded with a web browser,
which is why the Terminal command has no extra step.

</details>

---

<sub>Tested with the exact command above on an Apple-silicon Mac running macOS
26.3.1, on 2026-09-24: installed 1.4.4, signature verified, `accessibility true`,
`tap true`.</sub>
