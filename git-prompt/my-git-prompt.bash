if test -f /etc/profile.d/git-sdk.sh
then
	TITLEPREFIX=SDK-${MSYSTEM#MINGW}
else
	TITLEPREFIX=$MSYSTEM
fi

# Black       0;30     Dark Gray     1;30
# Blue        0;34     Light Blue    1;34
# Green       0;32     Light Green   1;32
# Cyan        0;36     Light Cyan    1;36
# Red         0;31     Light Red     1;31
# Purple      0;35     Light Purple  1;35
# Brown       0;33     Yellow        1;33
# Light Gray  0;37     White         1;37

c_clear='\[\033[0m\]'
# Foreground
f_coloroff='\[\e[0m\]'    # Text Reset
f_default='\[\e[39m\]'     # Default text color
f_black='\[\e[30m\]'       # Black

f_red='\[\e[31m\]'         # Red
f_green='\[\e[32m\]'       # Green
f_yellow='\[\e[33m\]'      # Yellow
f_blue='\[\e[34m\]'        # Blue
f_purple='\[\[\e[35m\]'      # Purple
f_cyan='\[\e[36m\]'        # Cyan
f_gray='\[\e[90m\]'        # Gray

f_lgray='\[\e[37m\]'       # Light Gray
f_lred='\[\e[91m\]'        # Light Red
f_lgreen='\[\e[1;32m\]'      # Light Green
f_lyellow='\[\e[93m\]'     # Light Yellow
f_lblue='\[\e[1;34m\]'       # Light Blue
f_lpurple='\[\e[95m\]'     # Light Purple
f_lcyan='\[\e[96m\]'       # Light Cyan
f_white='\[\e[97m\]'       # White

# Background
b_default='\[\e[49m\]'     # Default bg color
b_black='\[\e[40m\]'       # Black
b_red='\[\e[41m\]'         # Red
b_green='\[\e[42m\]'       # Green
b_yellow='\[\e[43m\]'      # Yellow
b_blue='\[\e[44m\]'        # Blue
b_purple='\[\e[45m\]'      # Purple
b_cyan='\[\e[46m\]'        # Cyan
b_lgray='\[\e[47m\]'       # Light Gray

b_gray='\[\e[100m\]'       # Dark gray
b_lred='\[\e[101m\]'       # Light Red
b_lgreen='\[\e[102m\]'     # Light Green
b_lyellow='\[\e[103m\]'    # Light Yellow
b_lblue='\[\e[104m\]'      # Light Blue
b_lpurple='\[\e[105m\]'    # Light Purple
b_lcyan='\[\e[106m\]'      # Light Cyan
b_white='\[\e[107m\]'      # White

black_on_white="${f_black}${b_white}"
blue_on_white="${f_blue}${b_white}"
cyan_on_white="${f_cyan}${b_white}"
green_on_gray="${f_green}${b_gray}"
green_on_red="${f_green}${b_red}"
yellow_on_white="${f_yellow}${b_white}"
red_on_white="${f_red}${b_white}"
red_on_black="${f_red}${b_black}"
black_on_red="${f_black}${b_red}"
white_on_red="${f_white}${b_red}"
gray_on_red="${f_white}${b_red}"
yellow_on_red="${f_yellow}${b_red}"
lblue_on_gray="${f_lblue}${b_gray}"

# powerline symbols
sym_left_sep=''
#irline_left_alt_sep = ''
sym_right_sep=''
#irline_right_alt_sep = ''
#set sym_branch=''
#irline_symbols.readonly = ''
#irline_symbols.linenr = '☰'
#irline_symbols.maxlinenr = ''

# Foreground
declare -A TXT_COLORS=(
    [Color_Off]='\[\e[0m\]'    # Text Reset
    [Default]='\[\e[39m\]'     # Default text color
    [Black]='\[\e[30m\]'       # Black

    [Red]='\[\e[31m\]'         # Red
    [Green]='\[\e[32m\]'       # Green
    [Yellow]='\[\e[33m\]'      # Yellow
    [Blue]='\[\e[34m\]'        # Blue
    [Purple]='\[\[\e[35m\]'      # Purple
    [Cyan]='\[\e[36m\]'        # Cyan
    [Gray]='\[\e[90m\]'        # Gray

    [LGray]='\[\e[37m\]'       # Light Gray
    [LRed]='\[\e[91m\]'        # Light Red
    [LGreen]='\[\e[92m\]'      # Light Green
    [LYellow]='\[\e[93m\]'     # Light Yellow
    [LBlue]='\[\e[94m\]'       # Light Blue
    [LPurple]='\[\e[95m\]'     # Light Purple
    [LCyan]='\[\e[96m\]'       # Light Cyan
    [White]='\[\e[97m\]'       # White
    )
# Background
declare -A BG_COLORS=(
    [Default]='\[\e[49m\]'     # Default bg color
    [Black]='\[\e[40m\]'       # Black
    [Red]='\[\e[41m\]'         # Red
    [Green]='\[\e[42m\]'       # Green
    [Yellow]='\[\e[43m\]'      # Yellow
    [Blue]='\[\e[44m\]'        # Blue
    [Purple]='\[\e[45m\]'      # Purple
    [Cyan]='\[\e[46m\]'        # Cyan
    [LGray]='\[\e[47m\]'       # Light Gray

    [Gray]='\[\e[100m\]'       # Dark gray
    [LRed]='\[\e[101m\]'       # Light Red
    [LGreen]='\[\e[102m\]'     # Light Green
    [LYellow]='\[\e[103m\]'    # Light Yellow
    [LBlue]='\[\e[104m\]'      # Light Blue
    [LPurple]='\[\e[105m\]'    # Light Purple
    [LCyan]='\[\e[106m\]'      # Light Cyan
    [White]='\[\e[107m\]'      # White
)

declare -A P_SYMBOLS=(
    [finger]='\U1f449'
    [beta]='\U3b2'
    [lambda]='\U3bb'
    [left_sep]=''
    [right_sep]=''
    [branch]=''
    [readonly]=''
    )

declare -A GIT_SYMBOLS=(
    [branch]=""
    [untracked]="↔"
    [stash]="§"
    [ahead]="↑"
    [behind]="↓"
    [modified]="✚"
    [staged]="✔"
    [conflicts]="✘"
)

STATUS_CLEAN=0
STATUS_DIRTY=-1

function enrich_append {
    local symbol=$1
    local color=$2
    echo -en "${color}${symbol} "
    #prompt="${black_on_white} "
    #prompt+=$(enrich_append $is_a_git_repo $omg_is_a_git_repo_symbol "${black_on_white}")
    #prompt+=$(enrich_append $has_stashes $omg_has_stashes_symbol "${yellow_on_white}")
}

function git_status {
    local status="$(git status -s 2> /dev/null | sed -e '/^[^ M]/d' -e '/^[^M]/d')"
    if [ -z "$status" ]
        then
            return $STATUS_CLEAN
    else
        return $STATUS_DIRTY
    fi
}

set_prompt_symbol_2() {
    local pop="$(tput setaf 46)${P_SYMBOLS[1]}|${P_SYMBOLS[8]}\e[0m"
    printf "$(tput setaf 46)\U3bb\e[0m "

    #printf ${pop}
    #printf -- '%s' ${pop}
    return 0
}

set_prompt_symbol() {
    local p='\U1f449'
    local beta='\U3b2'
    local lambda='\U3bb'
    local turnedY='\U2144'

    git_status
    status=$?
    if [ "$status" -ne $STATUS_DIRTY ]
        then
            echo -e "$(tput setaf 46)$lambda \e[0m"
    else
        echo -e "$(tput setaf 46)$beta \e[0m"
    fi
    return $status
}

set_cur_dir_str() {
    local prompt="$cyan_on_white\w"
    prompt+=$(enrich_append ${P_SYMBOLS[left_sep]} ${white_on_red})
    #prompt+=$(enrich_append $sym_left_sep ${white_on_red})
    echo -n ${prompt}
    #printf "$cyan_on_white\w$white_on_red$sym_left_sep"
}

set_git_status_icon() {
    local icon=$(enrich_append $1 $2)
    echo -en $icon
}


function build_git_prompt {
    local __git_branch_color="${blue_on_white}"
    local __git_branch="$(__git_ps1)";  

    # colour branch name depending on state
    if [[ "$(__git_ps1)" =~ "*" ]]; then           # if repository is dirty
        printf "$(tput setab 15)$(tput setaf 88)$__git_branch$(tput sgr0)"
    elif [[ "$(__git_ps1)" =~ "$" ]]; then         # if there is something stashed
        #prompt="$(enrich_append $__git_branch$ ${blue_on_white})"
        printf "$(tput setab 15)$(tput setaf 25)$__git_branch$(tput sgr0)"
        #printf "$__git_branch_color$__git_branch$(tput sgr0)"
    elif [[ "$(__git_ps1)" =~ "%" ]]; then         # if there are only untracked files
        printf "$(tput setab 15)$(tput setaf 165)$__git_branch$(tput sgr0)"
    elif [[ "$(__git_ps1)" =~ "+" ]]; then         # if there are staged files
        printf "$(tput setab 15)$(tput setaf 45)$__git_branch$(tput sgr0)"
    elif [[ "$(__git_ps1)" =~ "=" ]]; then         # no difference between the head and the up-stream
        printf "$(tput setab 15)$(tput setaf 35)$__git_branch$(tput sgr0)"
    elif [[ "$(__git_ps1)" =~ "<" ]]; then         # local head is behind
        printf "$(tput setab 15)$(tput setaf 14)$__git_branch$(tput sgr0)"
    elif [[ "$(__git_ps1)" =~ ">" ]]; then         # local head is ahead
        printf "$(tput setab 15)$(tput setaf 11)$__git_branch$(tput sgr0)"
    elif [[ "$(__git_ps1)" =~ "<>" ]]; then         # diverged head
        printf "$(tput setab 15)$(tput setaf 9)$__git_branch$(tput sgr0)"
    fi

    #local prompt=`__git_ps1`
    #prompt=$(enrich_append $prompt $__git_branch_color)
    #echo -en $prompt$f_ColorOff
}

if test -f ~/.config/git/git-prompt.sh
then
	. ~/.config/git/git-prompt.sh
else
	PS1='\[\033]0;$TITLEPREFIX:$PWD\007\]' # set window title
    PS1="${PS1}"$f_lred"\342\224\214\342\224\200"
	#PS1="$PS1"$f_lmagenta'┌'
	PS1="$PS1"`set_cur_dir_str`$(set_git_status_icon ${GIT_SYMBOLS[branch]} "$f_green")
    PS1+=$sym_branch$(set_git_status_icon ${P_SYMBOLS[left_sep]} "$red_on_white")
    #`set_git_status_icon ${P_SYMBOLS[left_sep]} "$white_on_red"`
    #PS1="$PS1"'\w'$(tput sgr0)                 # current working directory
	if test -z "$WINELOADERNOEXEC"
	then
		GIT_EXEf_PATH="$(git --exec-path 2>/dev/null)"
		COMPLETION_PATH="${GIT_EXEf_PATH%/libexec/git-core}"
		COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
		GITPROMPT_PATH="$COMPLETION_PATH"
		COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
		if test -f "$COMPLETION_PATH/git-prompt.sh"
		then
            GIT_PS1_SHOWDIRTYSTATE=true
            GIT_PS1_SHOWSTASHSTATE=true
            GIT_PS1_SHOWUNTRACKEDFILES=true
            GIT_PS1_SHOWUPSTREAM="auto"
            GIT_PS1_HIDE_IF_PWD_IGNORED=true
            GIT_PS1_SHOWCOLORHINTS=true
			. "$COMPLETION_PATH/git-completion.bash"
			. "$COMPLETION_PATH/git-prompt.sh"
            #PS1="$PS1"$f_lred' |'"$(set_git_string_color)"'`__git_ps1`'
            #PS1="$PS1"'`__git_ps1`'
            PS1="$PS1"'`build_git_prompt`'$(set_git_status_icon ${P_SYMBOLS[left_sep]} "$white_on_black")
		fi
	fi
	PS1="$PS1"'\n'                 # new line
	PS1="${PS1}"$f_lred"\342\224\224\342\224\200\342\224\200"
	PS1="$PS1"$c_clear'`set_prompt_symbol_2`'
	#PS1="$PS1"$c_clear'`set_prompt_symbol`'
	PS1="$PS1"$c_clear        # reset color
fi

MSYS2_PS1="$PS1"               # for detection by MSYS2 SDK's bash.basrc
