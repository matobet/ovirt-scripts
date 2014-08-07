#!/bin/sh

SCRIPTS_DIR=${1-$HOME/ovirt-scripts}

[ -d ovirt-engine.git ] || git clone git://gerrit.ovirt.org/ovirt-engine --bare
ln {$SCRIPTS_DIR,ovirt-engine.git/hooks}/post-receive

cat >> .bashrc <<EOF
export PREFIX=$HOME/build
export SCRIPTS_DIR=$SCRIPTS_DIR
EOF

# setup firewall
firewall-cmd --add-port=8080/tcp
firewall-cmd --add-port=8080/tcp --permanent
