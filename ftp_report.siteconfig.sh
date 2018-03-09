# configuration for ftp_report.sh 

# Change all of the values marked CHANGEME; the
# script will not run without it.

sanity_check() {
    value=$1
    varname=$2
    if [ $value = "CHANGEME" ]; then
        echo "\$${varname} is still set to its default value" 1>&2
        echo "Edit $DIR/export_and_ftp.siteconfig.sh to fix this." 1>&2
        exit 1
    fi
}

export KOHA_INSTANCE="CHANGEME"

# Valid values for FILE_TYPE can be text, html, csv or tsv
export FILE_TYPE="CHANGEME"  

# Date format for file name, uses format string 
# for date, without the leading '+'
export DATE_FORMAT="%m%d%Y" 

export FTPSERVER="CHANGEME"
export FTPUSERNAME="CHANGEME"
export FTPPASSWORD="CHANGEME"

sanity_check $KOHA_INSTANCE KOHA_INSTANCE
sanity_check $FILE_TYPE FILE_TYPE
sanity_check $FTPSERVER FTPSERVER
sanity_check $FTPUSERNAME FTPUSERNAME
sanity_check $FTPPASSWORD FTPPASSWORD

# MAILTO=""

if [ ! -z $MAILTO ]; then
    export MAILTO
fi
