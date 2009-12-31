autoload -U compinit
compinit
PROMPT="%m:%n%% "
RPROMPT="[%~]"
SPROMPT="correct: %R -> %r ? "
if [ ! $HOSTNAME ]
then
    export HOSTNAME=$HOST
fi

if [ -r ~/.profile ]
then
    source ~/.profile
fi
export LANG=ja_JP.UTF-8

keychain --timeout 30 ~/.ssh/id_dsa  # 秘密鍵
source ~/.keychain/$HOSTNAME-sh


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

PATH=$HOME/bin:$PATH
export PATH=$HOME/perl/current/bin::$PATH
export MANPATH=$HOME/perl/current/man:$MANPATH
export PERL5LIB=$HOME/perl/current/lib/perl5:$PERL5LIB
