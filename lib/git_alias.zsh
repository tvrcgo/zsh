
alias gitrc="vi ~/.alias/git_alias.zsh"
alias g="git"
alias gi="git status"
alias gps="git push"
alias gpl="git pull -r"
alias gm="git merge"
alias gr="git rebase"
alias gl="git log --color --graph --abbrev-commit --decorate --pretty=format:'%C(magenta)%h%Creset %C(auto)%d%Creset %C(white)%s%Creset %C(cyan)%cn,%Creset %C(cyan)%cr%Creset' --all"
alias gcl="git clone"
alias gcm="git commit -m"
alias gau="git commit --amend -m"
alias gam="git commit --amend --no-edit"
alias gfr="git fetch origin --prune"
alias gdf="git show --color --pretty=format:%b"
alias gst="git stash"

current_branch() {
  git rev-parse --abbrev-ref HEAD
}

local_branch() {
  gb | grep -v remotes
}

remote_branch() {
  gb | grep remotes | awk -F remotes/origin/ '{ print $2 }'
}

gmg() {
  if [ -z "$1" ]; then
    echo "Which branch to merge ?"
    return
  fi

  lb=`local_branch | grep $1`
  if [ ! -z "$lb" ]; then
    echo "Merge local branch: $lb"
    echo $lb | xargs git merge --no-ff
  else
    rb=`remote_branch | grep $1`
    if [ ! -z "$rb" ]; then
      echo "Merge remote branch: $rb"
      echo $rb | xargs git merge --no-ff
    else
      echo "Oops, branch not found"
    fi
  fi
}

gk() {
  if [ -z "$1" ]; then
    echo "Which branch to checkout ?"
    return
  fi

  lb=`local_branch | grep $1`
  if [ ! -z "$lb" ]; then
    echo "Checkout local branch: $lb"
    echo $lb | xargs git checkout
  else
    git fetch --all --prune
    rb=`remote_branch | grep $1`
    if [ ! -z "$rb" ]; then
      echo "Checkout remote branch: $rb"
      echo $rb | xargs -I {} git checkout -b {} origin/{}
      git pull -r
    else
      echo "Oops, branch not found"
    fi
  fi
}

gkb() {
  echo "Checkout branch $1 from ${2-HEAD}"
  git checkout -b $1 ${2-HEAD}
}

gb() {
  if [ ! -z "$1" ]; then
    git branch -a | grep $1
  else
    git branch -a
  fi
}

gbd() {
  echo "Remove local branch: $1"
  local_branch | grep $1 | xargs git branch -D
}

gbdr() {
  echo "Remove remote branch: $1"
  remote_branch | grep $1 | xargs -I {} git push origin :{}
}

gbda() {
  gbd $1
  gbdr $1
}

gt() {
  if [ ! -z "$1" ]; then
    git tag -l | grep $1
  else
    git tag -l
  fi
}

gtd() {
  echo "Remove local tag: $1"
  gt $1 | xargs -I {} git tag -d {}
}

gtdr() {
  echo "Remove remote tag: $1"
  gt $1 | xargs -I {} git push origin --delete tag {}
}

gtda() {
  gtd $1
  gtdr $1
}

gsync() {
  git add -A
  git stash
  git pull -r
  git stash pop -q
}
