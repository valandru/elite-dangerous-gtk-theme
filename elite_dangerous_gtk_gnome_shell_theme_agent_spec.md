# Project Specification: Elite Dangerous Ship HUD Theme for Ubuntu (GNOME / GTK)

## 1. Objective & Agent Instructions
You are tasked with building a complete, modular, production-ready **GTK 3**, **GTK 4 / Libadwaita**, and **GNOME Shell** desktop theme for Ubuntu inspired by the holographic ship cockpit HUD in *Elite Dangerous* (Lakon Spaceways / Core Dynamics / Faulcon DeLacy aesthetic).

The first version targets **Ubuntu 24.04 / GNOME 46 / Libadwaita as shipped there**. GTK 3 and Ubuntu 22.04 (GNOME 42) stay listed in this spec and in the file tree, but they are a later pass and are not the first acceptance target. GNOME Shell selectors differ across GNOME versions; do not assume a selector from one GNOME release matches another.

### Core Agent Directives
1. **Architecture:** Build the theme in this repository, `elite-dangerous-gtk-theme`, at the repository root. Do not use `~/Projects/my-ubuntu-theme`. Do not add a `my-ubuntu-theme/` wrapper. `src/_palette.css` is the shared token source of truth. GTK `@define-color` and GNOME Shell CSS are separate: each stylesheet gets its own copy of the values in the form that engine accepts. Do not claim one file is imported by both.
2. **Compatibility:** First acceptance is GTK 4 / Libadwaita on Ubuntu 24.04 (GNOME 46) and GNOME Shell on GNOME 46. GTK 3 and Ubuntu 22.04 (GNOME 42) are a later pass. Shell selectors differ across GNOME versions.
3. **Automation:** `install.sh` symlinks this repository root to `~/.local/share/themes/Elite-Dangerous-HUD`. Replacing `~/.config/gtk-4.0/gtk.css` is optional and off by default (flag or prompt). GNOME Shell needs the User Themes extension. Fonts are recommendations only; do not install them.
4. **No Soft Pill Shapes:** Libadwaita `@define-color` overrides are required. Some radii stay rounded because they are not fully overridable from `gtk.css`. The v1 goal is a sharp HUD (`border-radius: 0px` to `2px`) on headerbars, buttons, entries, lists, and cards.
5. **Icons:** v1 uses Adwaita. Custom HUD icons are a second iteration and are out of scope. Do not add icon artwork.
6. **Build order:** Palette and `index.theme`, then GTK 4 for 24.04, then GNOME Shell, then GTK 3, then `install.sh`. Details are in section 3.

---

## 2. Visual & Design Language

### A. Color Palette Tokens
`src/_palette.css` is the shared token source of truth for the exact values below. GTK `@define-color` and GNOME Shell CSS are separate. Each stylesheet gets its own copy of these values in the form that engine accepts:

* `gtk-3.0/gtk.css` and `gtk-4.0/gtk.css` each contain their own `@define-color` copy.
* `gnome-shell/gnome-shell.css` contains its own copy as literal hex / rgba colors. Shell CSS does not accept GTK `@define-color`.

Do not claim `src/_palette.css` is imported by both GTK and GNOME Shell. Edit the palette file first, then copy the values into the stylesheet you are writing.

| Token Name | Hex / RGBA Value | Semantic Role & Cockpit Metaphor |
| :--- | :--- | :--- |
| `hud_void` | `#080A0C` | Deep space / primary window background & recessed troughs |
| `hud_panel` | `#0D1115` | Canopy panels: headerbars, sidebars, popovers, top shell bar |
| `hud_surface` | `#141A21` | Elevated interactive surfaces, cards, hovered rows |
| `hud_orange` | `#FF7100` | Primary HUD amber: active borders, titles, progress fills, toggles |
| `hud_orange_bright` | `#FF9E44` | Active hover highlights & high-emphasis telemetry |
| `hud_orange_dim` | `rgba(255, 113, 0, 0.25)` | Structural 1px dividers, inactive borders, subtle button fills |
| `hud_orange_glow` | `rgba(255, 113, 0, 0.45)` | Holographic `box-shadow` outer/inner glow |
| `hud_cyan` | `#00D8FF` | Target lock / focus accent: focused inputs, suggested actions, sliders |
| `hud_cyan_dim` | `rgba(0, 216, 255, 0.20)` | Focused input glow & secondary selection highlights |
| `hud_red` | `#FF2A00` | Thermal overload / destructive actions: close window, delete, alerts |
| `hud_green` | `#00E676` | Success and "systems nominal" banners. Not the default switch. |
| `hud_text` | `#FFB067` | Standard body & widget foreground text (warm amber) |
| `hud_text_bright` | `#FFE2C4` | High-contrast active tab/row text & hovered labels |
| `hud_text_dim` | `#7A5234` | Disabled widgets, placeholders, unfocused headerbar elements |

