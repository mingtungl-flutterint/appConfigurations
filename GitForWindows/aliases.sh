# Some good standards, which are not used if the user
# creates his/her own .bashrc/.bash_profile

# --show-control-chars: help showing Korean or accented characters
alias ls='ls -Fh --color=auto --show-control-chars '
alias la='ls -AC --width=120'
alias ll='ls -lgG '
alias lr='la -R '
alias h='history '
alias refreshBash='source /etc/profile'
alias sourceBash='source /etc/profile'
#######################################################################################################
# git aliases
#######################################################################################################
function printUsage() {
    #local a=$1
    #printf "${a[*]}\n"
    printf "${*}\n"
    return 55
}
testPrint() {
     local a=("## git merge-base: finds best common ancestor(s) between two commits\n"
     "    Usage: testPrint [-h|h|help] [-m|m|master] [-c|c|commit <hash>]\n"
     "\th|help           -- Print this help\n"
     "\tc|commit <hash>  -- Find the ancestor of <commit> and current HEAD\n"
     "\tm|master         -- Find the point at which branch forked from master\n")
     case "$1" in
         'h'|'help')
            printUsage "${a[*]}"
            ;;
        *)
            echo -e "\nOK"
            ;;
    esac
    return $?
}

function printHelp_main() {
    local s=("\n ## Frequently used aliases\n"
        " gst         : show repo status\n"
        " gci         : Commit changes\n"
        " gamend      : commit --amend --no-edit\n"
        " gco         : check out a branch\n"
        " gcom        : check out master branch\n"
        " gf          : fetch remote including submodules\n"
        " gbl         : blame - Show what revision and author last modified each line of a file\n"
        " ga          : Add file contents to the index, aka stage\n"
        " gaa         : Add all file in the entire working to the index\n"
        " guidx       : Update file contents which are already staged\n"
        " gbr         : git-branch - List, create, or delete branches\n"
        " ## Push, pull, commits, reset\n"
        " gpbr|gpush  : push changes to remote\n"
        " gget|gpull  : pull from remote tracking branch\n"
        " gpullm|ggetm: pull from remote and update submodules\n"
        " grs         : soft reset\n"
        " grh         : hard reset\n"
        " gunstage    : unstage the last add\n"
        " guncommit   : reverse the last commit\n"
        " glp         : view last commits' diff's\n"
        " glc         : Display last N commits\n"
    )
    printUsage "${s[*]}"
}
function printHelp_logs() {
    local s=(
        " ## Logs\n"
        " glg         : show activity logs with custom pretty format\n"
        " g1l         : show oneline logs with decorate\n"
        " glgf        : show activity logs with modified files (name-status)\n"
        " gtree       : show logs in tree format\n"
        " gtoday      : display current user's today activity logs\n"
        " gyes        : display current user's yesterday activity logs\n"
        " gmylog      : display current user's one line activity logs\n"
        " gmylogext   : display current user's activity logs with modified files\n"
        " glast       : display current user's last commit\n"
        " grflog      : display log with custom pretty format\n"
        " grf         : display reflog with custom output format\n"
    )
    printUsage "${s[*]}"
}
function printHelp_stash() {
    local s=(
        " ## Stash\n"
        " gsl         : list stash elements\n"
        " gsp         : Save local modifications to a new stash entry and roll back to HEAD\n"
        " gsunapply   : undo the last stash apply\n"
        " gsreverse   : aka gsunapply\n"
        " gvs|gss     : Show the changes recorded in the stash entry as a diff between the stashed contents\n"
        " gsa         : Remove a single stashed state from the stash list and apply it on top of the current working tree state\n"
        " gsd         : Remove a single stash entry from the list of stash entries\n"
    )
    printUsage "${s[*]}"
}
function printHelp_merge() {
    local s=(
        " ## Merge\n"
        " gmm         : merge origin/master to current branch\n"
        " gmb         : finds best common ancestor(s) between two commits\n"
        " gcp         : Copy files from <branch name> to the current branch\n"
        " gm|gmerge   : Merge <branch> to current branch\n"
    )
    printUsage "${s[*]}"
}
function printHelp_misc() {
    local s=(
        " ## Miscellaneous\n"
        " gdiff       : Compare files between branches\n"
        " gig|gignore : Exclude locally modified files from index\n"
        " guig|gunignore : Let git manage locally modified files\n"
        " ## to view HEAD's SHA-1 hash\n"
        " gh          : show sha1 hash of references\n"
    )
    printUsage "${s[*]}"
}
function ghelp() {
    local s=(
        " ## git alias help\n"
        " Usage: ghelp main|logs|stash|merge|misc\n"
        " main    : Show help of frequently used aliases\n"
        " logs    : Show help of aliases relating to git log\n"
        " stash   : Show help of aliases relating to git stash\n"
        " merge   : Show help of aliases relating to git merge\n"
        " misc    : Show miscellaneous git aliases\n"
    )
    case "$1" in
        'main')
            printHelp_main
            ;;
        'logs')
            printHelp_logs
            ;;
        'stash')            
            printHelp_stash
            ;;
        'merge')            
            printHelp_merge
            ;;
        'misc')            
            printHelp_misc
            ;;
        'all')
            printHelp_main
            printHelp_logs
            printHelp_stash
            printHelp_merge
            printHelp_misc
            ;;
        *)
            printUsage "${s[*]}"
            ;;
        esac
}

