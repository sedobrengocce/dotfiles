if status is-interactive
    # Commands to run in interactive sessions can go here
end

function prompt_vi_status
    set -l mode
    switch $fish_bind_mode
        case default
            set mode N
        case insert
            set mode I
        case visual
            set mode V
        case replace_one
            set mode R
        case '*'
            set mode \?
    end
    echo $mode
end

function prompt_git_status
    set -l index (git status --porcelain 2> /dev/null)
    set -l git_status ""

    if test -n "$index"
        set -l staged (string replace -a "  " "\n" $index | grep -E "^[AMRD]" | wc -l)
        set -l unstaged (string replace -a "  " "\n" $index | grep -E "^.[MTD]" | wc -l)
        set -l untracked (string replace -a "  " "\n" $index | grep -E "^\?\?" | wc -l)

        if test $staged -gt 0
            set git_status "$git_status  "
        end
        if test $unstaged -gt 0
            set git_status "$git_status  "
        end
        if test $untracked -gt 0
            set git_status "$git_status  "
        end
    else
        set git_status (set_color -o green)✓
    end
    
    set index (git status --porcelain --branch 2> /dev/null)
    set -l ahead (echo $index | grep -E "## .*ahead")
    set -l behind (echo $index | grep -E "## .*behind")

    if test -n "$ahead"
        set git_status $git_status (set_color -o cyan)↑
    end
    if test -n "$behind"
        set git_status $git_status (set_color -o magenta)↓
    end

    echo $git_status
end

function prompt_err_status
    set -l last_status $status
    set -l stat

    if test $last_status -eq 0
        set stat " ✓  "
    else if test $last_status -lt 10
        set stat "  $last_status  "
    else if test $last_status -lt 100
        set stat " $last_status  "
    else
        set stat "$last_status  "
    end

    echo $stat
end

function fish_prompt
    set -l err_status (prompt_err_status)

    set -l pr_pwd (prompt_pwd)
    set -l vi_status (prompt_vi_status)
	
    set -l fillLen

    set -l upbar
    set -l downbar

    set -l upbarL
    set -l upbarLSize
    set -l upbarR
    set -l upbarRSize

    set upbarL (set_color -b 3F3F3F)(set_color FF9800) $USER@$hostname (set_color -b normal)(set_color 3F3F3F) (set_color normal)
    set upbarR (set_color -b normal)(set_color 1A1A1A)(set_color -b 1A1A1A)(set_color EEFFFF) $pr_pwd (set_color 3F3F3F)(set_color -b 3F3F3F)(set_color FF9800) $vi_status (set_color -b normal)(set_color normal)

    set upbarLSize (math (echo $USER@$hostname | wc -c) + 3)
    set upbarRSize (math (echo $pr_pwd | wc -c) + 7)

	if test (math $upbarRSize + $upbarLSize) -le $COLUMNS
        set fillLen (math $COLUMNS - $upbarRSize - $upbarLSize - 1) 
        set upbar (echo $upbarL (string repeat -n $fillLen ' ') $upbarR)
    else
        set fillLen (math $COLUMNS - $upbarRSize - $upbarLSize - 1) 
        set upbar (echo (string repeat -n $fillLen " ") $upbarR)
    end

    # set upbar $(echo (set_color -o cyan)┌(set_color -o blue)─\($vi_status(set_color -o blue)\)(set_color -o blue)─\((set_color -o green)$USER@(set_color -o yellow)$hostname(set_color -o blue)\)─(set_color -o cyan)$(string repeat -n $pr_fillBar ─)(set_color -o blue)─\((set_color -o magenta)$pr_pwd(set_color -o blue)\)─(set_color -o cyan)┐)
    # set downbar $(echo (set_color -o cyan)└(set_color -o blue)─\((set_color -o yellow)$(date +"%H:%M")(set_color -o blue)\:(set_color -o white)\$(set_color -o blue)\)─(set_color -o cyan)─) (set_color normal)

    set downbar (set_color -b 3F3F3F)(set_color FF9800) $err_status   \$  (set_color -b normal)(set_color 3F3F3F) (set_color normal)
    
    echo $upbar
    echo $downbar
end

