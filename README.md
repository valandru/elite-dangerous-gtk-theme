Copyright (C) 2026 Val. Licensed under GPL-3.0-or-later. See the [LICENSE](LICENSE) file.

# Elite Dangerous HUD

A GTK 3, GTK 4 / Libadwaita, and GNOME Shell theme based on the Elite Dangerous ship cockpit. First target is Ubuntu 24.04 / GNOME 46 / Libadwaita, plus GNOME Shell on GNOME 46. GTK 3 is included as a later pass. Icons stay Adwaita.

## Install

From this repository:

```bash
./install.sh
```

That symlinks the repo to `~/.local/share/themes/Elite-Dangerous-HUD`. It does not install fonts or extensions.

Replacing `~/.config/gtk-4.0/gtk.css` is off unless you opt in. Libadwaita reads that user file and does not load `gtk-theme` CSS, so Settings, Files, and other libadwaita apps stay on the stock stylesheet until you do one of these:

```bash
./install.sh --gtk4-user-css
```

or answer yes when `./install.sh` prompts on a terminal. If `~/.config/gtk-4.0/gtk.css` is a regular file, the script backs it up first. If it is already a symlink to this theme, it is left alone.

## Activate

GNOME Shell needs the [User Themes](https://extensions.gnome.org/extension/19/user-themes/) extension (`user-theme`) installed and enabled. The shell setting does nothing useful until that extension is on.

```bash
gsettings set org.gnome.desktop.interface gtk-theme "Elite-Dangerous-HUD"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.shell.extensions.user-theme name "Elite-Dangerous-HUD"
```

GNOME Tweaks can set the same values: Appearance for the GTK theme, and Shell once User Themes is enabled.

## Reload

Restart open GTK apps. On Wayland, log out and back in so the shell theme loads. On X11, Alt+F2, type `r`, and press Enter.

## Fonts

The installer does not install fonts. Rajdhani suits interface text, Orbitron suits titles, and Eurostile is an alternate display face. After you install one yourself, you can point GNOME at it:

```bash
gsettings set org.gnome.desktop.interface font-name "Rajdhani 11"
```

## What v1 styles

Header bars, buttons, entries, lists, and cards go to a 0–2px HUD. Checked switches are orange with a void slider. Green is only for success and systems-nominal banners. Checkboxes are 1px; radios are a circular reticle.

Libadwaita still paints `avatar` and `spinner` as circles, and `button.circular` stays round. The shell volume handle is a circle because GNOME Shell draws it with an arc. Those are called out in the stylesheets.