alias gst='git status --branch --show-stash '
## gci = git commit
gci() {
    if [[ $# -eq 0 ]]; then git add $(git diff --name-only --cached) && git commit; return $?; fi
    local flag="$1"
    shift
    case "$flag" in
        'm'|'-m'|'msg')
            git add $(git diff --name-only --cached) && git commit -m "$@"
            ;;
        'h'|'-h'|'help'|*)
            local s=("## Commit changes\n"
                     "    Usage: gci [-h|h|help] [-m|m|msg <commit msg>]\n")
            printUsage "${s[*]}"
            ;;
    esac
    return $?
}

## pushes
alias gpush='git push origin -u HEAD'
## pulls
alias gsmu='git submodule update '
#alias gpull='gs && git pull --rebase=merges '
function gpull() {
    #local CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    case "$1" in
        '-u'|'u'|'update')
            git pull --rebase=merges && gsmu
            ;;
        *)
            git pull --rebase=merges
            ;;
    esac
    return $?
}
#alias gpullm='gpull && gsmu'
alias gamend='git commit --amend --no-edit '
# gco branch-name
gco() {
    local s=("## Check out a branch\n"
             "    Usage: gco [-h|h|help] [-m|m|master\n"
             "\t-                           : check out previous branch\n"
             "\t-h|h|help                   : show help\n"
             "\t-m|m|master                 : check out master\n"
             "\t-b|b|branch <branch name>   : check out master\n"
             "\t-u|u|update                 : combine with m|b to update submodules\n"
             )
    case "$1" in
        '-')
            git checkout -
            ;;
        'm'|'-m'|'master')
            shift
            case "$1" in
                '-u'|'u'|'update')
                    shift
                    git checkout master && gpull update
                    ;;
                *)
                    git checkout master
                    ;;
            esac
            ;;
        'b'|'-b'|'branch')
            shift
            case "$1" in
                '-u'|'u'|'update')
                    shift
                    git checkout "$@" && gpull update
                    ;;
                *)
                    git checkout "$@"
                    ;;
            esac
            ;;
        'h'|'-h'|'help'|*)
            printUsage "${s[*]}"
            ;;
    esac
    return $?
}
alias gf='git fetch --prune --recurse-submodules=yes'
alias gbl='git blame'
## add
alias ga='git add '
alias gaa='git add -A'
alias guidx='git add $(git diff --name-only --cached) '
## branches
#alias gbr='git branch'
gbr() {
    local s=("\n## git-branch - List, create, or delete branches\n"
             "    Usage: gbr [-h|help] [-l|list] [-m|move] [-c|copy] [-d|del]\n"
             "\t-n|n|new <branchname>                 -- Create new branch\n"
             "\t-h|h|help                             -- Print this help\n"
             "\t-l|l|list [-r|remote|-a|all]          -- List existing branches. Use together with -r to list remote branches\n"
             "\t-m|m|move [<oldbranch>] <newbranch>   -- Rename <oldbranch> to <newbranch>\n"
             "\t-M|M|Move [<oldbranch>] <newbranch>   -- Shortcut for --move --force\n"
             "\t-c|c|copy [<oldbranch>] <newbranch>   -- Copy <oldbranch> to <newbranch>\n"
             "\t-C|C|Copy [<oldbranch>] <newbranch>   -- Shortcut for --copy --force\n"
             "\t-d|d|del [-r|remote] <branchname>...  -- Delete <branch> <branch>...  Use together with -r to delete remote-tracking branches\n"
             "\t-D|D|Del <branchname>...              -- <FORCE> Delete branches\n"
    )
    if [[ $# -eq 0 ]]; then git branch --list; return $?; fi
    local flag="$1"
    shift
    case "$flag" in
        '-l'|'l'|'list')                # list branches
            git branch --list "$@"
            ;;
        '-m'|'m'|'move')                # move to another branch
            git branch --move "$@"
            ;;
        '-M'|'M'|'Move')                # forced move
            git branch --move --force "$@"
            ;;
        '-c'|'c'|'copy')                # copy to another branch
            git branch --copy "$@"
            ;;
        '-C'|'C'|'Copy')                # forced copy
            git branch --copy --force "$@"
            ;;
        '-d'|'d'|'del')                 # delete branch
            case "$1" in
                'r'|'-r'|'remote')      # delete remote branch
                    shift
                    git push origin --delete "$@"
                    ;;
                *)                      # delete local branch
                    git branch --delete "$@"
                    ;;
            esac
            ;;
        '-D'|'D'|'Del')                 # forced delete branch
            case "$1" in
                'r'|'-r'|'remote')      # do not forced delete remote branch
                    printUsage "${s[*]}"
                    ;;
                *)
                    git branch --delete --force "$@"
                    ;;
            esac
            ;;
        '-h'|'h'|'help'|*)
            printUsage "${s[*]}"
            ;;
        '-n'|'n'|'new')                              # create a new branch
            git branch --create-reflog "$1"
    esac
    return $?
}

