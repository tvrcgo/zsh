
# finder
alias ll="ls -alAFG"
alias la="ls -AF"
alias l="ls -lG"
alias ..="cd .."
alias cls="clear"

# ssh
export SSH_KEY_PATH="~/.ssh/mbp15"
alias sshrc="vi ~/.ssh/config"

# fix damaged app
fixapp() {
  sudo spctl --master-disable
  sudo xattr -rd com.apple.quarantine $@
}

# Deno
export PATH=/Users/tvrcgo/.deno/bin:$PATH

# github
alias ghpage-serve="bundle exec jekyll serve"

# VS Code
alias vsc="/Applications/Visual\ Studio\ Code*.app/Contents/Resources/app/bin/code"

# terminal proxy
alias ss1='export http_proxy=http://127.0.0.1:1087 https_proxy=http://127.0.0.1:1087'
alias ss0='unset http_proxy https_proxy'

# z jump
source ~/.zsh/bin/z.sh
#alias f="z"

# twitter-cli
alias t="twitter update"
alias tl="twitter home"
alias ta="twitter user"
alias td="twitter destroy"
