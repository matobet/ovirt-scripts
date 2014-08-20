#!/usr/bin/bash

SCRIPTS_DIR=${1-$HOME/ovirt-scripts}

[ -d ovirt-engine.git ] || git clone git://gerrit.ovirt.org/ovirt-engine --bare
ln -s {$SCRIPTS_DIR,ovirt-engine.git/hooks}/post-receive

cat >> $HOME/.bashrc <<EOF
export PREFIX=$HOME/build
export SCRIPTS_DIR=$SCRIPTS_DIR
EOF

# setup firewall
firewall-cmd --add-port=8080/tcp
firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --add-port=9997/tcp
firewall-cmd --add-port=9997/tcp --permanent
