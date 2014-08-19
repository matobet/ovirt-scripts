#!/usr/bin/bash

SCRIPTS_DIR=${1-$HOME/ovirt-scripts}

[ -d vdsm.git ] || git clone git://gerrit.ovirt.org/vdsm --bare
ln -s $SCRIPTS_DIR/post-receive-vdsm vdsm.git/hooks/post-receive

cat >> $HOME/.bashrc <<EOF
export SCRIPTS_DIR=$SCRIPTS_DIR
EOF
