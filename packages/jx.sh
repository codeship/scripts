#!/bin/bash
# Install JX, https://github.com/jxcore/jxcore
#
# This installation script is not working any longer, as development of the
# platform was stopped and binaries are not available any longer.
#
# This script is kept to provide an error message to users still using it and
# will be removed in the future.
function error() { echo -e "\033[0;31m$*\033[0m"; }

error "Nubisa stopped active development of the JXcore platform."
error "This caused the installation script to fail with a 'Could not fetch' error."
error "See http://www.nubisa.com/nubisa-halting-active-development-on-jxcore-platform/ for more information"

exit 1
