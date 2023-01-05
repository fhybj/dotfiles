# Aliases

# Let sudo command use user alias. 
# Note: must have a space after of sudo
alias sudo='sudo '

alias svim='sudo lvim'

alias nvim='lvim'
alias vi='lvim'
alias vim='lvim'
alias vimdiff='lvim -d'

# alias cat='bat'

# alias btm='btm --color gruvbox'
# alias top='btm'

#alias emacs='emacs -nw'

# alias wget='wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"'

agenew_server_mount ()
{
	# pass password to ssh with -o password_stdin
	echo "agenew0574" | sshfs agenew@172.18.4.12:/data0 /mnt/12 -o idmap=user -o reconnect -o password_stdin
	sshfs agenew@172.18.4.12:/data1 /mnt/12_1 -o idmap=user -o reconnect -o password_stdin <<< "agenew0574"
}
alias agenew_server='agenew_server_mount'

# alias m12='sshfs agenew@172.18.4.12:/data0 /mnt/12 -o idmap=user -o reconnect'
# alias m12_1='sshfs agenew@172.18.4.12:/data1 /mnt/12_1 -o idmap=user -o reconnect'

alias env_proxy='export all_proxy=socks5://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export https_proxy=http://127.0.0.1:7890'
alias unset_env_proxy='unset {all_proxy,http_proxy,https_proxy}'

alias jh='cd $HOME'

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


# Ranger plugin
function ranger_func {
    ranger $*
    local quit_cd_wd_file="${XDG_DATA_HOME}/ranger/ranger_quit_cd_wd"
    if [ -s "$quit_cd_wd_file" ]; then
        cd "$(cat $quit_cd_wd_file)"
        true | tee "$quit_cd_wd_file"
    fi
}

alias re='ranger_func'


# autojump
#[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

# Google translate
function google_trans {
	env_proxy
	trans :zh-CN $*
}

alias fanyi='google_trans'

# fzf
[[ -s /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
alias fs="fzf"
alias fv="fzf --bind 'enter:execute(lvim {})+abort'"

# fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# fasd
fasd_cache="$XDG_CACHE_HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install zsh-wcomp zsh-wcomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
alias v='f -e lvim'