### B. Typography & Geometry Rules
* **Corner Radius:** `2px` max for buttons, inputs, popovers, and dialogs; `0px` for progress bars, scrollbars, tabs, and window edges.
* **Borders:** `1px solid` hairline borders on all interactive controls, menus, dialogs, and sidebars.
* **Holographic Glow:** Apply `box-shadow: 0 0 8px @hud_orange_glow;` on hovered buttons and `box-shadow: 0 0 8px @hud_cyan_dim;` on focused text inputs. In GNOME Shell CSS, use the copied literal color in place of the `@define-color` name.
* **Text Styling:** Headerbar titles, section headers, and primary action buttons should use `letter-spacing: 0.8px` to `1.2px` and `text-transform: uppercase;` where layout space permits without clipping.
* **Libadwaita radii:** `@define-color` overrides are required. Some radii stay rounded because they are not fully overridable from `gtk.css`. The v1 goal is a sharp HUD on headerbars, buttons, entries, lists, and cards.

---

## 3. Repository Directory Structure
Generate the following file tree at the root of this repository (`elite-dangerous-gtk-theme`). There is no `~/Projects/my-ubuntu-theme` checkout and no `my-ubuntu-theme/` wrapper directory.

```text
README.md                  # Installation, font recommendations, and reload instructions
install.sh                 # Symlink this repo root into ~/.local/share/themes
index.theme                # Freedesktop desktop theme metadata (no MetacityTheme)
src/_palette.css           # Shared token source of truth (copied into each stylesheet)
gtk-3.0/gtk.css            # GTK 3 stylesheet (later pass; not first acceptance)
gtk-4.0/gtk.css            # GTK 4 + Libadwaita overrides for Ubuntu 24.04
gnome-shell/gnome-shell.css # GNOME Shell CSS for GNOME 46
```

Equivalent layout:

```text
elite-dangerous-gtk-theme/
├── README.md
├── install.sh
├── index.theme
├── src/
│   └── _palette.css
├── gtk-3.0/
│   └── gtk.css
├── gtk-4.0/
│   └── gtk.css
└── gnome-shell/
    └── gnome-shell.css
```

### Build order
Implement in this order:

1. Palette (`src/_palette.css`) and `index.theme`.
2. GTK 4 for Ubuntu 24.04 (`gtk-4.0/gtk.css`), including the required Libadwaita `@define-color` overrides.
3. GNOME Shell (`gnome-shell/gnome-shell.css`) for GNOME 46. Selectors differ across GNOME versions.
4. GTK 3 (`gtk-3.0/gtk.css`). This is a later pass, together with Ubuntu 22.04 (GNOME 42), and is not the first acceptance target.
5. `install.sh`.

---

## 4. Detailed Component Specifications

### 4.1 Freedesktop Metadata (`index.theme`)
Must define the theme identity so GNOME Tweaks and GTK settings recognize it properly:

* `Name=Elite-Dangerous-HUD`
* `GtkTheme=Elite-Dangerous-HUD`
* `IconTheme=Adwaita`
* `CursorTheme=Adwaita`

Do not set `MetacityTheme`. There is no `metacity-1` theme.

v1 uses Adwaita icons (`IconTheme=Adwaita`). Custom HUD icons are a second iteration and are out of scope for v1. Do not add icon artwork.

### 4.2 GTK 3 (`gtk-3.0/gtk.css`) & GTK 4 / Libadwaita (`gtk-4.0/gtk.css`)
GTK 4 / Libadwaita on Ubuntu 24.04 is the first acceptance target. GTK 3 uses these same component rules and is a later pass.

Libadwaita `@define-color` overrides are required in `gtk-4.0/gtk.css`. Some radii stay rounded because they are not fully overridable from `gtk.css`. The v1 goal is a sharp HUD on headerbars, buttons, entries, lists, and cards.

Copy palette values into each GTK stylesheet as `@define-color`. Do not point both GTK and GNOME Shell at one imported file.

The stylesheets must explicitly target and override standard GTK widgets **as well as Libadwaita-specific classes** (`AdwHeaderBar`, `AdwWindow`, `AdwNavigationSplitView`, `AdwPreferencesGroup`, `boxed-list`, `card`, `toast`):

