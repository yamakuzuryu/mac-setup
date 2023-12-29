install xcode cli tools

`xcode-select --install`


install brew

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`


install brew bundle (Brewfile)

`brew bundle install`

(to create a Brewfile: `brew bundle dump`)


install oh my zsh

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`


install dotfiles


config vscode cli
```
cat << EOF >> ~/.zprofile
# Add Visual Studio Code (code)
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF
```

config vscode?
