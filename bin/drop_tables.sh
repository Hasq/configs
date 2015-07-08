#!/bin/bash
MUSER="$1"
MPASS="$2"
MDB="$3"
 
# Detect paths
MYSQL=$(which mysql)
AWK=$(which awk)
GREP=$(which grep)
 
if [ $# -ne 3 ]
then
	echo "Usage: $0 {MySQL-User-Name} {MySQL-User-Password} {MySQL-Database-Name}"
	echo "Drops all tables from a MySQL"
	exit 1
fi
 
TABLES=$($MYSQL -u $MUSER -p$MPASS $MDB -e 'show tables' | $AWK '{ print $1}' | $GREP -v '^Tables' )

$MYSQL -u $MUSER -p$MPASS $MDB -e "SET GLOBAL FOREIGN_KEY_CHECKS = 0;"

for t in $TABLES
do
	echo "Deleting $t table from $MDB database..."
	$MYSQL -u $MUSER -p$MPASS $MDB -e "drop table $t"
done
$MYSQL -u $MUSER -p$MPASS $MDB -e "SET GLOBAL FOREIGN_KEY_CHECKS = 1;"

exit 0
