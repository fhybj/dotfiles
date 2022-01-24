# Aliases

# Let sudo command use user alias. 
# Note: must have a space after of sudo
alias sudo='sudo '

alias svim='sudo nvim'

alias vi='nvim'
alias vim='nvim'

alias cat='bat'

alias btm='btm --color gruvbox'
alias top='btm'


alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

# Backup & Restore presonal config by git
## See Arch wiki: https://wiki.archlinux.org/title/Dotfiles
## See https://catcat.cc/post/diyo4
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


# Automatically include new executables
# in the completion after install a new package.

zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
    if [[ -a /var/cache/zsh/pacman ]]; then
        local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
	if ((zshcache_time < paccache_time)); then
            rehash
	    zshcache_time="$paccache_time"
        fi
    fi
}

add-zsh-hook -Uz precmd rehash_precmd


# clipcat
if type clipcat-menu >/dev/null 2>&1; then
    alias clipedit=' clipcat-menu --finder=builtin edit'
    alias clipdel=' clipcat-menu --finder=builtin remove'

    bindkey -s '^\' "^Q clipcat-menu --finder=builtin insert ^J"
    bindkey -s '^]' "^Q clipcat-menu --finder=builtin remove ^J"
fi
