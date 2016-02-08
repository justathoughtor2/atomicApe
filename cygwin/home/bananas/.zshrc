# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="babun"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Java
export JAVA_HOME="~/jdk"
export PATH="~/jdk/bin:$PATH"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias atom="~/atom.bat"
alias node="~/node.exe"
alias npm="~/npm.cmd"
alias bower="~/bower.cmd"
alias forever="~/forever.cmd"
alias phonegap="~/phonegap.cmd"
alias uwamp="~/UwAmp/UwAmp.exe"
alias ruby="~/Ruby22/bin/ruby.exe"
alias gem="~/Ruby22/bin/gem.bat"
alias erb="~/Ruby22/bin/erb.bat"
alias irb="~/Ruby22/bin/irb.bat"
alias jekyll="~/Ruby22/bin/jekyll.bat"
alias kramdown="~/Ruby22/bin/kramdown.bat"
alias listen="~/Ruby22/bin/listen.bat"
alias rake="~/Ruby22/bin/rake.bat"
alias rdoc="~/Ruby22/bin/rdoc.bat"
alias ri="~/Ruby22/bin/ri.bat"
alias rougify="~/Ruby22/bin/rougify.bat"
alias safe_yaml="~/Ruby22/bin/safe_yaml.bat"
alias sass="~/Ruby22/bin/sass.bat"
alias scss="~/Ruby22/bin/scss.bat"
alias sass-convert="~/sass-conver.bat"
alias python="/bin/python2.7.exe"
alias pip="python -m pip"
alias pelican="/bin/pelican"
alias pelican-quickstart="python /lib/python2.7/site-packages/pelican/tools/pelican_quickstart.py"
alias pelican-import="python /lib/python2.7/site-packages/pelican/tools/pelican_import.py"
alias pelican-themes="python /lib/python2.7/site-packages/pelican/tools/pelican_themes.py"

