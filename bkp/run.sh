#!/bin/bash



chmod 600 /userdata/system/ssh/id_rsa

export GIT_SSH_COMMAND="ssh -i /userdata/system/ssh/id_rsa -o IdentitiesOnly=yes"

git clone git@github.com:JeversonDS/data.git