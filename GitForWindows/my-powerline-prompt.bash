##
## base
##

# ===================
# ===== SYMBOLS =====
# ===================
declare -A P_SYMBOLS=(
    [finger]="\U1f449"
    [beta]="\U3b2"
    [lambda]="\U3bb"
	[linux]=""
)
declare -A PWRLN_SYMBOLS=(
    [left_sep]=""
    [right_sep]=""
    [left_soft_divider]=""
    [right_soft_divider]=""
    [branch]=""
    [readonly]=""
	[right_half_circle_thick]=""
	[right_half_circle_thin]=""
	[left_half_circle_thick]=""
	[left_half_circle_thin]=""
	[flame_thick]=""
	[flame_thin]=""
	[flame_thick_mirror]=""
	[flame_thin_mirror]=""
)

declare -A GIT_SYMBOLS=(
    [git]=""
	[git2]=""
	[branch]=""
    [untracked]="↔"
    [stash]="§"
    [ahead]="↑"
    [behind]="↓"
    [modified]="✚"
    [staged]="✔"
    [conflicts]="✘"
	[pull_request]=""
	[merge]=""
	[compare]=""
	[commit]=""
)

: ${pwrprmpt_is_a_git_repo_symbol:=''}
: ${pwrprmpt_has_untracked_files_symbol:='↔'}
: ${pwrprmpt_has_adds_symbol:=''}
: ${pwrprmpt_has_deletions_symbol:=''}
: ${pwrprmpt_has_cached_deletions_symbol:=''}
: ${pwrprmpt_has_modifications_symbol:='✚'}
: ${pwrprmpt_has_cached_modifications_symbol:='✚'}
: ${pwrprmpt_ready_to_commit_symbol:=''}
: ${pwrprmpt_is_on_a_tag_symbol:=''}
: ${pwrprmpt_needs_to_merge_symbol:=''}
: ${pwrprmpt_detached_symbol:=''}
: ${pwrprmpt_can_fast_forward_symbol:='﯐'}
: ${pwrprmpt_has_diverged_symbol:=''}
: ${pwrprmpt_not_tracked_branch_symbol:=''}
: ${pwrprmpt_rebase_tracking_branch_symbol:=''}
: ${pwrprmpt_merge_tracking_branch_symbol:=''}
: ${pwrprmpt_should_push_symbol:=''}
: ${pwrprmpt_has_stashes_symbol:='§'}

: ${sep_symbol_left:=''}
: ${sep_symbol_right:=''}
: ${inner_sep_symbol_left:=''}
: ${inner_sep_symbol_right:=''}

# ===================
# ===== COLORS =====
# ===================
coloroff='\033[0m'

# Foreground - 256 colors
declare -A FG_COLORS=(
    [Black]="\[\033[38;5;0m\]"

    [Red]="\[\033[38;5;1m\]"
    [Green]="\[\033[38;5;2m\]"
    [Yellow]="\[\033[38;5;3m\]"
    [Blue]="\[\033[38;5;4m\]"
    [Purple]="\[\[\033[38;5;5m\]"
    [Cyan]="\[\033[38;5;6m\]"
    [Gray]="\[\033[38;5;7m\]"

    [LGray]="\[\033[38;5;8m\]"
    [LRed]="\[\033[38;5;9m\]"
    [LGreen]="\[\033[38;5;10m\]"
    [LYellow]="\[\033[38;5;11m\]"
    [LBlue]="\[\033[38;5;12m\]"
    [LPurple]="\[\033[38;5;13m\]"
    [LCyan]="\[\033[38;5;14m\]"
    [White]="\[\033[38;5;15m\]"

	[Custom1]="\[\033[38;5;81m\]"
	[Custom2]="\[\033[38;5;200m\]"
	[Gold]="\[\033[38;5;220m\]"
	[Custom3]="\[\033[38;5;226m\]"
)
# Background - 256 colors
declare -A BG_COLORS=(
    [Black]="\[\033[48;5;0m\]"
    [Red]="\[\033[48;5;1m\]"
    [Green]="\[\033[48;5;2m\]"
    [Yellow]="\[\033[48;5;3m\]"
    [Blue]="\[\033[48;5;4m\]"
    [Purple]="\[\033[48;5;5m\]"
    [Cyan]="\[\033[48;5;6m\]"
    [LGray]="\[\033[48;5;7m\]"

    [Gray]="\[\033[48;5;8m\]"
    [LRed]="\[\033[48;5;9m\]"
    [LGreen]="\[\033[48;5;10m\]"
    [LYellow]="\[\033[48;5;11m\]"
    [LBlue]="\[\033[48;5;12m\]"
    [LPurple]="\[\033[48;5;13m\]"
    [LCyan]="\[\033[48;5;14m\]"
    [White]="\[\033[48;5;15m\]"

	[Custom1]="\[\033[48;5;81m\]"   #Cyan-blue
	[Custom2]="\[\033[48;5;200m\]"  #fuschia
	[Gold]="\[\033[48;5;220m\]"
	[Custom3]="\[\033[48;5;226m\]"  #bright yellow
)

