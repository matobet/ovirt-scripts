#!/bin/sh

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