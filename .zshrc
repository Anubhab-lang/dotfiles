#################################################################
#                      .ZSHRC BY              __  __            #
#    _________  _______  __   ____ ___  ___  / /_/ /____  _____ #
#   / ___/ __ \/ ___/ / / /  / __ `__ \/ _ \/ __/ __/ _ \/ ___/ #
#  / /__/ /_/ / /  / /_/ /  / / / / / /  __/ /_/ /_/  __/ /     #
#  \___/\____/_/   \__, /  /_/ /_/ /_/\___/\__/\__/\___/_/      #
#                 /____/                                        #
#################################################################

# Set zsh to use vi mode
set -o vi

# Source the oh-my-zsh configuraiton script
export ZSH=/Users/cory/.oh-my-zsh

# Name of the current theme
# See "https://github.com/robbyrussell/oh-my-zsh/wiki/Themes" for more themes
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git bosh cf docker battery)

# Hide username from shell prompt by setting a default user
DEFAULT_USER="$USER"

# Source the oh-my-zsh configuraiton script
source $ZSH/oh-my-zsh.sh

# Aliases
alias macdown='open -a macdown.app'         # macdown:      Opens file in Macdown
alias edit='code'                           # edit:         Opens any file in VSCode
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
alias reload='source ~/.zshrc'              # Applies(sources) changes to bash profile
