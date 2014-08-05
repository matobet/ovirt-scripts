#!/bin/sh

function install_dependencies() {
  yum install git java-devel maven openssl postgresql-server m2crypto python-psycopg2 python-cheetah python-daemon libxml2-python unzip patternfly1
}

function install_jboss() {
  wget http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip &&
  unzip jboss-as-7.1.1.Final.zip -d /usr/share/jboss-as
  echo 'JBOSS_HOME=/usr/share/jboss-as' >> $HOME/.bashrc
}

function setup_db() {
  postgresql-setup initdb
  PGCONFIG=/var/lib/pgsql/data/pg_hba.conf
  sed -i "s/\(all\s\+127\.0\.0\.1\/32\s\+\)ident$/\1password/" $PGCONFIG
  sed -i "s/\(all\s\+::1\/128\s\+\)ident$/\1password/" $PGCONFIG
  service postgresql restart
  su - postgres -c "psql -d template1 -c \"create user engine password 'engine';\""
  su - postgres -c "psql -d template1 -c \"create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';\""
}

install_dependencies
install_jboss
setup_db
