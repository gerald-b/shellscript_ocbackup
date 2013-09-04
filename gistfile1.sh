#!/bin/bash

# Configuration
# Backups will look like
# $BACKUPDEST/{calendar,contacts}_$CALENDAR_ID-$DATE.{vcf,ics}
DATE=`date +"%y-%m-%d_%H%M"`
BACKUPDEST=/some/path

# Enter your credentials here
HTTPUSER=florian
HTTPPASS=`/home/florian/.mutt/scripts/kr.py get florian@owncloud`
HTTPHOST=https://your-owncloud/installation/
CONTACTS_IDS=2
CALENDAR_IDS="4 6"

for CONTACTS_ID in `echo $CONTACTS_IDS`;
do

    CONTACTSFILE=$BACKUPDEST/contacts_$CONTACTS_ID-$DATE.vcf
    wget --auth-no-challenge --no-clobber \
        --http-user=$HTTPUSER --http-password=$HTTPPASS \
        -O $CONTACTSFILE \
        "$HTTPHOST/?app=contacts&getfile=export.php?bookid=$CONTACTS_ID"
    gzip $CONTACTSFILE
done

for CALENDAR_ID in `echo $CALENDAR_IDS`;
do
    CALENDARFILE=$BACKUPDEST/calendar_$CALENDAR_ID-$DATE.ics
    wget --auth-no-challenge --no-clobber \
        --http-user=$HTTPUSER --http-password=$HTTPPASS \
        -O $CALENDARFILE \
        "$HTTPHOST/?app=calendar&getfile=export.php?calid=$CALENDAR_ID"
    gzip $CALENDARFILE
done