#!/usr/bin/bash
#
# Basic script that sets up the development environment for the oVirt engine
# After completion run git clone git://gerrit.ovirt.org/ovirt-engine in suitable directory

USER=${1-engine}
SCRIPTS_DIR=${SCRIPTS_DIR-$HOME/ovirt-scripts}

function install_dependencies() {
  echo ">>> Installing dependencies"
  dnf install -y http://resources.ovirt.org/pub/yum-repo/ovirt-release-master.rpm
  dnf install -y git unzip java-devel maven openssl postgresql-server m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python pyflakes \
    httpd ovirt-host-deploy* python-paramiko ovirt-engine-wildfly ovirt-engine-wildfly-overlay
}

function setup_db() {
  echo ">>> Setting up DB"
  postgresql-setup --initdb
  PGCONFIG=/var/lib/pgsql/data/pg_hba.conf
  sed -i "s/\(all\s\+127\.0\.0\.1\/32\s\+\)ident$/\1password/" $PGCONFIG
  sed -i "s/\(all\s\+::1\/128\s\+\)ident$/\1password/" $PGCONFIG
  cat > /etc/sysctl.d/ovirt-postgresql.conf <<EOF
# ovirt-engine configuration
kernel.shmmax = 68719476736
EOF
  /sbin/sysctl -p /etc/sysctl.d/ovirt-postgresql.conf
  service postgresql restart
  su - postgres -c "psql -d template1 -c \"create user engine password 'engine';\""
  su - postgres -c "psql -d template1 -c \"create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';\""
  chkconfig postgresql on
}

install_dependencies &&
setup_db