1. **Windows & Headerbars:**
   * `window`, `window.csd`, `.background`: `@hud_void` background, `@hud_text` foreground, `1px solid @hud_orange_dim` window border.
   * `headerbar`: `@hud_panel` background, `1px solid @hud_orange` bottom border, `box-shadow: 0 1px 6px @hud_orange_dim`.
   * Window controls (`button.titlebutton`): Sharp square `2px` buttons; `button.titlebutton.close:hover` must glow `@hud_red`.
2. **Buttons (`button`):**
   * Default: `background: rgba(255, 113, 0, 0.08)`, `border: 1px solid @hud_orange_dim`, `color: @hud_orange`, `border-radius: 2px`.
   * `:hover`: `background: @hud_orange_dim`, `border-color: @hud_orange`, `color: @hud_text_bright`, `box-shadow: 0 0 8px @hud_orange_glow`.
   * `:active` / `:checked`: Solid `@hud_orange` fill with dark `@hud_void` text.
   * `.suggested-action`: Styled in **Holo-Cyan** (`@hud_cyan`) border and text; solid `@hud_cyan` fill on hover.
   * `.destructive-action`: Styled in **Alert Red** (`@hud_red`) border and text; solid `@hud_red` fill on hover.
3. **Text Inputs (`entry`, `searchentry`, `spinbutton`):**
   * `@hud_panel` background, `1px solid @hud_orange_dim` border, `border-radius: 2px`, `caret-color: @hud_cyan`.
   * `:focus-within`: `border-color: @hud_cyan`, `box-shadow: 0 0 6px @hud_cyan_dim`.
4. **Sidebars, Lists & Libadwaita Cards:**
   * `.navigation-sidebar`, `placessidebar`: `@hud_panel` background with `1px solid @hud_orange_dim` right border. Selected rows get `@hud_orange_dim` background and a `3px solid @hud_orange` left indicator bar.
   * `list.boxed-list`, `.card`: `@hud_panel` background, `1px solid @hud_orange_dim` border, `border-radius: 2px` where `gtk.css` can override it. Some Libadwaita radii stay rounded because they are not fully overridable from `gtk.css`.
5. **Toggles, Checkboxes, Radio Buttons & Switches:**
   * `switch`: Rectangular `2px` radius track (`@hud_surface`), `1px solid @hud_orange_dim`. The checked state is `@hud_orange` with the slider in `@hud_void`. `@hud_green` is only for success and "systems nominal" banners, not the default switch.
   * `check`: `1px` radius, `@hud_orange` border, and a glowing `@hud_cyan` or `@hud_orange` fill when `:checked`.
   * `radio`: circular reticle, `@hud_orange` border, and a glowing `@hud_cyan` or `@hud_orange` fill when `:checked`.
   * Do not put both treatments on the same control. Checkboxes are the `1px` radius treatment. Radios are the circular reticle. A switch is neither.
6. **Progress Bars, Scales & Scrollbars (Ship PIP / Capacitor Aesthetic):**
   * `progressbar trough`, `scale trough`: `0px` radius, `@hud_surface` fill, `1px solid @hud_orange_dim`.
   * `progressbar progress`, `scale highlight`: `0px` radius, `@hud_orange` fill with subtle glow.
   * `scale slider`: Sharp rectangular `1px` radius reticle block in `@hud_cyan`.
   * `scrollbar slider`: Sharp `0px` radius `@hud_orange_dim` bar (`6px` wide), brightening to `@hud_orange` on hover.
7. **Tabs & Notebooks (`notebook`, `tabbar`):**
   * Tabs must have `0px` radius, `@hud_void` inactive background, `@hud_panel` active background with a `2px solid @hud_orange` top border.
8. **Popovers, Menus & Tooltips:**
   * `popover > contents`, `menu`, `tooltip`: `rgba(13, 17, 21, 0.96)` background, `1px solid @hud_orange` border, `2px` radius, dark drop shadow.

### 4.3 GNOME Shell (`gnome-shell/gnome-shell.css`)
Style the shell for **GNOME 46** (Ubuntu 24.04) without breaking that version's layout metrics. Shell selectors differ across GNOME versions. Ubuntu 22.04 (GNOME 42) is a later pass; do not reuse GNOME 46 selectors unchanged on GNOME 42, or the reverse.

GNOME Shell CSS is separate from GTK `@define-color`. Copy palette values into this file as literal hex / rgba colors. Token names in the rules below are references to section 2, not a shared import. Shell-only properties (including `-barlevel-*`) belong in this file.

