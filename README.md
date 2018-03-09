# booknet_report

SQL Queries and Shell scripts for generating and sending reports from Koha to Booknet Canada.

Before you start, contact Booknet Canada, work with them to determine what your `System Code` will be. This will be a short alphabetic code that represents your library.

Booknet will also provide an FTP server name, username and password.

This script assumes the use Koha running on Debian using packaged koha.

Copy the contents of `branch_data_file.sql` and `lending_file.sql` into new SQL reports. Make sure that you note the report number for each report.

In the branch data report, Change the line that reads
 
    'CHANGEME' AS 'System Code',

`CHANGEME` will be the agreed upon system code. 

There are two shell scripts, `ftp_report.siteconfig.sh` and `ftp_report.sh`. These should be placed in the `$HOME` directory of your koha user. This will be `/var/lib/koha/INSTANCE`, where `INSTANCE` matches one of the entries from `sudo koha-list`.

Edit `ftp_report.siteconfig.sh` and change the following lines:

    export KOHA_INSTANCE="CHANGEME"
    export FILE_TYPE="CHANGEME"  
    export FTPSERVER="CHANGEME"
    export FTPUSERNAME="CHANGEME"
    export FTPPASSWORD="CHANGEME"

`KOHA_INSTANCE` will match `INSTANCE` above.
`FILE_TYPE` should be `csv`
`FTPSERVER`, `FTPUSERNAME` and `FTPPASSWORD` will be the ftp server, username and password supplied by Booknet Canada.
