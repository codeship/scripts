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
PYENV_VERSION=${PYENV_VERSION:="v1.0.8"}

PYENV_ROOT=${PYENV_ROOT:=$HOME/pyenv}
CACHED_DOWNLOAD="${HOME}/cache/pyenv-${PYENV_VERSION}.tar.gz"

if [ ! -d "${PYENV_ROOT}" ]; then
  mkdir -p "${PYENV_ROOT}"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/yyuu/pyenv/archive/${PYENV_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${PYENV_ROOT}"

  export PYENV_ROOT
  export PATH="${PYENV_ROOT}/bin:${PATH}"
fi

eval "$(pyenv init -)"
pyenv install --skip-existing "${PYTHON_VERSION}"
pyenv local "${PYTHON_VERSION}"
python --version 2>&1 | grep "${PYTHON_VERSION}"