: ${black_on_white:="${FG_COLORS[Black]}${BG_COLORS[White]}"}
: ${black_on_cyan:="${FG_COLORS[Black]}${BG_COLORS[Cyan]}"}
: ${white_on_red:="${FG_COLORS[White]}${BG_COLORS[Red]}"}
: ${bwhite_on_brightblue:="${FG_COLORS[White]}${BG_COLORS[LBlue]}"}

# custom colors
: ${white_on_custom1:="${FG_COLORS[White]}${BG_COLORS[Custom1]}"}
: ${black_on_custom1:="${FG_COLORS[Black]}${BG_COLORS[Custom1]}"}

: ${cyan_on_white:="${coloroff}${FG_COLORS[Cyan]}${BG_COLORS[White]}"}
: ${cyan_on_black:="${coloroff}${FG_COLORS[Cyan]}${BG_COLORS[Black]}"}
: ${gold_on_white:="${coloroff}${FG_COLORS[Gold]}${BG_COLORS[White]}"}
: ${red_on_white:="${coloroff}${FG_COLORS[LRed]}${BG_COLORS[White]}"}

: ${pwrprmpt_default_color_on:='${FG_COLORS[Gray]}'}
#: ${pwrprmpt_default_color_off:='\[\033[0m\]'}
: ${pwrprmpt_last_symbol_color:="${coloroff}${FG_COLORS[Custom1]}"}

# ==========================
# ===== FUNCTION Def'n =====
# ==========================
function enrich {
    local flag=$1
    local symbol=$2

    local color_on=${3:-$pwrprmpt_default_color_on}

    if [[ $flag != true && $pwrprmpt_use_color_off == false ]]; then symbol=' '; fi
    if [[ $flag == true ]]; then local color=$color_on; else local color=$pwrprmpt_default_color_off; fi    

    echo -n "${color}${symbol}${coloroff} "
    #echo -n "${prompt}${color}${symbol}${coloroff} "
}

function get_current_action () {
    local info="$(git rev-parse --git-dir 2>/dev/null)"
    if [ -n "$info" ]; then
        local action
        if [ -f "$info/rebase-merge/interactive" ]
        then
            action=${is_rebasing_interactively:-"rebase -i"}
        elif [ -d "$info/rebase-merge" ]
        then
            action=${is_rebasing_merge:-"rebase -m"}
        else
            if [ -d "$info/rebase-apply" ]
            then
                if [ -f "$info/rebase-apply/rebasing" ]
                then
                    action=${is_rebasing:-"rebase"}
                elif [ -f "$info/rebase-apply/applying" ]
                then
                    action=${is_applying_mailbox_patches:-"am"}
                else
                    action=${is_rebasing_mailbox_patches:-"am/rebase"}
                fi
            elif [ -f "$info/MERGE_HEAD" ]
            then
                action=${is_merging:-"merge"}
            elif [ -f "$info/CHERRY_PICK_HEAD" ]
            then
                action=${is_cherry_picking:-"cherry-pick"}
            elif [ -f "$info/BISECT_LOG" ]
            then
                action=${is_bisecting:-"bisect"}
            fi
        fi

        if [[ -n $action ]]; then printf "%s" "${1-}$action${2-}"; fi
    fi
}