## logs
alias glg='git log --pretty=format:"%C(#cd9a00)%h%C(#0080ff) <%an> %C(#17b062)(%cr) %d%C(#c0d6de)%s" '
alias g1l='glg --oneline --decorate '
alias glgf='glg --name-status '
alias gl1f='glg --name-status '
alias gtree='glg --decorate --graph '
alias gtoday='g1l --since=midnight --author=\"$(git config user.name)\" '
alias gyes='g1l --since=yesterday.midnight --until=midnight --author=\"$(git config user.name)\" '
alias gmylog='glg --author="$(git config user.name)" '
alias gmylogext='gl1f --author="$(git config user.name)" '
alias glast='gl1f --author="$(git config user.name)" -1 HEAD'
alias grflog='git log -g --abbrev-commit --pretty=format:"%C(#ff4040)%h%C(bold #00ff00) %<|(20)%gD %C(reset)%C(dim #fff600)%<(14)%cr %C(reset)%C(italic #ff00ff)%<(80,trunc)%gs %C(reset)%C(#ffbf00)(%s)"'
alias grf='git reflog --format="%C(#ff4040)%h%C(bold #00ff00) %<|(20)%gD %C(reset)%C(dim #fff600)%<(14)%cr %C(reset)%C(italic #ff00ff)%<(80,trunc)%gs %C(reset)%C(#ffbf00)(%s)"'
function glog() {
    case "$1" in
        'ref')
            git log -g --abbrev-commit --pretty=format:"%C(#ff4040)%h%C(bold #00ff00) %<|(20)%gD %C(reset)%C(dim #fff600)%<(14)%cr %C(reset)%C(italic #ff00ff)%<(80,trunc)%gs %C(reset)%C(#ffbf00)(%s)"
            ;;
        *)
            local user="$(git config user.name)"
            case "$1" in
                '1')
                    glg --oneline --decorate
                    ;;
                'f')
                    glg --name-status
                    ;;
                'tree')
                    glg --decorate --graph
                    ;;
                'today')
                    glg --oneline --decorate --since=midnight --author="$user"
                    ;;
                'yes')
                    glg --oneline --decorate --since=yesterday.midnight --author="$user"
                    ;;
                'my')
                    glg --author="$user"
                    ;;
                'last')
                    glg --name-status --author="$user" -1 HEAD
                    ;;
                *)
                    ;;
            esac
            ;;
    esac
}

