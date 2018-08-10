#!/bin/bash

#
# Script to run reports and ftp resluts.
# Assuming being run on package site
#
# Usage: ./ftp_report.sh REPORT_NUMBER FILENAME_BASE
# e.g. ./ftp_report.sh 170 BRANCHDATA_HUNTON
#
# The script back-dates the file name by 1 day, as it is assumed to be running
# in the early morning. 
PERL=$(which perl)
ID_REPORT_NUMBER="${1}"
FILE_BASE="${2}"

# find the directory that this code is being called from.
# see http://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  # if $SOURCE was a relative symlink, we need to resolve it
  # relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" 
done
export DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# The site config file 'ftp_report.siteconfig.sh' should reside
# in the same directory as this file.  ftp_report.siteconfig.sh
# contains $FILE_TYPE, $KOHA_INSTANCE, $FTPSERVER,
# $FTPUSERNAME, $FTPPASSWORD, ID_REPORT_NUMBER and optionally $MAILTO.

if [ -f "$DIR/ftp_report.siteconfig.sh" ]; then
    source "$DIR/ftp_report.siteconfig.sh"
fi

export UPCASE_KOHA_INSTANCE=$(echo "$KOHA_INSTANCE" | tr '[:lower:]' '[:upper:]')
export KOHA_CONF=/etc/koha/sites/${KOHA_INSTANCE}/koha-conf.xml
export PERL5LIB=/usr/share/koha/lib

KOHA_CRON_PATH="/usr/share/koha/bin/cronjobs"
export KOHAHOMEDIR="/var/lib/koha/${KOHA_INSTANCE}"

FTPFILE="$EXPORTFILE.gz"

# run exportbiblios.pl and create the marc export
cd $KOHAHOMEDIR

export ID_LIST_FILE="${FILE_BASE}_$(date +%m%d%Y -d '1 day ago').${FILE_TYPE}"

$KOHA_CRON_PATH/runreport.pl --format=csv ${ID_REPORT_NUMBER} > $KOHAHOMEDIR/${ID_LIST_FILE}

if [ $? -ne 0 ]; then
    echo "$KOHA_CRON_PATH/runreport.pl failed for report number ${ID_REPORT_NUMBER}" 1>&2
    exit $?
fi

ftp -pin $FTPSERVER <<EOF
user $FTPUSERNAME $FTPPASSWORD
put ${ID_LIST_FILE}
quit
EOF

# Cleanup if ftp was successful.
if [ $? -eq 0 ]; then
    rm $KOHAHOMEDIR/${ID_LIST_FILE}
else
    echo "File transfer to $FTPSERVER failed" 1>&2
    exit $?
fi

if [ ! -z $MAILTO ]; then
    mailx -s "${ID_LIST_FILE} for site ${KOHA_INSTANCE} has been uploaded" $MAILTO < /dev/null
fi

exit 0
