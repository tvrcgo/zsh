
alias gitrc="vi ~/.zsh/lib/git.zsh"
alias g="git"
alias gi="git status"
alias gps="git push"
alias gpl="git pull --rebase"
alias gm="git merge"
alias grb="git rebase"
alias gl="git log --color --graph --abbrev-commit --decorate --pretty=format:'%C(magenta)%h%Creset %C(auto)%d%Creset %C(white)%s%Creset %C(cyan)%cn,%Creset %C(cyan)%cr%Creset' --all"
alias gcl="git clone"
alias gc="git commit -m"
alias gcu="git commit --amend -m"
alias gca="git commit --amend --no-edit"
alias gfr="git fetch origin --prune"
alias gdf="git show --color --pretty=format:%b"
alias gst="git stash"
alias grvt="git reset HEAD^"

current_branch() {
  git rev-parse --abbrev-ref HEAD
}

local_branch() {
  gb | grep -v remotes
}

remote_branch() {
  gb | grep remotes | awk -F remotes/origin/ '{ print $2 }'
}

gmb() {
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
      echo "Merge remote branch: origin/$rb"
      echo "origin/$rb" | xargs git merge --no-ff
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
  git push
  git stash pop -q
}
