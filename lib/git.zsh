
alias gitrc="vi ~/.zsh/lib/git.zsh"
alias g="git"
alias gi="git status"
alias ga="git add -A"
alias gpt="git push --tags"
alias gpf="git push --force"
alias gpr="git pull --rebase"
alias gr="git rebase"
alias gl="git log --color --graph --abbrev-commit --decorate --pretty=format:'%C(magenta)%h%Creset %C(auto)%d%Creset %C(white)%s%Creset %C(cyan)%cn,%Creset %C(cyan)%cr%Creset' --all"
alias gcl="git clone"
alias gc="git commit -m"
alias gam="git commit --amend --no-edit"
alias gamm="git commit --amend -m"
alias gfo="git fetch origin --prune"
alias gdf="git show --color --pretty=format:%b"
alias gs="git stash"
alias gsp="git stash pop"
alias grsh="git reset HEAD^"
alias gt="git tag"

head_commit() {
  git rev-parse --short HEAD
}

head_branch() {
  git rev-parse --abbrev-ref HEAD
}

query_branch() {
  git branch -a | grep ${1-""}
}

local_branch() {
  query_branch | grep -v remotes
}

remote_branch() {
  query_branch | grep remotes | awk -F remotes/origin/ '{ print $2 }'
}

query_tag() {
  git tag -l | grep ${1-""}
}

gp() {
  git push --follow-tags
  git push --tags
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

gkfb() {
  DATE=$(date +"%y%m%d%H%M")
  SUFFIX=$([[ ! -z $1 ]] && echo "_$1" || echo "")
  TARGET_BRANCH=feature/${DATE}_$(head_commit)${SUFFIX}
  gkb ${TARGET_BRANCH}
}

gbd() {
  echo "Search local branch: $1\n"
  echo "$(local_branch | grep $1)\n"
  echo "Deleting...\n"
  local_branch | grep $1 | xargs git branch -D
}

gbdr() {
  echo "Search remote branch: $1\n"
  echo "$(remote_branch | grep $1)\n"
  echo "Deleting...\n"
  remote_branch | grep $1 | xargs -I {} git push origin :{}
}

gtd() {
  echo "Search tag: $1\n"
  echo "$(query_tag $1)\n"
  query_tag $1 | xargs -I {} git tag -d {}
}

gtdr() {
  echo "Search tag: $1\n"
  echo "$(query_tag $1)\n"
  query_tag $1 | xargs -I {} git push origin :refs/tags/{}
}

gtc() {
  echo "Create tag: $(head_branch)-$(head_commit)"
  git tag $(head_branch)-$(head_commit)
}
