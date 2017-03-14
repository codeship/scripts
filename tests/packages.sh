#!/bin/bash

set -e

# ChromeDriver
export CHROMEDRIVER_VERSION="2.27"
bash packages/chromedriver.sh
chromedriver --version | grep "${CHROMEDRIVER_VERSION}"

# Firefox
export FIREFOX_VERSION="51.0.1"
bash packages/firefox.sh
firefox --version | grep "${FIREFOX_VERSION}"

# Git
export GIT_VERSION="2.11.1"
bash packages/git.sh
git --version | grep "${GIT_VERSION}"

# Git LFS
export GIT_LFS_VERSION="2.0.0"
bash packages/git-lfs.sh
git lfs version | grep "git-lfs/${GIT_LFS_VERSION}"

# test warning message
unset GIT_LFS_VERSION
bash packages/git-lfs.sh | grep "Warning"
git lfs version | grep "git-lfs/1.5.6"

# Google Cloud SDK
source packages/google-cloud-sdk.sh
gcloud --version

# ImageMagick
export IMAGEMAGICK_VERSION="7.0.5-2"
bash packages/imagemagick.sh
identify -version | grep "${IMAGEMAGICK_VERSION}"

# MongoDB
export MONGODB_VERSION="3.4.0"
bash packages/mongodb.sh
netstat -lnp | grep "${MONGODB_PORT}.*mongod"

# Neo4j
export NEO4J_VERSION="2.2.2"
bash packages/neo4j.sh
netstat -lnp | grep "7473.*java"
netstat -lnp | grep "7474.*java"

# Phalcon PHP framework
export PHALCON_VERSION="3.0.3"
phpenv local 5.6
bash packages/phalcon.sh
php -m | grep phalcon

# Poppler
export POPPLER_VERSION="0.52.0"
bash packages/poppler.sh
pdftotext -v 2>&1 | grep "${POPPLER_VERSION}"

# sbt
export SBT_VERSION="0.13.8"
bash packages/sbt.sh
sbt --version | grep "${SBT_VERSION}"

# Selenium Server
export SELENIUM_VERSION="2.46.0"
export SELENIUM_PORT="4444"
bash packages/selenium_server.sh
netstat -lnp | grep "${SELENIUM_PORT}.*java"

# Haskell Stack
export HASKELL_STACK_VERSION="1.3.2"
bash packages/stack.sh
stack --version | grep "${HASKELL_STACK_VERSION}"

# Tomcat
export TOMCAT_VERSION="8.5.11"
bash packages/tomcat.sh
bash ${HOME}/tomcat/bin/version.sh | grep "Apache Tomcat/${TOMCAT_VERSION}"
