#!/bin/sh
# Save the public key of the Codeship project. It is found in Project Settings > General Settings.
# Copy the public key to a file /tmp/codeship_projectname.pub.
# Make sure when pasting, all the contents are in a single line and not multiple lines.
# Add the public key to dokku using the following command in console.
# cat /tmp/codeship_projectname.pub | ssh root@yourdokkuinstance "sudo sshcommand acl-add dokku codeship_projectname"

# In Codeship, go to Project Settings > Deployment.
# Add a new custom script. Add the following lines to custom script.

git fetch --unshallow || true
git fetch origin "+refs/heads/*:refs/remotes/origin/*"
# checkout a remote branch with
# git checkout -b test origin/test
git remote add dokku dokku@yourdokkuinstance:projectname
git push dokku master

# Now everytime you build on Codeship, it should deploy to the dokku instance.
