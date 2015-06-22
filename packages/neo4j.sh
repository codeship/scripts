#!/bin/bash
# Install a custom Neo4J version, http://neo4j.com/
#
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * NEO4J_VERSION
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/neo4j.sh | bash -s
NEO4J_VERSION=${NEO4J_VERSION:="2.2.2"}
NEO4J_DIR=${NEO4J_DIR:="$HOME/neo4j"}

set -e
CACHED_DOWNLOAD="${HOME}/cache/neo4j-community-${NEO4J_VERSION}-unix.tar.gz"

mkdir -p "${NEO4J_DIR}"
wget --continue --output-document "${CACHED_DOWNLOAD}" "http://neo4j.com/artifact.php?name=neo4j-community-${NEO4J_VERSION}-unix.tar.gz"
tar -xaf "${CACHED_DOWNLOAD}" --strip-components=1 --directory "${NEO4J_DIR}"

# start the server
"${NEO4J_DIR}/bin/neo4j" start
