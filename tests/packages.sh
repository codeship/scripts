#!/bin/bash

debug() { echo -e "\033[0;37m$*\033[0m"; }
info() { echo -e "\033[0;36m$*\033[0m"; }
error() { >&2  echo -e "\033[0;31m$*\033[0m"; }
fail() { error ${1}; exit ${2:-1}; }

test_header() {
  echo -e "\n\n"
  info '#'
  info "# ${*}"
  info '#'
}

#set -euo pipefail
set -e

PIPELINE_ID="${1}"

# ChromeDriver
if [ ${PIPELINE_ID} -eq "1" ]; then
	test_header "ChromeDriver"
	export CHROMEDRIVER_VERSION="2.27"
	bash packages/chromedriver.sh
	chromedriver --version | grep "${CHROMEDRIVER_VERSION}"
fi

# Firefox
if [ ${PIPELINE_ID} -eq "1" ]; then
	test_header "Firefox"
	export FIREFOX_VERSION="51.0.1"
	bash packages/firefox.sh
	firefox --version | grep "${FIREFOX_VERSION}"
fi

# Ghostscript
if [ ${PIPELINE_ID} -eq "2" ]; then
	test_header "Ghostscript"
	export GHOSTSCRIPT_VERSION="9.26"
	bash packages/ghostscript.sh
	ghostscript -version | grep "${GHOSTSCRIPT_VERSION}"
fi

# Git
if [ ${PIPELINE_ID} -eq "1" ]; then
	test_header "Git"
	export GIT_VERSION="2.12.0"
	bash packages/git.sh
	git --version | grep "${GIT_VERSION}"
fi

# Git LFS
if [ ${PIPELINE_ID} -eq "1" ]; then
	test_header "Git LFS"
	export GIT_LFS_VERSION="2.0.0"
	bash packages/git-lfs.sh
	git lfs version | grep "git-lfs/${GIT_LFS_VERSION}"

	# test warning message
	unset GIT_LFS_VERSION
	bash packages/git-lfs.sh | grep "Warning"
	git lfs version | grep "git-lfs/1.5.6"
fi

# Google Cloud SDK
if [ ${PIPELINE_ID} -eq "1" ]; then
	test_header "Google Cloud SDK"
	source packages/google-cloud-sdk.sh
	gcloud --version
fi

# ImageMagick 6
if [ ${PIPELINE_ID} -eq "1" ]; then
        test_header "ImageMagick 6"
        export IMAGEMAGICK_VERSION="6.9.9-43"
        bash packages/imagemagick.sh
        identify -version | grep "${IMAGEMAGICK_VERSION}"
fi

# ImageMagick 7
if [ ${PIPELINE_ID} -eq "2" ]; then
	test_header "ImageMagick 7"
	export IMAGEMAGICK_VERSION="7.0.8-11"
	bash packages/imagemagick.sh
	identify -version | grep "${IMAGEMAGICK_VERSION}"
fi

# MongoDB
if [ ${PIPELINE_ID} -eq "3" ]; then
	test_header "MongoDB"
	export MONGODB_PORT="27018"
	export MONGODB_VERSION="3.4.0"
	bash packages/mongodb.sh
	netstat -lnp | grep "${MONGODB_PORT}.*mongod"
	kill "$(cat ${HOME}/mongodb/mongod.lock)"
	sleep 5
	rm -rf "${HOME}/mongodb/"

	export MONGODB_PORT="27019"
	export MONGODB_VERSION="3.4.4"
	export MONGODB_STORAGE_ENGINE="mmapv1"
	bash packages/mongodb.sh
	netstat -lnp | grep "${MONGODB_PORT}.*mongod"
	kill "$(cat ${HOME}/mongodb/mongod.lock)"
	sleep 5
	rm -rf "${HOME}/mongodb/"
fi

# MySQL 5.7
if [ ${PIPELINE_ID} -eq "1" ]; then
	test_header "MySQL 5.7"
	export MYSQL_VERSION="5.7.22"
	bash packages/mysql-5.7.sh
	"$HOME/mysql-$MYSQL_VERSION/bin/mysql" --defaults-file="$HOME/mysql-$MYSQL_VERSION/my.cnf" --version | grep "${MYSQL_VERSION}"
	netstat -lnp | grep "3307"
fi

# MySQL 8.0
if [ ${PIPELINE_ID} -eq "1" ]; then
        test_header "MySQL 8.0"
        export MYSQL_VERSION="8.0.11"
        bash packages/mysql-8.0.sh
        "$HOME/mysql-$MYSQL_VERSION/bin/mysql" --defaults-file="$HOME/mysql-$MYSQL_VERSION/my.cnf" --version | grep "${MYSQL_VERSION}"
        netstat -lnp | grep "3308"
fi

# Neo4j
if [ ${PIPELINE_ID} -eq "3" ]; then
	test_header "Neo4j"
	export NEO4J_VERSION="3.5.2"
	bash packages/neo4j.sh
	${HOME}/neo4j/bin/neo4j status
fi

# Phalcon PHP framework
if [ ${PIPELINE_ID} -eq "3" ]; then
	test_header "Phalcon"
	export PHALCON_VERSION="3.0.3"
	phpenv local 5.6
	bash packages/phalcon.sh
	php -m | grep phalcon
fi

# Poppler
if [ ${PIPELINE_ID} -eq "3" ]; then
	test_header "Poppler"
	export POPPLER_VERSION="0.52.0"
	bash packages/poppler.sh
	pdftotext -v 2>&1 | grep "${POPPLER_VERSION}"
fi

# QPDF
if [ ${PIPELINE_ID} -eq "3" ]; then
	test_header "QPDF"
	export QPDF_VERSION="6.0.0"
	bash packages/qpdf.sh
	qpdf --version | grep "${QPDF_VERSION}"
fi

# sbt
if [ ${PIPELINE_ID} -eq "1" ]; then
	test_header "SBT"
	export SBT_VERSION="0.13.8"
	bash packages/sbt.sh
	sbt --version | grep "${SBT_VERSION}"
fi

# Selenium Server
if [ ${PIPELINE_ID} -eq "1" ]; then
	test_header "Selenium"
	export SELENIUM_VERSION="3.14.0"
	export SELENIUM_PORT="4444"
	bash packages/selenium_server.sh
	netstat -lnp | grep "${SELENIUM_PORT}.*java"
fi

# Haskell Stack
if [ ${PIPELINE_ID} -eq "3" ]; then
	test_header "Haskell Stack"
	export HASKELL_STACK_VERSION="1.3.2"
	bash packages/stack.sh
	stack --version | grep "${HASKELL_STACK_VERSION}"
fi

# Tomcat
if [ ${PIPELINE_ID} -eq "3" ]; then
	test_header "Tomcat"
	export TOMCAT_VERSION="8.5.12"
	bash packages/tomcat.sh
	bash ${HOME}/tomcat/bin/version.sh | grep "Apache Tomcat/${TOMCAT_VERSION}"
fi
