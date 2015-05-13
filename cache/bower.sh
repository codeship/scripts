#!/bin/sh
# Cache Bower dependencies
#
# Use this like
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/cache/bower.sh | bash 
cat <<EOF > "${HOME}/.bowerrc"
{
  "storage": {
    "packages": "${HOME}/cache/bower/packages",
    "registry": "${HOME}/cache/bower/registry"
  }
}
EOF
