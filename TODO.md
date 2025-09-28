# Todos

## Checklist

- [x] [Install brew](#install-brew)
- [x] [Install brewfile](#install-brewfile)
- [x] [Install oh my zsh](#install-oh-my-zsh)
- [ ] [Install dotfiles](#install-dotfiles)
- [ ] [Config vscode cli](#config-vscode-cli)
- [ ] [Config vscode](#config-vscode)

## Install brew

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

## Install brewfile

`brew bundle install`

(to create a Brewfile: `brew bundle dump`)

## Install oh my zsh

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

## Install dotfiles

## Config vscode cli

``` bash
cat << EOF >> ~/.zprofile
# Add Visual Studio Code (code)
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF
```

## Config vscode