function fish_right_prompt
    set -l content $(date +"%a, %b %d")
    set git_current_branch (git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if test -n "$git_current_branch"
        set content  $git_current_branch (prompt_git_status)
    end
    echo (set_color -b normal)(set_color 3F3F3F)(set_color -b 3F3F3F)(set_color FF9800) $content (set_color -b normal)(set_color normal)
end

function fish_greeting
    fastfetch
end

## OPTIONS
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_sequence_key_delay_ms 200

## Bindings
bind -M default \x20v 'nvim .'

## Aliases
alias vim=nvim
alias ls=lsd
alias ll='lsd -l'
alias la='lsd -la'
alias txtfzf='fzf --preview "clp {}"'
## alias yay=paru
alias acompile='arduino-cli compile -b arduino:avr:uno'
alias aupload='arduino-cli upload -b arduino:avr:uno -p /dev/ttyACM0'
alias lg=lazygit
alias ld=lazydocker
alias lsql=lazysql
alias neofetch=fastfetch
alias mount='udisksctl mount -b'
alias umount='udisksctl unmount -b'

## ENVIRONMENT VARIABLES
set -x ANDROID_HOME /opt/android-sdk
set -x JAVA_HOME /usr/lib/jvm/java-17-openjdk
set -x HYPRSHOT_DIR $HOME/Pictures
set -x EDITOR nvim
set -x LC_ALL en_US.UTF-8
set -x BW_SESSION J4VqFMpGEd4BwWyKRsnAjUw6QgvAlBLXS2snxdja3WVxWhA50oiY8a0RKvR42Iy0dmrFZJE4RktmbNs+cUOksA==
set -x CHROME_EXECUTABLE google-chrome-stable
set export $(envsubst < $HOME/.env)

## PATHS
set -x PATH $HOME/.local/share/gem/ruby/3.0.0/bin $PATH
set -x PATH $HOME/go/bin $PATH
set -x PATH $HOME/.pub-cache/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/local/bin $PATH
set -x PATH $HOME/bin $PATH
set -x PATH $HOME/development/flutter/bin $PATH
set -x PATH $HOME/.local/share/gem/ruby/3.3.0/bin $PATH
set -x PATH /opt/android-sdk $PATH

## FZF
set -l fg "#eeffff"
set -l fg_highlight "#ff9800"
set -l bg "#212121"
set -l bg_highlight "#3e3e3e"
set -l fzf_prompt "#d87000"
set -l hl "#bbcccc"
set -l hl_highlight "#5e84ff"
set -l orange "#ff9800"
set -l yellow "#ffcc00"
set -l white "#eeffff"
set -l info "#afaf87"
set -l label "#aeaeae"
set -l query "#d9d9d9"

set -x FZF_DEFAULT_OPTS "--color=fg:$fg,fg+:$fg_highlight,bg:$bg,bg+:$bg_highlight,hl:$hl,hl+:$hl_highlight,info:$info,marker:$orange,prompt:$fzf_prompt,spinner:$orange,pointer:$yellow,header:$yellow,gutter:$bg,border:$bg_highlight,separator:$bg_highlight,scrollbar:$fg_highlight,preview-border:$bg_highlight,preview-scrollbar:$fg_highlight,label:$label,query:$query "
set -x FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --border=\"rounded\" --border-label=\"\" --preview-window=\"border-rounded\" --prompt=\"> \" --marker=\">\" --pointer=\"▶\" --separator=\"─\" --scrollbar=\"▒\" --layout=\"reverse\""
set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-swd-prefix --exclude .git"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_ALT_C_COMMAND "fd --type d --hidden --strip-swd-prefix --exclude .git"

function _fzf_pass_print
    find $HOME/.password-store -not -path '*/.password-store/.*' -print | cut -d '/' -f 5- | tail -n +2 | sed 's/\.gpg$//' | sort -n | grep '/' | fzf | xargs pass
end

function _fzf_pass_key
    find $HOME/.password-store -not -path '*/.password-store/.*' -print | cut -d '/' -f 5- | tail -n +2 | sed 's/\.gpg$//' | sort -n | grep '/' | fzf | xargs pass -c > /dev/null
end

function _fzf_pass_user
    find $HOME/.password-store -not -path '*/.password-store/.*' -print | cut -d '/' -f 5- | tail -n +2 | sed 's/\.gpg$//' | sort -n | grep '/' | fzf | xargs pass -c | tail -1 | awk '{print $2}' | wl-copy -n
end

eval (fzf --fish)

function _fzf_bind
    bind -M default \x20ps _fzf_pass_print
    bind -M default \x20pk _fzf_pass_key
    bind -M default \x20pu _fzf_pass_user
end

_fzf_bind

## ZOXIDE
zoxide init fish --cmd cd | source

thefuck --alias | source
