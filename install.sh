#!/usr/bin/env bash
# Link this repository into ~/.local/share/themes/Elite-Dangerous-HUD.
# Does not install fonts or extensions. Replacing ~/.config/gtk-4.0/gtk.css
# is optional and off unless you pass --gtk4-user-css or answer yes.

set -euo pipefail

THEME_NAME="Elite-Dangerous-HUD"
REPO_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
THEMES_DIR="${HOME}/.local/share/themes"
TARGET="${THEMES_DIR}/${THEME_NAME}"
USER_GTK4="${HOME}/.config/gtk-4.0/gtk.css"
SRC_GTK4="${REPO_DIR}/gtk-4.0/gtk.css"

usage() {
  cat <<EOF
Usage: install.sh [--gtk4-user-css | --no-gtk4-user-css]

Symlinks this repo to ~/.local/share/themes/${THEME_NAME}.
--gtk4-user-css also points ~/.config/gtk-4.0/gtk.css at gtk-4.0/gtk.css
(Libadwaita reads that file). That step is off by default. A regular file
at that path is backed up first. An existing symlink to this theme is left
alone.
EOF
}

opt_in=0
asked=0
case "${1:-}" in
  "")
    ;;
  --gtk4-user-css)
    opt_in=1
    ;;
  --no-gtk4-user-css)
    opt_in=0
    ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    echo "Unknown option: $1" >&2
    usage >&2
    exit 1
    ;;
esac

if [[ "$#" -gt 1 ]]; then
  echo "Too many arguments." >&2
  usage >&2
  exit 1
fi

mkdir -p "${THEMES_DIR}"

if [[ -L "${TARGET}" ]]; then
  ln -sfn "${REPO_DIR}" "${TARGET}"
elif [[ -e "${TARGET}" ]]; then
  echo "Refusing to replace ${TARGET} because it exists and is not a symlink." >&2
  exit 1
else
  ln -s "${REPO_DIR}" "${TARGET}"
fi

echo "Linked ${TARGET} -> ${REPO_DIR}"

link_user_gtk4() {
  mkdir -p "${HOME}/.config/gtk-4.0"
  if [[ -L "${USER_GTK4}" ]]; then
    local current want
    current="$(readlink -f "${USER_GTK4}" || true)"
    want="$(readlink -f "${SRC_GTK4}")"
    if [[ "${current}" == "${want}" ]]; then
      echo "User GTK 4 stylesheet already points at the theme."
      return
    fi
    echo "Leaving ${USER_GTK4} (symlink to something else)."
    return
  fi
  if [[ -f "${USER_GTK4}" ]]; then
    local backup
    backup="${USER_GTK4}.bak.$(date +%Y%m%d%H%M%S)"
    mv "${USER_GTK4}" "${backup}"
    echo "Backed up ${USER_GTK4} to ${backup}"
  elif [[ -e "${USER_GTK4}" ]]; then
    echo "Refusing to replace ${USER_GTK4} (not a regular file)." >&2
    exit 1
  fi
  ln -s "${SRC_GTK4}" "${USER_GTK4}"
  echo "Linked ${USER_GTK4} -> ${SRC_GTK4}"
}

if [[ "${opt_in}" -eq 0 && -t 0 && -z "${1:-}" ]]; then
  asked=1
  printf 'Replace ~/.config/gtk-4.0/gtk.css so Libadwaita apps pick up the HUD? [y/N] '
  reply=""
  if IFS= read -r reply; then
    if [[ "${reply}" =~ ^[Yy]([Ee][Ss])?$ ]]; then
      opt_in=1
    fi
  fi
fi

if [[ "${opt_in}" -eq 1 ]]; then
  link_user_gtk4
else
  if [[ "${asked}" -eq 1 ]]; then
    echo "Leaving ~/.config/gtk-4.0/gtk.css unchanged."
  else
    echo "Leaving ~/.config/gtk-4.0/gtk.css unchanged. Pass --gtk4-user-css to opt in."
  fi
fi

cat <<EOF

Elite-Dangerous-HUD is installed. Icons stay Adwaita.
Fonts were not installed. Rajdhani (interface), Orbitron (titles), and
Eurostile (an alternate display face) are recommendations only.

GNOME Shell needs the User Themes extension (user-theme) installed and
enabled. The shell setting does nothing useful until that extension is on.
On Wayland, log out and back in after enabling it. On X11, Alt+F2 then r
reloads the shell. Restart open GTK apps so they pick up the theme.

Libadwaita on GNOME 46 does not load gtk-theme CSS. Pass --gtk4-user-css
(or answer yes at the prompt) if Settings, Files, and other libadwaita
apps should use this stylesheet.

Activate:

gsettings set org.gnome.desktop.interface gtk-theme "Elite-Dangerous-HUD"
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
gsettings set org.gnome.shell.extensions.user-theme name "Elite-Dangerous-HUD"

Or pick Elite-Dangerous-HUD in GNOME Tweaks (Appearance, and Shell with
User Themes enabled).
EOF
