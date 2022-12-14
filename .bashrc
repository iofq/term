# ~/.bashrc
[[ $- != *i* ]] && return
function prompt_command {
  GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
  [[ $GIT_BRANCH != '' ]] && \
  PS1="\[\033[38;5;1m\][\u@\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;7m\]\W\[$(tput sgr0)\]\[\033[38;5;1m\]]\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;3m\]($GIT_BRANCH)\[\033[38;5;7m\]\$\[$(tput sgr0)\] " || \
  PS1="\[\033[38;5;1m\][\u@\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;7m\]\W\[$(tput sgr0)\]\[\033[38;5;1m\]]\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;3m\]\[\033[38;5;7m\]\$\[$(tput sgr0)\] "
}

function exists {
    type $1 >/dev/null 2>&1
}

for ed in vi vim.tiny vim nvim; do
    exists "$ed" && export EDITOR="$ed"
done

PROMPT_COMMAND='prompt_command;history -a'
export PATH=/usr/local/go/bin:~/go/bin:~/.bin:~/.local/bin:$PATH
export GPG_2FA="cjriddz@protonmail.com"
export MANPAGER="nvim +Man!"
xhost +local:root > /dev/null 2>&1

shopt -s cmdhist
shopt -s globstar 2> /dev/null
shopt -s dirspell 2> /dev/null
shopt -s dotglob 2> /dev/null
shopt -s extglob 2> /dev/null
shopt -s cdspell 2> /dev/null
shopt -s histappend 2> /dev/null
HISTSIZE=9001
HISTFILESIZE=99999

# tab completion
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"
bind '"\t":menu-complete'
bind '"\C-k": previous-history'
bind '"\C-j": next-history'

# aliases
alias la='/bin/ls -lahrt --color=auto'
alias ll='la'
alias tmux='tmux new -As0'
alias :q="exit"
alias vim='$EDITOR'
alias mpv="mpv --no-keepaspect-window"
alias sus="systemctl suspend"
alias gitu='git add . && git commit && git push'
alias aur="apt-cache search . | cut -d ' ' -f1 | fzf -m --preview 'apt show {1}' | xargs -ro sudo apt install"
alias aurns="apt list --installed | cut -d "/" -f1 | fzf -m --preview 'apt show {1}' | xargs -ro sudo apt purge"
exists "rsync" && alias rcp="rsync -avh --progress"

# cd && ls
function cd {
  cmd="ls"
  builtin cd "$@" && $cmd
}

if exists "fzf"; then
  FZF_CTRL_T_COMMAND="command find -L . -mindepth 1 -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' -prune"
  [ -r /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
  [ -r /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash
  [ -r /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash
  [ -r /usr/share/doc/fzf/examples/completion.bash ] && source /usr/share/doc/fzf/examples/completion.bash
fi
