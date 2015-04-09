#!/bin/bash

# Configuration
# Backups will look like
# $BACKUPDEST/{calendar,contacts}_$CALENDAR_ID-$DATE.{vcf,ics}
DATE=`date +"%y-%m-%d_%H%M"`
BACKUPDEST=/some/path

# Enter your credentials here
HTTPUSER=florian
# you COULD store your password in plaintext here but that would be stupid
# try my small python script to use your OS's encrypted keyring instead
# (tested with GNOME-Keyring)
# https://github.com/fheinle/mutt/blob/master/scripts/kr.py
HTTPPASS=`/home/florian/.mutt/scripts/kr.py get florian@owncloud`
HTTPHOST=https://your-owncloud/installation/
ADDRESS_BOOKS="kontakte"
CALENDAR_IDS="4 6"

for ADDRESS_BOOK in `echo $ADDRESS_BOOKS`;
do

    CONTACTSFILE=$BACKUPDEST/contacts_$ADDRESS_BOOK-$DATE.vcf
    wget --auth-no-challenge --no-clobber \
        --http-user=$HTTPUSER --http-password=$HTTPPASS \
        -O $CONTACTSFILE \
        "$HTTPHOST/remote.php/carddav/addressbooks/$HTTPUSER/$ADDRESS_BOOK?export"
    gzip $CONTACTSFILE
done

for CALENDAR_ID in `echo $CALENDAR_IDS`;
do
    CALENDARFILE=$BACKUPDEST/calendar_$CALENDAR_ID-$DATE.ics
    wget --auth-no-challenge --no-clobber \
        --http-user=$HTTPUSER --http-password=$HTTPPASS \
        -O $CALENDARFILE \
        "$HTTPHOST/index.php/apps/calendar/export.php?calid=$CALENDAR_ID"
    gzip $CALENDARFILE
done