## view last commits' diff's
#glp() {
#    git log -p "$@"
#}
## glc = glastcommits()
glc() {
    local s=("## Display last N commits\n"
             "    Usage: glc [-h|h|help] [n <number of commits>]\n"
             "\tno argument -- display the last 1 commit\n"
             "\tn <N>       -- display the last N commits\n"
             "\t-h|h|help   -- Print this help\n")
    if [[ $# -eq 0 ]]; then glp -p -1
    else
        case "$1" in
            'h'|'-h'|'help')
                printUsage "${s[*]}"
                ;;
            *)
                git log -p -"$@"
                ;;
        esac
    fi
    return $?
}

## stash
#alias gs='git stash '
alias gsl='git stash list '
gsp() {
    local s=("\n## Save local modifications to a new stash entry and roll back to HEAD\n"
             "    Usage: gsp [-h|h|help] [-m|m|msg] [-k|k|keep-index] [-nk|nk|no-keep-index] [-p|p|patch]\n"
             "\t-h|h|help                        -- Print this help\n"
             "\t-m|m|msg                         -- Stash the changes and name it as msg\n"
             "\t-f|f|file <msg> <file1 file2...> -- Save changes of <files> and name it as msg. Imply --message\n"
             "\t-k|k|keep-index                  -- Stash modified but unstaged files. Staged|index files are left intact. Imply --message\n"
             "\t-nk|nk|no-keep-index             -- Stash staged files. Unstaged files are left intact. Imply --message\n"
             "\t-p|p|patch                       -- Select hunks from modified but unstaged file to stash. Imply --message\n"
            )
    if [[ $# -eq 0 ]]; then printUsage "${s[*]}"; return $?; fi
    local flag="$1"
    shift
    case "$flag" in
        'f'|'-f'|'file')
            local msg="$1"
            shift
            git stash push --message "$msg" -- "$@"
            ;;
        'm'|'-m'|'msg')
            git stash push --message "$@"
            ;;
        'k'|'-k'|'keep-index')       # ** Stash modified but unstaged files. Staged|index files are left intact
            git stash push --keep-index --message "$@"
            ;;
        'nk'|'-nk'|'no-keep-index')   # ** Stash staged files. Unstaged files are left intact
            git stash push --no-keep-index --message "$@"
            ;;
        'p'|'-p'|'patch')            # ** Select hunks from modified but unstaged file to stash
            git stash push --patch --message "$@"
            ;;
        'h'|'-h'|'help'|*)
            printUsage "${s[*]}"
            #printf "\nUsage: gsp [-h|h|help] [-m|m|msg] [-k|k|keep-index] [-nk|nk|no-keep-index] [-p|p|patch]\n"
            ;;
    esac
    return $?
}
alias gsunapply='git stash show -p | git apply -R'
alias gsreverse='git stash show -p | git apply --reverse'
## view contents of the stash
## gss='git stash show -p'
gss() {
    local s=("\n## Show the changes recorded in the stash entry as a diff between the stashed contents"
             "\n## and the commit back when the stash entry was first created\n"
             "    Usage: gvs|gss [-h|h|help] [N]; e.g. gvs|gss [0|1|n]\n"
             "\t-h|h|help    -- Print this help\n"
             "\tN            -- Display the Nth entry of the stash\n")
    case "$#" in
        '0')
            git stash show --patch
            ;;
        '1')
            git stash show --patch stash@{$1}
            ;;
        *)
            printUsage "${s[*]}"
            ;;
    esac
    return $?
}
gvs() {
    gss "$@"
}

