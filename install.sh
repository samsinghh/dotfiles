#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
[[ "$DOTFILES_DIR" == /* ]] || DOTFILES_DIR="$PWD/$DOTFILES_DIR"
ZSH_DEPS_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/zsh"
OH_MY_ZSH_REV="7ea697fd8138550ddf7262456d412f0dcd1cbf84"
POWERLEVEL10K_REV="ff0311157d6b24fea21aa70699783f362b0f554f"
AUTOSUGGESTIONS_REV="e52ee8ca55bcc56a17c828767a3f98f22a68d4eb"
SYNTAX_HIGHLIGHTING_REV="b1379f1ee96b1fe25701c9418c75f81eaabdab56"
TPM_REV="99469c4a9b1ccf77fade25842dc7bafbc8ce9946"
TMUX_SENSIBLE_REV="25cb91f42d020f675bb0a2ce3fbd3a5d96119efa"
TMUX_YANK_REV="acfd36e4fcba99f8310a7dfb432111c242fe7392"
TMUX_RESURRECT_REV="cff343cf9e81983d3da0c8562b01616f12e8d548"
TMUX_CONTINUUM_REV="0698e8f4b17d6454c71bf5212895ec055c578da0"

# Sources in repo
NVIM_SRC="$DOTFILES_DIR/nvim"
TMUX_SRC="$DOTFILES_DIR/tmux/.tmux.conf"
ZSH_SRC="$DOTFILES_DIR/zsh/.zshrc"
GHOSTTY_SRC="$DOTFILES_DIR/ghostty"

# Targets on system
NVIM_DST="$HOME/.config/nvim"
TMUX_DST="$HOME/.tmux.conf"
ZSH_DST="$HOME/.zshrc"
GHOSTTY_DST="$HOME/.config/ghostty"

# Fonts you expect
EXPECTED_FONTS=("JetBrainsMono Nerd Font" "JetBrainsMono Nerd Font Mono" "JetBrainsMonoNerdFont")

info() { printf "\033[1;34m[i]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[!]\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m[x]\033[0m %s\n" "$*"; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || { err "Missing required command: $1"; exit 1; }
}

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }
is_linux() { [[ "$(uname -s)" == "Linux" ]]; }

timestamp() { date +%Y%m%d%H%M%S; }

backup_if_needed() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    local backup="${target}.bak.$(timestamp)"
    warn "Backing up existing $target -> $backup"
    mv "$target" "$backup"
  fi
}

link() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    warn "Source missing, skipping: $src"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    local cur
    cur="$(readlink "$dest")"
    if [[ "$cur" == "$src" ]]; then
      info "Symlink already correct: $dest -> $src"
      return 0
    fi
    warn "Replacing symlink: $dest (was -> $cur)"
    backup_if_needed "$dest"
  else
    backup_if_needed "$dest"
  fi

  ln -s "$src" "$dest"
  info "Linked: $dest -> $src"
}

install_packages() {
  if is_linux && command -v apt-get >/dev/null 2>&1; then
    info "Installing packages via apt"
    if [[ "$EUID" -eq 0 ]]; then
      env DEBIAN_FRONTEND=noninteractive apt-get update
      env DEBIAN_FRONTEND=noninteractive apt-get install -y git zsh tmux neovim ripgrep xclip
    else
      need_cmd sudo
      sudo env DEBIAN_FRONTEND=noninteractive apt-get update
      sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y git zsh tmux neovim ripgrep xclip
    fi
  elif is_macos; then
    command -v brew >/dev/null 2>&1 || {
      err "Homebrew is required on macOS: https://brew.sh"
      exit 1
    }
    info "Installing packages via Homebrew"
    brew install git zsh tmux neovim ripgrep
  else
    err "Unsupported platform or package manager (supported: macOS/Homebrew and Debian/Ubuntu apt-get)."
    exit 1
  fi
}

validate_neovim() {
  local version major minor

  need_cmd nvim
  version="$(nvim --version)"
  version="${version%%$'\n'*}"
  if [[ "$version" =~ NVIM[[:space:]]v([0-9]+)\.([0-9]+) ]]; then
    major="${BASH_REMATCH[1]}"
    minor="${BASH_REMATCH[2]}"
  else
    err "Unable to determine Neovim version from: $version"
    exit 1
  fi

  if (( major < 1 && minor < 12 )); then
    err "Neovim >= 0.12 is required; found ${major}.${minor}."
    if is_macos; then
      err "Run 'brew update && brew upgrade neovim', then rerun this installer."
    else
      err "Install Neovim >= 0.12 from an upstream release or another current package source, then rerun this installer."
    fi
    exit 1
  fi
  info "Neovim version requirement satisfied: ${major}.${minor}"
}

install_git_dependency() {
  local name="$1" repo="$2" revision="$3" destination="$4" required_file="$5"

  if [[ -e "$destination" && ! -d "$destination/.git" ]]; then
    err "$name destination exists but is not an installer-managed Git checkout: $destination"
    err "Move or remove it, then rerun this installer."
    exit 1
  fi

  if [[ ! -d "$destination/.git" ]]; then
    info "Creating $name checkout"
    mkdir -p "$(dirname "$destination")"
    git init -q "$destination"
    git -C "$destination" remote add origin "$repo"
  else
    if [[ -n "$(git -C "$destination" status --porcelain --untracked-files=all)" ]]; then
      err "$name checkout contains local changes: $destination"
      err "Commit, move, or remove them before rerunning this installer."
      exit 1
    fi
    if git -C "$destination" remote get-url origin >/dev/null 2>&1; then
      git -C "$destination" remote set-url origin "$repo"
    else
      git -C "$destination" remote add origin "$repo"
    fi
  fi

  info "Installing $name at $revision"
  git -C "$destination" fetch --quiet --depth 1 origin "$revision"
  git -C "$destination" checkout --quiet --detach FETCH_HEAD
  [[ "$(git -C "$destination" rev-parse HEAD)" == "$revision" ]] || {
    err "$name did not resolve to the pinned revision."
    exit 1
  }
  [[ -z "$(git -C "$destination" status --porcelain --untracked-files=all)" ]] || {
    err "$name checkout is not clean after installation."
    exit 1
  }
  [[ -f "$destination/$required_file" ]] || {
    err "$name is missing required file: $destination/$required_file"
    exit 1
  }
}

install_zsh_dependencies() {
  local custom_dir="$ZSH_DEPS_DIR/custom"

  install_git_dependency "Oh My Zsh" \
    "https://github.com/ohmyzsh/ohmyzsh.git" "$OH_MY_ZSH_REV" \
    "$ZSH_DEPS_DIR/oh-my-zsh" "oh-my-zsh.sh"
  install_git_dependency "Powerlevel10k" \
    "https://github.com/romkatv/powerlevel10k.git" "$POWERLEVEL10K_REV" \
    "$custom_dir/themes/powerlevel10k" "powerlevel10k.zsh-theme"
  install_git_dependency "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions.git" "$AUTOSUGGESTIONS_REV" \
    "$custom_dir/plugins/zsh-autosuggestions" "zsh-autosuggestions.plugin.zsh"
  install_git_dependency "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$SYNTAX_HIGHLIGHTING_REV" \
    "$custom_dir/plugins/zsh-syntax-highlighting" "zsh-syntax-highlighting.plugin.zsh"
}

install_tmux_dependencies() {
  local plugin_dir="$HOME/.tmux/plugins"

  install_git_dependency "TPM" \
    "https://github.com/tmux-plugins/tpm.git" "$TPM_REV" \
    "$plugin_dir/tpm" "tpm"
  install_git_dependency "tmux-sensible" \
    "https://github.com/tmux-plugins/tmux-sensible.git" "$TMUX_SENSIBLE_REV" \
    "$plugin_dir/tmux-sensible" "sensible.tmux"
  install_git_dependency "tmux-yank" \
    "https://github.com/tmux-plugins/tmux-yank.git" "$TMUX_YANK_REV" \
    "$plugin_dir/tmux-yank" "yank.tmux"
  install_git_dependency "tmux-resurrect" \
    "https://github.com/tmux-plugins/tmux-resurrect.git" "$TMUX_RESURRECT_REV" \
    "$plugin_dir/tmux-resurrect" "resurrect.tmux"
  install_git_dependency "tmux-continuum" \
    "https://github.com/tmux-plugins/tmux-continuum.git" "$TMUX_CONTINUUM_REV" \
    "$plugin_dir/tmux-continuum" "continuum.tmux"
}

warn_if_font_missing() {
  # Best-effort checks:
  # - Linux: fc-list
  # - macOS: system_profiler (slow) or fc-list if installed
  if command -v fc-list >/dev/null 2>&1; then
    local found="no"
    for f in "${EXPECTED_FONTS[@]}"; do
      if fc-list | grep -qi "$f"; then
        found="yes"
        break
      fi
    done
    if [[ "$found" == "no" ]]; then
      warn "Nerd font not detected via fc-list. Icons may look wrong in nvim/tmux."
      warn "Expected something like: JetBrainsMono Nerd Font."
    else
      info "Font check: Nerd font detected."
    fi
  else
    warn "fc-list not available, skipping font check."
    warn "If icons look wrong, install JetBrainsMono Nerd Font in this OS."
  fi
}

main() {
  need_cmd uname

  [[ -d "$DOTFILES_DIR" ]] || { err "Dotfiles directory not found: $DOTFILES_DIR"; exit 1; }

  install_packages
  need_cmd git
  need_cmd zsh
  need_cmd tmux
  validate_neovim
  install_zsh_dependencies

  # Symlinks
  link "$NVIM_SRC" "$NVIM_DST"
  link "$TMUX_SRC" "$TMUX_DST"
  link "$ZSH_SRC" "$ZSH_DST"

  # Ghostty: only link if it exists on this OS
  # (Ghostty might not be installed/available on Ubuntu)
  if command -v ghostty >/dev/null 2>&1 || is_macos; then
    link "$GHOSTTY_SRC" "$GHOSTTY_DST"
  else
    warn "Ghostty not detected; skipping ghostty symlink."
  fi

  install_tmux_dependencies
  warn_if_font_missing

  info "Done."
  info "Next steps:"
  info "  - tmux: start tmux; pinned plugins are already installed."
  info "  - zsh: start a new terminal (or run: exec zsh)."
  info "  - nvim: open Neovim and sync plugins (Lazy)."
}

main "$@"