function build_prompt {
    local enabled=`git config --get oh-my-git.enabled`
    if [[ ${enabled} == false ]]; then
        echo "${PSORG}"
        exit;
    fi

    local prompt=""
    
    # Git info
    local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
    if [[ -n $current_commit_hash ]]; then local is_a_git_repo=true; fi
    
    if [[ $is_a_git_repo == true ]]; then
        local current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
        if [[ $current_branch == 'HEAD' ]]; then local detached=true; fi

        local number_of_logs="$(git log --pretty=oneline -n1 2> /dev/null | wc -l)"
        if [[ $number_of_logs -eq 0 ]]; then
            local just_init=true
        else
            local upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
            if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then local has_upstream=true; fi

            local git_status="$(git status --porcelain 2> /dev/null)"
            local action="$(get_current_action)"

            if [[ $git_status =~ ($'\n'|^).M ]]; then local has_modifications=true; fi
            if [[ $git_status =~ ($'\n'|^)M ]]; then local has_modifications_cached=true; fi
            if [[ $git_status =~ ($'\n'|^)A ]]; then local has_adds=true; fi
            if [[ $git_status =~ ($'\n'|^).D ]]; then local has_deletions=true; fi
            if [[ $git_status =~ ($'\n'|^)D ]]; then local has_deletions_cached=true; fi
            if [[ $git_status =~ ($'\n'|^)[MAD] && ! $git_status =~ ($'\n'|^).[MAD\?] ]]; then local ready_to_commit=true; fi

            local number_of_untracked_files=$(\grep -c "^??" <<< "${git_status}")
            if [[ $number_of_untracked_files -gt 0 ]]; then
                local has_untracked_files=true
            fi
        
            local tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
            if [[ -n $tag_at_current_commit ]]; then
                local is_on_a_tag=true
            fi
        
            if [[ $has_upstream == true ]]; then
                local commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
                local commits_ahead=$(\grep -c "^<" <<< "$commits_diff")
                local commits_behind=$(\grep -c "^>" <<< "$commits_diff")
            fi

            if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then local has_diverged=true; fi
            if [[ $has_diverged == false && $commits_ahead -gt 0 ]]; then local should_push=true; fi
        
            local will_rebase=$(git config --get branch.${current_branch}.rebase 2> /dev/null)
        
            local number_of_stashes="$(git stash list -n1 2> /dev/null | wc -l)"
            if [[ $number_of_stashes -gt 0 ]]; then local has_stashes=true; fi
        fi
    fi
    
    echo "$(custom_build_prompt ${enabled:-true} ${current_commit_hash:-""} ${is_a_git_repo:-false} ${current_branch:-""} ${detached:-false} ${just_init:-false} ${has_upstream:-false} ${has_modifications:-false} ${has_modifications_cached:-false} ${has_adds:-false} ${has_deletions:-false} ${has_deletions_cached:-false} ${has_untracked_files:-false} ${ready_to_commit:-false} ${tag_at_current_commit:-""} ${is_on_a_tag:-false} ${has_upstream:-false} ${commits_ahead:-false} ${commits_behind:-false} ${has_diverged:-false} ${should_push:-false} ${will_rebase:-false} ${has_stashes:-false} ${action})"
    
}

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

function eval_prompt_callback_if_present {
    function_exists pwrprmpt_prompt_callback && echo "$(pwrprmpt_prompt_callback)"
}

function enrich_append {
    local flag=$1
    local symbol=$2
    local color=${3:-$pwrprmpt_default_color_on}

    if [[ $flag != false ]]
    then
        echo -n "${color}${symbol}"
    fi
}

