#!/bin/bash
# Install sdkman with support for Codeship dependency caching, http://sdkman.io/
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/sdkman.sh)"

curl -s "https://get.sdkman.io" | bash
source $HOME/.sdkman/bin/sdkman-init.sh

# replace $HOME/.sdkman/archives/ with symbolically linked $HOME/cache/sdkman/archives/
rmdir $HOME/.sdkman/archives
mkdir -p $HOME/cache/sdkman/
ln -s $HOME/cache/sdkman $HOME/.sdkman/archives
