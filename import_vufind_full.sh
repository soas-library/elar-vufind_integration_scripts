#!/bin/sh
# @name: import_vufind_full.sh
# @version: 1.0
# @creation_date: Unknown
# @license: GNU General Public License version 3 (GPLv3) <https://www.gnu.org/licenses/gpl-3.0.en.html>
# @author: Scanbit <info.sca.ils@gmail.com>
#
# @purpose:
# This program performs a full harvest from LAT and updates VuFind

export LANG="en_GB.UTF-8"
export VUFIND_HOME=/usr/local/vufind/
export VUFIND_LOCAL_DIR=/usr/local/vufind/local

#Remove dates of last harvest
rm -Rf /usr/local/vufind/local/harvest/ELAR/last_state.txt
rm -Rf /usr/local/vufind/local/harvest/ELAR/last_harvest.txt

# Remove old log files and XML files from last harvest
rm -Rf /usr/local/vufind/local/harvest/ELARALL/*.txt
rm -Rf /usr/local/vufind/local/harvest/ELARALL/*.log
find  /usr/local/vufind/local/harvest/ELARALL/ -name '*.xml' -exec rm {} \;

#Harvest new ELARALL records from LAT
cd /usr/local/vufind/harvest
/usr/bin/php harvest_oai.php ELARALL
cd /usr/local/vufind/update
php update-new.php > /home/vufind/logs/update-new.log

# End Delete process
cd /usr/local/vufind/harvest
/home/vufind/scripts/harvest_from_lat.sh > /home/vufind/logs/harvest.log 2>&1
rm -Rf /usr/local/vufind/local/harvest/ELARALL/*.log

#Create alphabetic browse index
/usr/local/vufind/index-alphabetic-browse.sh 2> /usr/local/vufind/index-alphabetic-browse.log

#Create sitemap
php /usr/local/vufind/util/sitemap.php

#Remove old Solr logs
rm -fr /usr/local/vufind/solr/jetty/logs/*.log

#Change permissions of folders that can be overwritten 
#Cambiamos permisos de la carpeta de caratulas pra que se puedan sobreescribir
chmod 666 /usr/local/vufind/local/cache/covers/medium/*
chmod 666 /usr/local/vufind/local/cache/covers/small/*
chmod 666 /usr/local/vufind/local/cache/covers/large/*

#Kill Java processes and restart VuFind
killall java
/usr/local/vufind2/vufind.sh restart
#systemctl restart vufind