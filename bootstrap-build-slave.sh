#!/bin/sh

SCRIPTS_DIR=${1-$HOME/ovirt-scripts}

[ -d ovirt-engine.git ] || git clone git://gerrit.ovirt.org/ovirt-engine --bare
ln {$SCRIPTS_DIR,ovirt-engine.git/hooks}/post-receive

echo >> .bashrc <<EOF
export PREFIX=$HOME/build
export SCRIPTS_DIR=$SCRIPTS_DIR
EOF
