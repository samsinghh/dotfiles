# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prefer installer-managed dependencies while allowing the existing Oh My Zsh
# layout until the installer has migrated this machine.
managed_zsh_dir="${XDG_DATA_HOME:-$HOME/.local/share}/dotfiles/zsh"
if [[ -r "$managed_zsh_dir/oh-my-zsh/oh-my-zsh.sh" ]]; then
  export ZSH="$managed_zsh_dir/oh-my-zsh"
  export ZSH_CUSTOM="$managed_zsh_dir/custom"
else
  export ZSH="$HOME/.oh-my-zsh"
  export ZSH_CUSTOM="$ZSH/custom"
fi
unset managed_zsh_dir

# Theme
if [[ -r "$ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  ZSH_THEME="powerlevel10k/powerlevel10k"
else
  ZSH_THEME=""
fi

# Plugins
plugins=(git)
[[ -r "$ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]] && plugins+=(zsh-autosuggestions)
[[ -r "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]] && plugins+=(zsh-syntax-highlighting)

# Options
DISABLE_AUTO_TITLE="true"

# Load Oh My Zsh
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -u2 "dotfiles: Oh My Zsh is unavailable; run ~/.dotfiles/install.sh"
fi

# Powerlevel10k config
[[ -n "$ZSH_THEME" && -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Google Cloud SDK (portable)
gcloud_sdk_dir="${CLOUDSDK_HOME:-$HOME/google-cloud-sdk}"
if [[ -r "$gcloud_sdk_dir/path.zsh.inc" ]]; then
  source "$gcloud_sdk_dir/path.zsh.inc"
fi
if [[ -r "$gcloud_sdk_dir/completion.zsh.inc" ]]; then
  source "$gcloud_sdk_dir/completion.zsh.inc"
fi
unset gcloud_sdk_dir

# PATH additions. The zsh path array keeps entries unique across reloads.
typeset -U path PATH
for user_bin in "$HOME/.local/bin" "$HOME/.npm-global/bin" "$HOME/.spicetify" "$HOME/.tmuxifier/bin"; do
  [[ -d "$user_bin" ]] && path=("$user_bin" $path)
done
unset user_bin

# tmuxifier
if [[ -r "$HOME/.tmuxifier/init.sh" ]]; then
  source "$HOME/.tmuxifier/init.sh"
fi

# Keybinds
bindkey -v
KEYTIMEOUT=1

# Aliases
alias pip='pip3'
alias python='python3'
alias vim='nvim'

export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
fi

# Machine-specific aliases, credentials, and environment variables.
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
