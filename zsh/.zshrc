#Display Pokemon
fastfetch
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
export QT_QPA_PLATFORM="wayland;xcb"
# Path to your oh-my-zsh installation.


ZSH=/usr/share/oh-my-zsh/

# Path to powerlevel10k theme
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# List of plugins used
plugins=( git zsh-256color zsh-autosuggestions zsh-syntax-highlighting sudo zsh-autocomplete)
source $ZSH/oh-my-zsh.sh

# Detect the AUR wrapper
if pacman -Qi yay &>/dev/null ; then
   aurhelper="yay"
elif pacman -Qi paru &>/dev/null ; then
   aurhelper="paru"
fi

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null ; then
            arch+=("${pkg}")
        else 
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

function nvid(){
    neovide "$1" --no-vsync &!
}
# Helpful aliases
alias  c='clear' # clear terminal
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza --icons=auto' # short list
alias la='eza -a --icons=auto --group-directories-first' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias yui='$aurhelper -Rns' # uninstall package
alias yu='$aurhelper -Syu' # update system/package/aur
alias yi='$aurhelper -S' # install package
alias yl='$aurhelper -Qs' # list installed package
alias ys='$aurhelper -Ss' # list availabe package
alias yc='$aurhelper -Sc' # remove unused cache
alias yo='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias vc='code' # gui code editor

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
alias mkdir='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# pnpm
export PNPM_HOME="/home/emptyzdb/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