function custom_build_prompt {
    local enabled=${1}
    local current_commit_hash=${2}
    local is_a_git_repo=${3}
    local current_branch=$4
    local detached=${5}
    local just_init=${6}
    local has_upstream=${7}
    local has_modifications=${8}
    local has_modifications_cached=${9}
    local has_adds=${10}
    local has_deletions=${11}
    local has_deletions_cached=${12}
    local has_untracked_files=${13}
    local ready_to_commit=${14}
    local tag_at_current_commit=${15}
    local is_on_a_tag=${16}
    local has_upstream=${17}
    local commits_ahead=${18}
    local commits_behind=${19}
    local has_diverged=${20}
    local should_push=${21}
    local will_rebase=${22}
    local has_stashes=${23}

    local prompt=""
    local original_prompt=$PS1
    

    # Flags
    local pwrprmpt_default_color_on="${black_on_white}"

    # show current working directory: cyan bg
    prompt="${coloroff}$(tput setaf 10)\342\224\214\342\224\200${black_on_cyan}\w "
    
    if [[ $is_a_git_repo == true ]]; then
        #prompt+=$(enrich_append "true" ${sep_symbol_left} ${cyan_on_white})
        prompt+=$(enrich_append "true" ${inner_sep_symbol_left} ${cyan_on_white})
        prompt+="${black_on_white} "
        # show git status symbols: white bg
        prompt+=$(enrich_append $is_a_git_repo $pwrprmpt_is_a_git_repo_symbol "${black_on_white}")
        prompt+=$(enrich_append $has_stashes $pwrprmpt_has_stashes_symbol "${gold_on_white}")
        prompt+=$(enrich_append $has_untracked_files $pwrprmpt_has_untracked_files_symbol "${red_on_white}")
        prompt+=$(enrich_append $has_modifications $pwrprmpt_has_modifications_symbol "${red_on_white}")
        prompt+=$(enrich_append $has_deletions $pwrprmpt_has_deletions_symbol "${red_on_white}")
        
        # ready
        prompt+=$(enrich_append $has_adds $pwrprmpt_has_adds_symbol "${black_on_white}")
        prompt+=$(enrich_append $has_modifications_cached $pwrprmpt_has_cached_modifications_symbol "${black_on_white}")
        prompt+=$(enrich_append $has_deletions_cached $pwrprmpt_has_cached_deletions_symbol "${black_on_white}")
        
        # next operation
        prompt+=$(enrich_append $ready_to_commit $pwrprmpt_ready_to_commit_symbol "${red_on_white}")

        # show git branch name: custom bg color
        local git_branch_default_color="${black_on_custom1}"

        #prompt+=$(enrich_append "true" ${sep_symbol_left} ${white_on_custom1})
        prompt+=$(enrich_append "true" ${inner_sep_symbol_left} ${white_on_custom1})

        if [[ $detached == true ]]; then
            # detached HEAD
            prompt+=$(enrich_append $detached $pwrprmpt_detached_symbol "${white_on_red}")
            prompt+=$(enrich_append $detached "(${current_commit_hash:0:7})" "${git_branch_default_color}")
        else            
            if [[ $has_upstream == false ]]; then
                # branch is not tracked
                prompt+=$(enrich_append true "-- ${pwrprmpt_not_tracked_branch_symbol}  --  (${current_branch})" "${git_branch_default_color}")
            else
                if [[ $will_rebase == true ]]; then
                    local type_of_upstream=$pwrprmpt_rebase_tracking_branch_symbol
                else
                    local type_of_upstream=$pwrprmpt_merge_tracking_branch_symbol
                fi

                if [[ $has_diverged == true ]]; then
                    prompt+=$(enrich_append true "-${commits_behind} ${pwrprmpt_has_diverged_symbol} +${commits_ahead}" "${white_on_red}")
                else
                    if [[ $commits_behind -gt 0 ]]; then
                        prompt+=$(enrich_append true "-${commits_behind} ${git_branch_default_color}${pwrprmpt_can_fast_forward_symbol}${git_branch_default_color} --" "${git_branch_default_color}")
                    fi
                    if [[ $commits_ahead -gt 0 ]]; then
                        prompt+=$(enrich_append true "-- ${git_branch_default_color}${pwrprmpt_should_push_symbol}${git_branch_default_color}  +${commits_ahead}" "${git_branch_default_color}")
                    fi
                    if [[ $commits_ahead == 0 && $commits_behind == 0 ]]; then
                        prompt+=$(enrich_append true " --   -- " "${git_branch_default_color}")
                    fi
                    
                fi
                #prompt+=$(enrich_append true "(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})" "${git_branch_default_color}")
                prompt+=$(enrich_append true "${current_branch} " "${git_branch_default_color}")
                #prompt+=$(enrich_append true "${sep_symbol_right}" "$(tput setaf 226)")
                prompt+=$(enrich_append true "${inner_sep_symbol_right}" "$(tput setaf 226)")
                
                prompt+=$(enrich_append true " ${type_of_upstream} " "$(tput sgr0)$(tput setaf 0)$(tput setab 226)")
                #prompt+=$(enrich_append true "${sep_symbol_left} " "$(tput sgr0)$(tput setaf 226)$(tput setab 200)")
                prompt+=$(enrich_append true "${inner_sep_symbol_left} " "$(tput sgr0)$(tput setaf 226)$(tput setab 200)")

                prompt+=$(enrich_append true "${upstream//\/$current_branch/} " "$(tput setaf 15)")
                pwrprmpt_last_symbol_color=${coloroff}$(tput setaf 200)
            fi
        fi
        prompt+=$(enrich_append ${is_on_a_tag} "${pwrprmpt_is_on_a_tag_symbol} ${tag_at_current_commit}" "${git_branch_default_color}")
        prompt+=$(enrich_append true ${sep_symbol_left} "${pwrprmpt_last_symbol_color}")
        prompt+="${coloroff}\n"
        #prompt+="${pwrprmpt_last_symbol_color}${coloroff}\n"
        #prompt+="$(eval_prompt_callback_if_present)"
        #prompt+="${pwrprmpt_second_line}"
    else
        prompt+="$(enrich_append true "${sep_symbol_left}" "$(tput sgr0)$(tput setaf 6)")"
        #prompt+="${black_on_white} "
        #prompt+="$(eval_prompt_callback_if_present)\n"
        #prompt+="${pwrprmpt_ungit_prompt}${coloroff}\n"
        prompt+="${coloroff}\n"
    fi
    #prompt+="${pwrprmpt_second_line}"

    echo "${prompt}"
}

