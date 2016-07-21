#!/bin/bash
# Install a custom Python version.
# based on pyenv, https://github.com/yyuu/pyenv
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * PYTHON_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/python.sh)"
PYTHON_VERSION=${PYTHON_VERSION:="3.5.0"}

git clone https://github.com/yyuu/pyenv.git ${HOME}/pyenv

export PYENV_ROOT="${HOME}/pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"

eval "$(pyenv init -)"

pyenv install "${PYTHON_VERSION}"
pyenv local "${PYTHON_VERSION}"
python --version 2>&1 | grep "${PYTHON_VERSION}"
