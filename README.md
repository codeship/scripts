# [Codeship Scripts](https://github.com/codeship/scripts/) [ ![Codeship Status for codeship/scripts](https://codeship.com/projects/7ffee8d0-c443-0132-17cf-0a3d9756066d/status?branch=master)](https://codeship.com/projects/74080)

A public collection of useful scripts for use on [Codeship](https://codeship.com/) and similar tools.

E.g. scripts to install specific versions of software not included by default on the build VMs. Deployment scripts for external services to customize to your needs, configure caching or trigger notifications. And other scripts if you want to have them included ;)

Each script includes a comment at the beginning detailing how to configure and use the script in your builds. Those comments look for example like

```shell
# Add at least the following environment variables to your project configuration
# (otherwise the defaults below will be used).
# * FIREFOX_VERSION
#
# Include in your builds via
# \curl -sSL https://raw.githubusercontent.com/codeship/scripts/master/packages/firefox.sh | bash -s
```

It is important that you follow those instructions and not simply copy / paste the scripts into your Codeship project configuration.

Most scripts include `set -e` to make the script fail as soon as a command returns a non-zero exit code (which indicate failure). This is fine if you call the script as documented above (via the `curl` command). But it will have side effects if you copy the commands into your settings on codeship.com as any failing command (after the `set -x`) will terminate your build with a `SYSTEM` error message. (Reason being, that this command will cause the SSH connection to be terminated once another command fails.) You probably don't want this :)

## Code of Conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.
