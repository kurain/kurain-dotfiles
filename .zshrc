autoload -U compinit
compinit
PROMPT="%m:%n%% "
RPROMPT="[%~]"
SPROMPT="correct: %R -> %r ? " 

export LANG=ja_JP.UTF-8
source .profile

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data 

bindkey -e

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end 

setopt auto_pushd
setopt correct
setopt list_packed
setopt nolistbeep