## gsa='git stash apply'
gsa() {
    local s=("\n## Remove a single stashed state from the stash list and apply it on top of the current working tree state\n"
             "    Usage: gsa [-h|h|help] [N]; e.g. gsa [0|1|N]\n"
             "\t-h|h|help    -- Print this help\n"
             "\tN            -- Remove and apply the Nth entry to current repo\n")
    case "$#" in
        '0')
            git stash pop stash@{0}
            ;;
        '1')
            git stash pop stash@{$1}
            ;;
        *)
            printUsage "${s[*]}"
            ;;
    esac
    return $?
}
## gsd='git stash drop'
gsd() {
    local s=("\n## Remove a single stash entry from the list of stash entries\n"
             "    Usage: gsd [-h|h|help] [N]; e.g. gsd [0|1|N]\n"
             "\t-h|h|help    -- Print this help\n"
             "\tN            -- Drop the Nth entry\n")
    case "$#" in
        '0')
            git stash drop stash@{0}
            ;;
        '1')
            git stash drop stash@{$1}
            ;;
        *)
            printUsage "${s[*]}"
            ;;
    esac
    return $?
}
## to view HEAD's SHA-1 hash
alias ghm='git show-ref master'
#alias gh='git rev-parse --verify HEAD'
function display_branch_sha1() {
    git for-each-ref --format='%(refname)' refs/heads  | while read x ; do git show-ref --verify "$@" $x; done
}
function gh() {
    local s=("\n## Display sha-1 hash of branch(es)\n"
             "    Usage: gh [-h|h|help] [-m|m|master] [-s|s|short]\n"
             "\t-h|h|help    -- Print this help\n"
             "\t-r|r|remote  -- show remote masters only. Can combine with -s|s\n"
             "\t-m|m|master  -- show local masters only. Can combine with -r|r\n"
             "\t-s|s|short   -- shortened object names\n"
    )
    if [[ $# -eq 0 ]]; then
        display_branch_sha1 --abbrev
        return $?
    fi

    case "$1" in
        'r'|'-r'|'remote')
            case "$2" in
                's'|'-s'|'short')
                    git rev-parse --verify --short refs/remotes/origin/HEAD
                    ;;
                *)
                    git rev-parse --verify refs/remotes/origin/HEAD
                    ;;
                esac
            ;;
        'm'|'-m'|'master')
            case "$2" in
                's'|'-s'|'short')
                    git show-ref --heads --abbrev master
                    ;;
                *)
                    git show-ref --heads master
                    ;;
                esac
                ;;
        's'|'-s'|'short')
            case "$2" in
                'r'|'-r'|'remote')
                    git rev-parse --verify --short refs/remotes/origin/HEAD
                    ;;
                *)
                    display_branch_sha1 --abbrev
                    ;;
                esac
            ;;
        *)
            printUsage "${s[*]}"
            ;;
    esac
    return $?
}
#alias ghs='git rev-parse --short --verify HEAD'
#alias ghremote='git rev-parse --verify refs/remotes/origin/HEAD'
## reset
alias grs='git reset --soft '
alias grh='git reset --hard '
alias gunstage='git reset HEAD -- '
alias guncommit='git reset --soft HEAD^ '
## merge master to branch
#alias gmm='git merge origin/master '
gm() {
    local s=("\n## Merge <branch> to current branch\n"
             "    Usage: gm [-b|b] [-m|m] <branch name>\n"
             "\t-b|b|branch <branch name>   -- merge <branch name> to current branch\n"
             "\t-m|m|master                 -- merge master to current branch\n"
             )
    case "$1" in
        '-b'|'b'|'branch')
            git merge "$2"
            ;;
        '-m'|'m'|'master')
            git merge origin/master
            ;;
        *)
        printUsage "${s[*]}"
        ;;
    esac
}

