#!/bin/sh
# Install Boot, a build tool for Clojure - http://boot-clj.com/
#
# You can either add this here, or configure them on the environment tab of your
# project settings.
BOOT_VERSION="2.0.0-rc13"

wget -O "${HOME}/bin/boot" "https://github.com/boot-clj/boot/releases/download/${BOOT_VERSION}/boot.sh"
chmod u+x "${HOME}/bin/boot"
