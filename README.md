# booknet_report

SQL Queries and Shell scripts for generating and sending reports from Koha to Booknet Canada.

## Prerequisites

Before you start, contact Booknet Canada, work with them to determine what your `System Code` will be. This will be a short alphabetic code that represents your library.

Booknet will also provide an FTP server name, username and password.

This script assumes the use Koha running on Debian using packaged koha.

You will also need to know the instance name of your koha installation. It will be one of the entries the list generated by runnig the command 

    sudo koha-list

on the console of your Koha server.

From this point forward `SYSTEMCODE` will refer to your booknet system code, and `INSTANCE` will refer to your Koha instance name.

## Setting up the reports

Copy the contents of `branch_data_file.sql` and `lending_file.sql` into new SQL reports. Make sure that you note the report number for each report.

In the branch data report, Change the line that reads
 
    'CHANGEME' AS 'System Code',

Change `CHANGEME` to `SYSTEMCODE`


## Setting up the shell scripts

There are two shell scripts, `ftp_report.siteconfig.sh` and `ftp_report.sh`. These should be placed in the `$HOME` directory of your koha user. This will be `/var/lib/koha/INSTANCE`.



Edit `ftp_report.siteconfig.sh` and change the following lines:

    export KOHA_INSTANCE="CHANGEME"
    export FILE_TYPE="CHANGEME"  
    export FTPSERVER="CHANGEME"
    export FTPUSERNAME="CHANGEME"
    export FTPPASSWORD="CHANGEME"


`KOHA_INSTANCE` will match `INSTANCE`.
`FILE_TYPE` should be `csv`
`FTPSERVER`, `FTPUSERNAME` and `FTPPASSWORD` will be the ftp server, username and password supplied by Booknet Canada.

Because `ftp_report.siteconfig.sh` contains username and password information, you should restrict the permissions using `chmod`. It should be owened by the Koha instance user

    sudo chown INSTANCE-koha:INSTANCE-koha /var/lib/koha/INSTANCE/ftp_report.siteconfig.sh
    sudo chmod 600 /var/lib/koha/INSTANCE/ftp_report.siteconfig.sh

Assuming that the branch data report is report number `20`, and the lendig data report is `21`, the cron entry in `/etc/init.d/koah-instance. Some of this information may already be present in the file.


    #!/bin/bash
    # /etc/cron.d/koha-INSTANCE
    # Default cron file for package INSTANCE koha user. Place in /etc/cron.d/
    # Do not forget to include INSTANCE-koha username before the command

    # m h dom mon dow user command
    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    INST=INSTANCE
    HOMEDIR=/var/lib/koha/INSTANCE
    PERL5LIB=/usr/share/koha/lib
    KOHA_CONF=/etc/koha/sites/INSTANCE/koha-conf.xml
    KOHA_CRON_PATH=/usr/share/koha/bin/cronjobs

    0 1 * * 1 INSTANCE-koha $HOMEDIR/ftp_report.sh 20 BRANCHDATA_SYSTEMCODE
    1 1 * * 1 INSTANCE-koha $HOMEDIR/ftp_report.sh 21 LENDINGDATA_SYSTEMCODE

