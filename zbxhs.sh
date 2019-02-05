#!/bin/bash
#    Manual housekeeping for mediums and large installations
#    running with Mysql
#
#    Based on Jalexandre0 pgsql script => https://github.com/jalexandre0/zabbix/blob/master/scripts/housekeeping.sh
#    Forked and Modified by Guto Carvalho on 2013-07-20 gutocarvalho@gmail.com
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

#Setting atual date
echo $(date +%d/%m/%Y-%H:%M)

# Connection settings
ZBX_CONN="$(which mysql)"
read -p "Enter Database name" ZBX_DATA
read -p "Enter Database user" ZBX_USER
read -p "Enter Database password" ZBX_PASS
read -p "Enter Database host" ZBX_HOST

#One year and month ago in Unix Timestamp
ONE_YEAR_AGO=$(expr `date +%s` - 31536000)
ONE_MONTH_AGO=$(expr `date +%s` -  2678400)


#Queries for one month ago
MONTH_TABLES="history history_uint history_str history_text history_log"
for table in $MONTH_TABLES;do
	echo "Deleting from table $table "
	DELETES=$( $ZBX_CONN -u $ZBX_USER $ZBX_DATA -p$ZBX_PASS -h $ZBX_HOST -e "delete from $table where clock < $ONE_MONTH_AGO ;" )
	echo " $DELETES from table $table "
done

#Queries for one year ago
YEAR_TABLES="alerts trends trends_uint"
for table in $YEAR_TABLES;do
	echo "Deleting from table $table "
	DELETES=$( $ZBX_CONN -u $ZBX_USER $ZBX_DATA -p$ZBX_PASS -h $ZBX_HOST -e "delete from $table where clock < $ONE_YEAR_AGO ;" )
	echo "$DELETES from table $table"
done
