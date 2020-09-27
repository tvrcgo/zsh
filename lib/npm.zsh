
# node_modules/.bin
export PATH=./node_modules/.bin:$PATH

alias bump="npm version $1 -m 'Release v%s'"
alias bump2="npm version $1 -m 'Release v%s' --no-git-tag-version"
