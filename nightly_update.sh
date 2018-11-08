#!/bin/sh
# @name: nightly_update.sh
# @version: 1.0
# @creation_date: Unknown
# @license: GNU General Public License version 3 (GPLv3) <https://www.gnu.org/licenses/gpl-3.0.en.html>
# @author: Scanbit <info.sca.ils@gmail.com>
#
# @purpose:
# This program performs a nightly harvest from LAT and updates VuFind
 
PATH=$PATH:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH
export VUFIND_HOME=/usr/local/vufind/
export VUFIND_LOCAL_DIR=/usr/local/vufind/local

#Remove old XML files
find  /usr/local/vufind/local/harvest/ELARALL/ -name '*.xml' -exec rm {} \;
find  /usr/local/vufind/local/harvest/ELAR/processed/ -name '*.xml' -exec rm {} \;
find  /usr/local/vufind/local/harvest/Authors/processed/ -name '*.xml' -exec rm {} \;

#Remove old log files
cd /usr/local/vufind/harvest
rm -Rf /usr/local/vufind/local/harvest/ELARALL/*.txt
rm -Rf /usr/local/vufind/local/harvest/ELARALL/*.log

#Harvest new ELARALL records from LAT 
#(ELARALL and ELAR seem to have the exact same specifications. Unclear why this is divided into two processes.)
/usr/bin/php harvest_oai.php ELARALL
cd /usr/local/vufind/update
php update-new.php > update-new.log

#Harvest new ELAR records from LAT
cd /usr/local/vufind/harvest
> /usr/local/vufind/local/harvest/ELAR/soas-lat-harvest.log
#find  $VUFIND_HOME/local/harvest/ELAR/processed -name '*.xml' | xargs cp -t $VUFIND_HOME/local/harvest/Authors/
/usr/bin/php harvest_oai.php ELAR
cd /usr/local/vufind/local/harvest/ELAR/

#Find and replace some error in the XML files
find $VUFIND_HOME/local/harvest/ELAR/ -name '*.xml' | xargs sed -i 's/&#13;//g'

#Batch import XML files into VuFind using XSLT stylesheet. This stylesheet is saved as /usr/local/vufind/local/import/xsl/elar-scb.xslt
/usr/local/vufind/harvest/batch-import-xsl.sh ./ELAR/ ../import/elar-scb.properties

#Once those files are imported, it is necessary to extract and import depositor profiles. This stylesheet is saved as /usr/local/vufind/local/import/xsl/authors.xsl
find  $VUFIND_HOME/local/harvest/ELAR/processed -name '*.xml' | xargs mv -t $VUFIND_HOME/local/harvest/Authors/
/usr/local/vufind/harvest/batch-import-xsl-auth.sh ./Authors/ ../import/authors.properties

#Create alphabetic browse index
cd /usr/local/vufind
./index-alphabetic-browse.sh

#Create sitemap
cd /usr/local/vufind/util
php /usr/local/vufind/util/sitemap.php
php deletes.php intermediate.txt flat
php optimize.php

