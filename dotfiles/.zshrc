###############################################################
# Bohmanart ZSH  Aliases, Functions, Plugins and Configuration #
###############################################################

# NVM
export NVM_DIR="/Users/mbohman/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Alias
source $HOME/.zshrc-alias

# Oh My ZSH
source $HOME/.zshrc-ohmyzsh

# Private
if [ -f $HOME/.zshrc-private ]; then
  source $HOME/.zshrc-private
fi
