#!/bin/sh
PATH=$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH
export VUFIND_HOME=/usr/local/vufind/
export VUFIND_LOCAL_DIR=/usr/local/vufind/local
find  /usr/local/vufind/local/harvest/ELAR/ -name '*.xml' -exec rm {} \;
find  /usr/local/vufind/local/harvest/ELAR/processed/ -name '*.xml' -exec rm {} \;
find  /usr/local/vufind/local/harvest/Authors/processed/ -name '*.xml' -exec rm {} \;
find  /usr/local/vufind/local/harvest/Authors/ -name '*.xml' -exec rm {} \;
cd /usr/local/vufind/harvest
#find  $VUFIND_HOME/local/harvest/ELAR/processed -name '*.xml' | xargs cp -t $VUFIND_HOME/local/harvest/Authors/
/usr/bin/php harvest_oai.php ELAR
cd /usr/local/vufind/local/harvest/ELAR/
find  /usr/local/vufind/local/harvest/ELAR/ -name '*.xml' -exec sed -i 's/&#13;//g' {} \;
/usr/local/vufind/harvest/batch-import-xsl.sh ./ELAR/ ../import/elar-scb.properties
#find  $VUFIND_HOME/local/harvest/ELAR/processed -name '*.xml' | xargs mv -t $VUFIND_HOME/local/harvest/Authors/
#/usr/local/vufind/harvest/batch-import-xsl-auth.sh ./Authors/ ../import/authors.properties
cd /usr/local/vufind/util
php deletes.php intermediate.txt flat
php optimize.php