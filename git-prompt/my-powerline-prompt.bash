PSORG=$PS1;
PROMPT_COMMAND_ORG=$PROMPT_COMMAND;

if [ -n "${BASH_VERSION}" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source ${DIR}/my-powerline-base.bash

    # foreground
    : ${black:='\e[0;30m'}
    : ${red:='\e[0;31m'}
    : ${green:='\e[0;32m'}
    : ${yellow:='\e[0;33m'}
    : ${blue:='\e[0;34m'}
    : ${purple:='\e[0;35m'}
    : ${cyan:='\e[0;36m'}
    : ${gray:='\e[0;37m'}

    : ${bred:='\e[0;91m'}
    : ${bgreen:='\e[0;92m'}
    : ${byellow:='\e[0;93m'}
    : ${bblue:='\e[0;94m'}
    : ${bpurple:='\e[0;95m'}
    : ${bcyan:='\e[0;96m'}
    : ${bwhite:='\e[0;97m'}

    #background
    : ${background_black:='\e[40m'}
    : ${background_red:='\e[41m'}
    : ${background_green:='\e[42m'}
    : ${background_yellow:='\e[43m'}
    : ${background_blue:='\e[44m'}
    : ${background_purple:='\e[45m'}
    : ${background_cyan:='\e[46m'}
    : ${background_white:='\e[107m'}
    : ${background_gray:='\e[100m'}
    : ${background_brightgreen:='\e[102m'}
    : ${background_brightblue:='\e[104m'}

    : ${reset:='\e[0m'}

    : ${black_on_white:="${black}${background_white}"}
    : ${black_on_red:="${black}${background_red}"}
    : ${black_on_yellow:="${black}${background_yellow}"}
    : ${black_on_cyan:="${black}${background_cyan}"}
    : ${black_on_brightgreen:="${black}${background_brightgreen}"}
    : ${white_on_red:="${bwhite}${background_red}"}
    : ${bwhite_on_blue:="${bwhite}${background_blue}"}
    : ${bwhite_on_brightblue:="${bwhite}${background_brightblue}"}
    : ${white_on_purple:="${bwhite}${background_purple}"}

    : ${cyan_on_white:="${cyan}${background_white}"}
    : ${yellow_on_white:="${yellow}${background_white}"}
    : ${red_on_white:="${red}${background_white}"}    

    : ${omg_ungit_prompt:=$PS1}
    : ${omg_second_line:="$bgreen\342\224\224\342\224\200\342\224\200`set_prompt_symbol`$reset"}

    : ${omg_is_a_git_repo_symbol:=''}
    : ${omg_has_untracked_files_symbol:=''}
    : ${omg_has_adds_symbol:=''}
    : ${omg_has_deletions_symbol:=''}
    : ${omg_has_cached_deletions_symbol:=''}
    : ${omg_has_modifications_symbol:=''}
    : ${omg_has_cached_modifications_symbol:=''}
    : ${omg_ready_to_commit_symbol:=''}
    : ${omg_is_on_a_tag_symbol:=''}
    : ${omg_needs_to_merge_symbol:='ᄉ'}
    : ${omg_detached_symbol:=''}
    : ${omg_can_fast_forward_symbol:=''}
    : ${omg_has_diverged_symbol:=''}
    : ${omg_not_tracked_branch_symbol:=''}
    : ${omg_rebase_tracking_branch_symbol:=''}
    : ${omg_merge_tracking_branch_symbol:=''}
    : ${omg_should_push_symbol:=''}
    : ${omg_has_stashes_symbol:=''}

    : ${omg_default_color_on:='\[\033[1;37m\]'}
    : ${omg_default_color_off:='\[\033[0m\]'}
    #: ${omg_last_symbol_color:='\e[0;31m\e[40m'}
    : ${omg_last_symbol_color:='\e[0m\e[0;34m'}

    
    PROMPT='$(build_prompt)'
    RPROMPT='%{$reset_color%}%T %{$fg_bold[white]%} %n@%m%{$reset_color%}'

    function enrich_append {
        local flag=$1
        local symbol=$2
        local color=${3:-$omg_default_color_on}

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
        local omg_default_color_on="${black_on_white}"

        prompt="$bgreen\342\224\214\342\224\200${black_on_cyan}\w ${cyan_on_white}${black_on_white} "
        if [[ $is_a_git_repo == true ]]; then
            # on filesystem
            prompt+=$(enrich_append $is_a_git_repo $omg_is_a_git_repo_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_stashes $omg_has_stashes_symbol "${yellow_on_white}")

            prompt+=$(enrich_append $has_untracked_files $omg_has_untracked_files_symbol "${red_on_white}")
            prompt+=$(enrich_append $has_modifications $omg_has_modifications_symbol "${red_on_white}")
            prompt+=$(enrich_append $has_deletions $omg_has_deletions_symbol "${red_on_white}")
            

            # ready
            prompt+=$(enrich_append $has_adds $omg_has_adds_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_modifications_cached $omg_has_cached_modifications_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_deletions_cached $omg_has_cached_deletions_symbol "${black_on_white}")
            
            # next operation

            prompt+=$(enrich_append $ready_to_commit $omg_ready_to_commit_symbol "${red_on_white}")

            # where

            local git_branch_default_color="${bwhite_on_brightblue}"

            prompt="${prompt} ${git_branch_default_color} ${git_branch_default_color}"
            if [[ $detached == true ]]; then
                prompt+=$(enrich_append $detached $omg_detached_symbol "${white_on_red}")
                prompt+=$(enrich_append $detached "(${current_commit_hash:0:7})" "${git_branch_default_color}")
            else            
                if [[ $has_upstream == false ]]; then
                    prompt+=$(enrich_append true "-- ${omg_not_tracked_branch_symbol}  --  (${current_branch})" "${git_branch_default_color}")
                else
                    if [[ $will_rebase == true ]]; then
                        local type_of_upstream=$omg_rebase_tracking_branch_symbol
                    else
                        local type_of_upstream=$omg_merge_tracking_branch_symbol
                    fi

                    if [[ $has_diverged == true ]]; then
                        prompt+=$(enrich_append true "-${commits_behind} ${omg_has_diverged_symbol} +${commits_ahead}" "${white_on_red}")
                    else
                        if [[ $commits_behind -gt 0 ]]; then
                            prompt+=$(enrich_append true "-${commits_behind} ${git_branch_default_color}${omg_can_fast_forward_symbol}${git_branch_default_color} --" "${git_branch_default_color}")
                        fi
                        if [[ $commits_ahead -gt 0 ]]; then
                            prompt+=$(enrich_append true "-- ${git_branch_default_color}${omg_should_push_symbol}${git_branch_default_color}  +${commits_ahead}" "${git_branch_default_color}")
                        fi
                        if [[ $commits_ahead == 0 && $commits_behind == 0 ]]; then
                            prompt+=$(enrich_append true " --   -- " "${git_branch_default_color}")
                        fi
                        
                    fi
                    prompt+=$(enrich_append true "(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})" "${git_branch_default_color}")
                fi
            fi
            prompt+=$(enrich_append ${is_on_a_tag} "${omg_is_on_a_tag_symbol} ${tag_at_current_commit}" "${git_branch_default_color}")
            prompt+="${reset}${bblue}${reset}\n"
            #prompt+="${omg_last_symbol_color}${reset}\n"
            prompt+="$(eval_prompt_callback_if_present)"
            #prompt+="${omg_second_line}"
        else
            prompt+="$(eval_prompt_callback_if_present)\n"
            #prompt+="${omg_ungit_prompt}\n"
        fi
        prompt+="${omg_second_line}"

        echo "${prompt}"
    }
    
    PS2="${yellow}→${reset} "

    function bash_prompt() {
        local prompt_symbol="\U3bb"

        PS1="$(build_prompt)"
        #PS1="$(build_prompt)"$bgreen"\342\224\224\342\224\200\342\224\200"
        #PS1="$PS1`set_prompt_symbol`$reset"
    }

    PROMPT_COMMAND="bash_prompt"
    #PROMPT_COMMAND="bash_prompt; $PROMPT_COMMAND_ORG"

fi
