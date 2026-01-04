# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Options
DISABLE_AUTO_TITLE="true"

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Powerlevel10k config
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Google Cloud SDK (portable)
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# PATH additions (portable)
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$PATH:$HOME/.spicetify"
export PATH="$HOME/.tmuxifier/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"   # pipx default location on many setups

# tmuxifier
if command -v tmuxifier >/dev/null 2>&1; then
  eval "$(tmuxifier init -)"
fi

# Keybinds
bindkey -v
KEYTIMEOUT=1

# Aliases
alias pip='pip3'

# UTCS SSH username for utcs-ssh
export UTCS_SSH_USERNAME="samyak"
export TERM=xterm-256color

# [[ -f "$HOME/.zshrc.private" ]] && source "$HOME/.zshrc.private"

