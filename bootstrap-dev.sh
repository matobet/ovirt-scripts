#!/usr/bin/bash
#
# Basic script that sets up the development environment for the oVirt engine
# After completion run git clone git://gerrit.ovirt.org/ovirt-engine in suitable directory

USER=${1-engine}
SCRIPTS_DIR=${SCRIPTS_DIR-$HOME/ovirt-scripts}

function install_rpm() {
  yum install -y git java-devel maven openssl postgresql-server m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python pyflakes patternfly1
  # QUICK & DIRTY FIX for the powermock bug
  yum downgrade -y java-1.7.0-openjdk{,-devel,-src,-headless}
}

function install_jboss() {
  wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip &&
  unzip jboss-as-7.1.1.Final.zip -d /usr/share/
  ln -s /usr/share/jboss-as{-7.1.1.Final,}
  echo 'JBOSS_HOME=/usr/share/jboss-as' >> $HOME/.bashrc
}

function install_dependencies() {
  echo ">>> Installing dependencies"
  yum install -y unzip # install_jboss already needs unzip installed
  install_rpm & install_jboss
  wait
}

function setup_db() {
  echo ">>> Setting up DB"
  postgresql-setup initdb
  PGCONFIG=/var/lib/pgsql/data/pg_hba.conf
  sed -i "s/\(all\s\+127\.0\.0\.1\/32\s\+\)ident$/\1password/" $PGCONFIG
  sed -i "s/\(all\s\+::1\/128\s\+\)ident$/\1password/" $PGCONFIG
  cat >> /etc/sysctl.d/ovirt-postgresql.conf <<EOF
# ovirt-engine configuration
kernel.shmmax = 68719476736
EOF
  /sbin/sysctl -p /etc/sysctl.d/ovirt-postgresql.conf
  service postgresql restart
  su - postgres -c "psql -d template1 -c \"create user engine password 'engine';\""
  su - postgres -c "psql -d template1 -c \"create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';\""
  chkconfig postgresql on
}

install_dependencies
su - $USER -c "$SCRIPTS_DIR/setup-maven.sh"
setup_db
