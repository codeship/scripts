#!/bin/bash
# Install a custom Python version.
# based on pyenv, https://github.com/pyenv/pyenv
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * PYTHON_VERSION
#
# Include in your builds via
# source /dev/stdin <<< "$(curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/languages/python.sh)"

echo -e "\e[0;33mCodeship Basic now uses pyenv for Python support by default.\e[0m"
echo -e "\e[0;33mThis script is no longer required for installing custom Python versions.\e[0m"
echo -e "\e[0;33mPlease see https://blog.codeship.com/improved-python-version-management-and-caching-on-codeship-basic for more information.\e[0m"

PYTHON_VERSION=${PYTHON_VERSION:="3.5.0"}
PYENV_VERSION=${PYENV_VERSION:="v1.0.8"}

PYENV_ROOT=${PYENV_ROOT:=$HOME/pyenv}
CACHED_DOWNLOAD="${HOME}/cache/pyenv-${PYENV_VERSION}.tar.gz"

if [ ! -d "${PYENV_ROOT}" ]; then
  mkdir -p "${PYENV_ROOT}"
  wget --continue --output-document "${CACHED_DOWNLOAD}" "https://github.com/pyenv/pyenv/archive/${PYENV_VERSION}.tar.gz"
  tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${PYENV_ROOT}"

  export PYENV_ROOT
  export PATH="${PYENV_ROOT}/bin:${PATH}"
fi

# Pyenv itself uses PYENV_VERSION to choose the Python version
unset PYENV_VERSION

eval "$(pyenv init -)"
pyenv install --skip-existing "${PYTHON_VERSION}"
pyenv local "${PYTHON_VERSION}"
python --version 2>&1 | grep "${PYTHON_VERSION}"
