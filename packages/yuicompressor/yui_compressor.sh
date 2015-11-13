#!/bin/sh
:'
For instance, you may use this package with buildout. First, create the buildout.cfg file:
[buildout]
parts = yuicompressor

[yuicompressor]
recipe = zc.recipe.egg
eggs = yuicompressor
-----------------------------

Runs the yuicompressor scripts:

bin/yuicompressor

'

set -e
CACHED_DOWNLOAD="${HOME}/cache/yuicompressor"

mkdir "${HOME}/cache/yuicompressor"
wget --continue --output-document "${CACHED_DOWNLOAD}" "http://svn.zope.org/*checkout*/zc.buildout/trunk/bootstrap/bootstrap.py"

# Generates buildout scripts
python bootstrap.py

# Installs Yui Compressor
bin/buildout