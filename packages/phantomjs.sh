#!/bin/sh
# Install a custom version of PhantomJS, http://phantomjs.org/
#
# You can either add this here, or configure them on the environment tab of your
# project settings.
PHANTOMJS_VERSION="1.9.8"

# clean old version and setup directories
rm -rf ~/.phantomjs
mkdir ~/.phantomjs

# download and extract new version
wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 -O ~/phantomjs.tar.bz2
tar -xaf ~/phantomjs.tar.bz2 --strip-components=1 -C ~/.phantomjs

# cleanup
rm -f ~/phantomjs.tar.bz2
