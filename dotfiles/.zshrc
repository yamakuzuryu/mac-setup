##############################################################
# Bohmanart ZSH Aliases, Functions, Plugins and Configuration #
##############################################################

# NVM #
#######
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Node #
########
export NODE_OPTIONS="--max-old-space-size=4096"

# Yarn #
########
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Alias #
#########
source $HOME/.zshrc-alias

# Oh My ZSH #
#############
source $HOME/.zshrc-ohmyzsh

# Private #
###########
if [ -f $HOME/.zshrc-private ]; then
  source $HOME/.zshrc-private
fi