function set_prompt_symbol {
    local color_1="${FG_COLORS[LRed]}${BG_COLORS[White]}"
    local color_2="${FG_COLORS[White]}"

    local pwr_symbol="${PWRLN_SYMBOLS[left_sep]}"
    local prmpt_symbol="${GIT_SYMBOLS[git]}"
    echo -en "$color_1 ${prmpt_symbol} $coloroff$color_2${pwr_symbol} $coloroff"
}

function second_line_prompt {
    local prmpt_symbol="${PWRLN_SYMBOLS[left_soft_divider]} "
    pwrprmpt_second_line+="$(enrich_append true "${prmpt_symbol}" "${coloroff}${FG_COLORS[LGreen]}")"
    #pwrprmpt_second_line+="$(enrich_append true " " "$(tput sgr0)")"
    pwrprmpt_second_line+="$(enrich_append true "" "$(tput sgr0)")"
    printf "${pwrprmpt_second_line}"
}

function bash_prompt() {
    PS1="$(build_prompt)"
    #PS1="${PS1}$(second_line_prompt)"
    PS1="${PS1}${pwrprmpt_second_line}"
}

# ======================
# ===== Main ===========
# ======================
##
## prompt
##
PSORG=$PS1;
PROMPT_COMMAND_ORG=$PROMPT_COMMAND;

PROMPT='$(build_prompt)'
RPROMPT='%{$reset_color%}%T %{$fg_bold[white]%} %n@%m%{$reset_color%}'

: ${pwrprmpt_ungit_prompt:=$PS1}
: ${pwrprmpt_second_line="${coloroff}${FG_COLORS[LGreen]}\342\224\224\342\224\200`second_line_prompt`"}
#: ${pwrprmpt_second_line:="${coloroff}${FG_COLORS[LGreen]}\342\224\224\342\224\200`set_prompt_symbol`"}


PS2="${yellow}→${coloroff} "
PROMPT_COMMAND="bash_prompt"
#PROMPT_COMMAND="bash_prompt; $PROMPT_COMMAND_ORG"
