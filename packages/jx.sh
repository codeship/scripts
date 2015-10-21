#!/bin/bash
# Install JX, http://jxcore.com
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/jx.sh | bash -s
set -#!/usr/bin/env

cd "${HOME}/bin"
curl -sSL https://raw.githubusercontent.com/jxcore/jxcore/master/tools/jx_install.sh | sed -e 's/LOCAL_INSTALL="no"/LOCAL_INSTALL="yes"/g' | bash
cd -
