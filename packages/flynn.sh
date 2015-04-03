#!/bin/sh
# Install flynn - https://flynn.io
L="${HOME}/bin/flynn" && curl -sL -A "`uname -sp`" https://dl.flynn.io/cli | zcat >$L && chmod +x $L