## gmb = git merge-base
gmb() {
    local s=("\n## git merge-base: finds best common ancestor(s) between two commits\n"
             "    Usage: gmb [-h|h|help] [-m|m|master] <commit hash>\n"
             "\t-h|h|help    -- Print this help\n"
             "\t-m|m|master  -- Find the point at which branch forked from master\n"
             "\t<commit>     -- Find the ancestor of <commit> and current HEAD\n")
    #local CURRENT_BRANCH="$(git rev-parse --verify HEAD)"
    local CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    if [[ $# -eq 0 ]]; then printUsage "${s[*]}"; return $?; fi
    case "$1" in
        '-h'|'h'|'help')
            printUsage "${s[*]}"
            ;;
        '-m'|'m'|'master')
            git merge-base --fork-point master "$CURRENT_BRANCH"
            ;;
        *)
            git merge-base "$@"
            ;;
    esac
    return $?
}

## copy files from other branch
gcp() {
    local s=("\n## Copy files from <branch name> to the current branch\n"
             "    Usage: gcp [-h|h|help] <branch> path/filename[..path/filename]\n"
             "\t-h|h|help    -- Print this help\n"
             "\t<branch> path/filename[..path/filename]\n")
    if [[ $# -lt 2 ]]; then
        printUsage "${s[*]}"
    else
        local branch_name="$1"
        shift
        git checkout --merge "$branch_name" "$@"
    fi
}

## gdiff branch
gdiff() {
    local s=("\n## Compare files between branches\n"
             "    Usage: gdiff <branch name> [path/filename...]\n"
             "\t<branch>                     -- Compare all files in current branch with <branch>\n"
             "\t<branch> [path/filename...]  -- Compare [filename(s)] in current branch with <branch>\n")
    if [[ $# -lt 1 ]]; then 
        printUsage "${s[*]}"
    else
        local CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
        local OTHER_BRANCH="$1"
        shift
        git diff "$OTHER_BRANCH" "$CURRENT_BRANCH" "$@"
    fi
}

## To exclude locally modified files from index
gignore() {
    local s=("\n## Exclude locally modified files from index\n"
             "    Usage: gig|gignore path/file_to_ignore\n")
    if [[ $# -lt 1 ]]; then
        printUsage "${s[*]}"
    else
        git update-index --skip-worktree "$@"
        git update-index --assume-unchanged "$@"
    fi
}
gig() {
    gignore
}

gunignore() {
    local s=("\n## Let git manage locally modified files\n"
             "    Usage: guig|gunignore path/file_to_ignore\n")
    if [[ $# -lt 1 ]]; then
        printUsage "${s[*]}"
    else
        git update-index --no-skip-worktree "$@"
        git update-index --no-assume-unchanged "$@"
    fi
}
guig() { 
    gunignore
}

case "$TERM" in
xterm*)
	# The following programs are known to require a Win32 Console
	# for interactive usage, therefore let's launch them through winpty
	# when run inside `mintty`.
	for name in node ipython php php5 psql python2.7
	do
		case "$(type -p "$name".exe 2>/dev/null)" in
		''|/usr/bin/*) continue;;
		esac
		alias $name="winpty $name.exe"
	done
	;;
esac
