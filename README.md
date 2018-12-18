# zsh

zsh library

### Copy zsh to ~/.alias

```
mv lib ~/.alias
```

### Edit ~/.zshrc

```
for file in ~/.alias/*; do
  source "$file"
done
```
