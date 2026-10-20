ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

export PATH="$HOME/.local/bin:$PATH"

if [[ "$TERM_PROGRAM" == "ghostty" ]]; then
    eval "fastfetch"
fi

zinit light zsh-users/zsh-completions
autoload -Uz compinit && compinit
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light zdharma-continuum/fast-syntax-highlighting

bindkey -e

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"