1. **Top Panel (`#panel`):**
   * Height `30px`, `rgba(8, 10, 12, 0.92)` background, `1px solid rgba(255, 113, 0, 0.45)` bottom border.
   * `.panel-button`: `@hud_orange` text, `2px` radius; `:hover` and `:checked` get `rgba(255, 113, 0, 0.22)` background and a bottom `2px` `@hud_cyan` underline (`box-shadow: inset 0 -2px 0 #00d8ff`).
2. **Quick Settings & Popup Menus (`.popup-menu`, `.quick-settings`):**
   * `rgba(13, 17, 21, 0.96)` background, `1px solid #ff7100` border, `2px` radius.
   * `.quick-toggle`: `2px` radius, `1px solid rgba(255, 113, 0, 0.3)` border; `:checked` fills with `#ff7100` and `#080a0c` icon/label text.
   * `.slider`: Custom GNOME Shell `-barlevel-*` properties styled with `#ff7100` active track and `#00d8ff` handle.
3. **Notifications, Calendar & OSD Popups (`.osd-window`, `.message`):**
   * `.osd-window` (Volume/Brightness): `rgba(8, 10, 12, 0.94)` background, `1px solid #00d8ff` border, `2px` radius, `#00d8ff` bar fill.
   * `.message` (Notification banners): `@hud_panel` background, `1px solid @hud_orange_dim` border, `2px` radius.
4. **Overview, App Grid & Workspace Switcher (`#overview`, `.search-entry`):**
   * `.search-entry`: `#0d1115` background, `1px solid #ff7100` border, `2px` radius; `:focus` shifts border to `#00d8ff`.
   * `.workspace-thumbnail-indicator`: `2px solid #00d8ff` border around the active workspace.

---

## 5. Installation & Linking Script (`install.sh`)
The agent must generate an idempotent Bash script `install.sh` that performs the following actions:

1. Resolves this repository's absolute path (`REPO_DIR`). The theme directory is the repository root.
2. Creates `~/.local/share/themes` if needed and symlinks `$REPO_DIR` to `~/.local/share/themes/Elite-Dangerous-HUD`.
3. Does not replace `~/.config/gtk-4.0/gtk.css` unless the user opts in with a flag or a prompt. That replacement is off by default. When it is enabled, symlink `$REPO_DIR/gtk-4.0/gtk.css` to `~/.config/gtk-4.0/gtk.css`. If that path is a regular file, back it up first. If it is already a symlink to that file, leave it.
4. Does not install fonts. Rajdhani, Orbitron, and Eurostile are recommendations only.
5. Does not install extensions. GNOME Shell needs the User Themes extension (`user-theme`) installed and enabled before the shell theme name applies. Say that in the script output.
6. Prints clear post-install instructions for activating the theme via the `gsettings` commands below or **GNOME Tweaks**, plus the font recommendations.

### CLI Activation Commands (to include in `install.sh` output & `README.md`)
```bash
gsettings set org.gnome.desktop.interface gtk-theme "Elite-Dangerous-HUD"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.shell.extensions.user-theme name "Elite-Dangerous-HUD"
```

The `org.gnome.shell.extensions.user-theme` setting does nothing useful until the User Themes extension is enabled.

---

## 6. Verification Checklist for Agent
Before finishing, verify that:

- [ ] CSS checks allow GTK `@define-color` and Shell-only properties (including `-barlevel-*`). A generic CSS linter is not the acceptance test. Still reject unclosed braces, and reject properties that are invalid for the engine that owns the file.
- [ ] Libadwaita `@define-color` overrides (`@accent_color`, `@accent_bg_color`, `@window_bg_color`, `@window_fg_color`, `@view_bg_color`, `@view_fg_color`, `@headerbar_bg_color`, `@headerbar_fg_color`, `@card_bg_color`, `@popover_bg_color`) are defined at the top of `gtk-4.0/gtk.css` for seamless compatibility with native Libadwaita widgets. Some radii stay rounded because they are not fully overridable from `gtk.css`. The v1 goal remains a sharp HUD on headerbars, buttons, entries, lists, and cards.
- [ ] `install.sh` has `chmod +x` permissions and safely handles existing symlinks. Replacing `~/.config/gtk-4.0/gtk.css` stays off unless a flag or prompt enables it, and a regular file at that path is backed up before replacement.

First acceptance is Ubuntu 24.04 / GNOME 46 / Libadwaita, plus GNOME Shell on GNOME 46. GTK 3 and Ubuntu 22.04 (GNOME 42) are a later pass and are not required for that acceptance.
