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

# Ghostscript
export GHOSTSCRIPT_VERSION="9.20"
bash packages/ghostscript.sh
ghostscript -version | grep "${GHOSTSCRIPT_VERSION}"

# Git
export GIT_VERSION="2.12.0"
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
export IMAGEMAGICK_VERSION="7.0.5-0"
bash packages/imagemagick.sh
identify -version | grep "${IMAGEMAGICK_VERSION}"

# MongoDB
export MONGODB_PORT="27018"
export MONGODB_VERSION="3.4.0"
bash packages/mongodb.sh
netstat -lnp | grep "${MONGODB_PORT}.*mongod"
kill "$(cat ${HOME}/mongodb/mongod.lock)"
rm -rf "${HOME}/mongodb/"

export MONGODB_PORT="27019"
export MONGODB_VERSION="3.4.4"
export MONGODB_STORAGE_ENGINE="mmapv1"
bash packages/mongodb.sh
netstat -lnp | grep "${MONGODB_PORT}.*mongod"
kill "$(cat ${HOME}/mongodb/mongod.lock)"
rm -rf "${HOME}/mongodb/"

# MySQL 5.7
export MYSQL_VERSION="5.7.17"
bash packages/mysql-5.7.sh
"$HOME/mysql-$MYSQL_VERSION/bin/mysql" --defaults-file="$HOME/mysql-$MYSQL_VERSION/my.cnf" --version | grep "${MYSQL_VERSION}"
netstat -lnp | grep "3307"

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

# QPDF
export QPDF_VERSION="6.0.0"
bash packages/qpdf.sh
qpdf --version | grep "${QPDF_VERSION}"

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
export TOMCAT_VERSION="8.5.12"
bash packages/tomcat.sh
bash ${HOME}/tomcat/bin/version.sh | grep "Apache Tomcat/${TOMCAT_VERSION}"
