#!/bin/zsh

#-----Functions
## Print loading status
zshrc_load_status () {
        # \e[0K is clear to right
        echo -n "\r.zshrc load: $* ... \e[0K"
}

sshPepjServer() {
    ssh -t pepj@pepj-server 'tmux a -t Base'
}

sshHappee() {
    ssh -t pepj@happee 'tmux a -t Base'
}

declare -A pomo_opts
pomo_opts["work"]="45"
pomo_opts["break"]="15"

pomodoro() {
    if [ -n "$1" -a -n "${pomo_opts["$1"]}" ]; then
        val=$1
        echo $val | lolcat
        timer ${pomo_opts["$val"]}m && spd-say "'$val' session ended" || spd-say "'$val' session aborted"
    else
        echo $1
        timer ${2}m && spd-say "'$1' session ended" || spd-say "'$1' session aborted"
    fi
}

sshvim() { 
    vared -p 'Password: ' -c pass
    expect -c "spawn ssh -MNv $1; expect '*?assword*'; send $pass; interact" &
    nvim scp://$1/$2
}

sendNtfy() {
    /bin/zsh -c $* && ntfy send "$* successfully executed" || ntfy send "$* failed"
}

fzSearch() {
    if [ -n "$1" ]; then
        find "$1" -print | fzf
    else
        find . -print | fzf
    fi
}

## Loading base copletition
zshrc_load_status 'Loading base completition'
autoload -U compinit
compinit

## Setting up some aliases
zshrc_load_status 'Setting up some aliases'
alias vim=nvim
alias ls=lsd
alias la='lsd -al'
alias ll='lsd -l'
alias wo="pomodoro 'work'"
alias br="pomodoro 'break'"
alias l='less'
alias m='more'
alias nrun='npm run'
alias txtfzf="fzf --preview 'clp {}'"

## setting up some variable for shell behavoiur
# permette di cancellare con alt-backspace
WORDCHARS=''		
# history settings
HISTFILE=~/.histfile
HISTSIZE=4000
SAVEHIST=3000
# Watching for other users
LOGCHECK=10
WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"
watch=(notme)
# mail check
MAILCHECK=1

## setting up some variables to be exported
export PATH="$PATH:/home/pepj/.local/bin"
export PATH=$PATH:~/local/bin/:~/development/flutter/bin/
export PATH=$PATH:/opt/android-sdk/cmdline-tools/latest/bin/

export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

export EDITOR=nvim

export LC_ALL="en_US.UTF-8"

## load user's path
path=($path ~/bin)
fpath=(~/.zsh/completion $fpath)

## Setting up options
zshrc_load_status 'Setting options'
## directory
setopt 	auto_cd 			#se non e' un comando e' una dir, entraci
setopt	auto_pushd 			#metto la vecchia dir nello stack
setopt	no_cdable_vars 			#non completo automaticamente le home
setopt	no_chase_dots 			#non risolvo i punti nei link
setopt	no_chase_links 	 		#non risolvo i link
setopt	pushd_ignore_dups 		#non metto duplicati nello stack delle directory
setopt	no_pushd_minus			#lascia invariato il significato di + e -
setopt 	no_pushd_silent			#stampa lo stack dopo popd o pushd
setopt	no_pushd_to_home		#swappa primi due elementi dello stack
## colpetition
setopt	always_last_prompt		#mantiene il propmt nella linea corrente dopo il completamento
#setopt  always_to_end			#non l'ho capita questa
setopt	autolist			#mostra possibili completamenti
setopt	automenu			#usa il menu alla seconda richiesta di completamento
setopt	auto_name_dirs			#usa i nomi delle variabili come nomi per il contenuto (de e' una dir)
setopt	auto_param_keys			#rimuove spazi aggiunti in maniera smart
setopt	auto_param_slash		#aggiunge / alla fine delle dir
setopt	auto_remove_slash		#rimuove //
setopt	no_bash_auto_list		#non mostra le scelte possibili ma direttamente il menu
setopt 	complete_aliases		#completa anche gli alias
setopt	complete_in_word		#completa anche dal cursore in poi (se non alla fine)
setopt	glob_complete			#non inserisce tutte le parole ma le scorre tipo menu
setopt	hash_list_all			#fa un hash del path
setopt	list_ambiguous			#inserisce i prefissi non ambigui
setopt	no_list_beep			#beep on completition
setopt	list_packed			#occupa meno spazio nel mostrare le possibilità
setopt 	list_types			#mostra il tipo di oggetto completato
setopt	no_menu_complete		#non completa immediatamente col menu 
#setopt	rec_exact			#riconosce match esatti anche se ambigui 
## exapansione and globbing
setopt	bad_pattern			#corregge gli errori
## history
setopt	append_history			#appendi alla fine del file
setopt	bang_hist			#bang history i.e. !
setopt	extended_history		#salva la data di esecuzione e la durata
setopt	no_hist_beep			#no beep on errors
setopt	hist_ignore_all_dups		#non salva i duplicati
setopt	hist_ignore_space		#cancello gli spazi iniziali
setopt	hist_no_store			#non salva il comando di history fc nella history 
setopt	hist_reduce_blanks		#cancella gli spazi inutili
setopt	hist_save_no_dups		#non riscrivo i comandi duplicati nei salvatagi
setopt	hist_verify			#prima di eseguire un comando controlla
setopt	share_history			#condividi l'history con le altre shell

## Fix and set dome keys
bindkey -e
bindkey -s '^[[Z' '\t'
bindkey '^[[2~' yank			## Ins
bindkey '^[[3~' delete-char		## Del
bindkey '^[[5~' up-line-or-history 	## PageUp
bindkey '^[[6~' down-line-or-history 	## PageDown
bindkey '^[e' expand-cmd-path 		## C-e for expanding path of typed command
bindkey '^[[A' up-line-or-search 	## up arrow for back-history-search
bindkey '^[[B' down-line-or-search 	## down arrow for fwd-history-search
bindkey ' ' magic-space 		## do history expansion on space
bindkey '^[[7~'  beginning-of-line	## Home
bindkey '^[[8~'  end-of-line		## End
# which key are these two?
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line


# The following lines were added by compinstall
#
#zstyle ':completion:*' group-name ''
#zstyle ':completion:*' insert-unambiguous true
#zstyle ':completion:*' list-colors ''
#zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
#zstyle ':completion:*' menu select=0
#zstyle ':completion:*' original true
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#zstyle :compinstall filename '/home/stella/.zshrc'
#
#autoload -Uz compinit
#compinit -C
#
# End of lines added by compinstall

eval $(thefuck --alias)

# Lines configured by zsh-newuser-install
#setopt extendedglob
setopt nobeep
# End of lines configured by zsh-newuser-install
