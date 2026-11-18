# Project Specification: Elite Dangerous Ship HUD Theme for Ubuntu (GNOME / GTK)

## 1. Objective & Agent Instructions
You are tasked with building a complete, modular, production-ready **GTK 3**, **GTK 4 / Libadwaita**, and **GNOME Shell** desktop theme for Ubuntu inspired by the holographic ship cockpit HUD in *Elite Dangerous* (Lakon Spaceways / Core Dynamics / Faulcon DeLacy aesthetic).

### Core Agent Directives
1. **Architecture:** Build the theme inside the user's Git repository (`~/Projects/my-ubuntu-theme`) using a clean, modular SCSS or structured CSS architecture so color tokens and geometry rules are DRY (Don't Repeat Yourself).
2. **Compatibility:** Ensure visual parity across legacy GTK 3 apps, modern GTK 4 / Libadwaita apps (Ubuntu 22.04 / 24.04+), and the GNOME Shell desktop environment.
3. **Automation:** Provide an `install.sh` script that compiles styles (if using SCSS) and creates the required symbolic links in `~/.local/share/themes/` and `~/.config/gtk-4.0/`.
4. **No Soft Pill Shapes:** Strictly enforce sharp, tactical cockpit geometry (`border-radius: 0px` to `2px`) across all buttons, entries, tabs, popovers, and cards, overriding GNOME Adwaita's default rounded pill styling.

---

## 2. Visual & Design Language

### A. Color Palette Tokens
All stylesheets must derive from the following exact color variables:

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
| `hud_green` | `#00E676` | Systems nominal: switches ON state, success banners |
| `hud_text` | `#FFB067` | Standard body & widget foreground text (warm amber) |
| `hud_text_bright` | `#FFE2C4` | High-contrast active tab/row text & hovered labels |
| `hud_text_dim` | `#7A5234` | Disabled widgets, placeholders, unfocused headerbar elements |

### B. Typography & Geometry Rules
* **Corner Radius:** `2px` max for buttons, inputs, popovers, and dialogs; `0px` for progress bars, scrollbars, tabs, and window edges.
* **Borders:** `1px solid` hairline borders on all interactive controls, menus, dialogs, and sidebars.
* **Holographic Glow:** Apply `box-shadow: 0 0 8px @hud_orange_glow;` on hovered buttons and `box-shadow: 0 0 8px @hud_cyan_dim;` on focused text inputs.
* **Text Styling:** Headerbar titles, section headers, and primary action buttons should use `letter-spacing: 0.8px` to `1.2px` and `text-transform: uppercase;` where layout space permits without clipping.

---

## 3. Repository Directory Structure
Generate the following file tree inside the repository root:

```text
my-ubuntu-theme/
├── README.md                  # Installation, font recommendations, and reload instructions
├── install.sh                 # Executable script to symlink theme & Libadwaita overrides
├── index.theme                # Freedesktop desktop theme metadata file
├── src/                       # Modular source files (if using Sass/SCSS) or shared tokens
│   └── _palette.css           # Master @define-color variables
├── gtk-3.0/
│   └── gtk.css                # Complete GTK 3 stylesheet
├── gtk-4.0/
│   └── gtk.css                # Complete GTK 4 + Libadwaita override stylesheet
└── gnome-shell/
    └── gnome-shell.css        # GNOME Shell top bar, quick settings, overview, and OSD
```

---

## 4. Detailed Component Specifications

### 4.1 Freedesktop Metadata (`index.theme`)
Must define the theme identity so GNOME Tweaks and GTK settings recognize it properly:
* `Name=Elite-Dangerous-HUD`
* `GtkTheme=Elite-Dangerous-HUD`
* `MetacityTheme=Elite-Dangerous-HUD`
* `IconTheme=Adwaita`
* `CursorTheme=Adwaita`

### 4.2 GTK 3 (`gtk-3.0/gtk.css`) & GTK 4 / Libadwaita (`gtk-4.0/gtk.css`)
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
   * `list.boxed-list`, `.card`: `@hud_panel` background, `1px solid @hud_orange_dim` border, `border-radius: 2px` (overriding Libadwaita's `12px` card rounding).
5. **Toggles, Checkboxes, Radio Buttons & Switches:**
   * `switch`: Rectangular `2px` radius track (`@hud_surface`), `1px solid @hud_orange_dim`. When `:checked`, background becomes `@hud_orange` (or `@hud_green` for system status), slider block in `@hud_void`.
   * `check`, `radio`: Sharp `1px` radius (checkbox) / circular reticle (radio) with `@hud_orange` border and glowing `@hud_cyan` or `@hud_orange` fill when `:checked`.
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
Must style all shell UI layers cleanly without breaking GNOME 42–46+ layout metrics:

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
1. Resolves the repository's absolute path (`REPO_DIR`).
2. Creates `~/.local/share/themes` and symlinks `$REPO_DIR` to `~/.local/share/themes/Elite-Dangerous-HUD`.
3. Backs up any existing `~/.config/gtk-4.0/gtk.css` (if it is a regular file and not already a symlink) and symlinks `$REPO_DIR/gtk-4.0/gtk.css` to `~/.config/gtk-4.0/gtk.css` so Libadwaita apps inherit the theme.
4. Prints clear post-install instructions for activating the theme via `gsettings` commands or **GNOME Tweaks**, plus recommended geometric fonts (`Rajdhani`, `Orbitron`, or `Eurostile`).

### CLI Activation Commands (to include in `install.sh` output & `README.md`)
```bash
gsettings set org.gnome.desktop.interface gtk-theme "Elite-Dangerous-HUD"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.shell.extensions.user-theme name "Elite-Dangerous-HUD"
```

---

## 6. Verification Checklist for Agent
Before finishing, verify that:
- [ ] All CSS files pass syntax validation with zero unclosed braces or invalid GTK CSS properties.
- [ ] Libadwaita `@define-color` overrides (`@accent_color`, `@accent_bg_color`, `@window_bg_color`, `@window_fg_color`, `@view_bg_color`, `@view_fg_color`, `@headerbar_bg_color`, `@headerbar_fg_color`, `@card_bg_color`, `@popover_bg_color`) are defined at the top of `gtk-4.0/gtk.css` for seamless compatibility with native Libadwaita widgets.
- [ ] `install.sh` has `chmod +x` permissions and safely handles existing symlinks.