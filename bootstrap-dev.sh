#!/bin/sh
#
# Basic script that sets up the development environment for the oVirt engine
# After completion run git clone git://gerrit.ovirt.org/ovirt-engine in suitable directory

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
  service postgresql restart
  su - postgres -c "psql -d template1 -c \"create user engine password 'engine';\""
  su - postgres -c "psql -d template1 -c \"create database engine owner engine template template0 encoding 'UTF8' lc_collate 'en_US.UTF-8' lc_ctype 'en_US.UTF-8';\""
}

function setup_maven() {
  echo ">>> Adjusting maven settings for GWT compilation"
  mkdir $HOME/.m2
  cat > $HOME/.m2/settings.xml <<EOF
<settings xmlns="http://maven.apache.org/POM/4.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                              http://maven.apache.org/xsd/settings-1.0.0.xsd">

<!--**************************** PROFILES ****************************-->

  <activeProfiles>
    <activeProfile>gwtdev</activeProfile>
  </activeProfiles>

  <profiles>
    <profile>
      <id>gwtdev</id>
      <properties>
        <gwt.userAgent>gecko1_8</gwt.userAgent>
      </properties>
    </profile>
  </profiles>
</settings>
EOF
}

install_dependencies
setup_maven
setup_db
