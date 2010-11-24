#!/bin/sh


NUM_SYSTEMS=5
i=1
SQL_FILE=populater.sql


if [ -e $SQL_FILE ]; then rm $SQL_FILE; fi

echo "drop database IF EXISTS  inventory;" >> $SQL_FILE 
echo "create database IF NOT EXISTS inventory;" >> $SQL_FILE
cat schema.sql >> $SQL_FILE


while [ $i -lt $NUM_SYSTEMS ]; do

echo "insert into operating_systems VALUES(\"\",\"os_name_$i\", \"version_$i\");" >> $SQL_FILE
echo "insert into types VALUES(\"type_$i\");" >> $SQL_FILE
echo "insert into systems VALUES(\"hostname_$i\", \"descript_$i\", \"type_$i\", \"$i\");" >> $SQL_FILE


i=$((i+1));

done

######################
#add a lot of hosts of the same type and os id
i=0

NUM_HOSTS=40

while [ $i -lt $NUM_HOSTS ]; do

echo "insert into systems VALUES(\"BHost$i\", \"descript\", \"type_1\", \"1\");" >> $SQL_FILE

i=$((i+1))

done

i=0

#=====================
#add administrators

NUM_ADMINS=50

while [ $i -lt $NUM_ADMINS ]; do

echo "insert into datacenter VALUES(\"datacenter$i\", \"dc_address$i\");" >> $SQL_FILE
echo "insert into cabinets(\`row\`, \`column\`, datacenter_name) VALUES(\"rack_row$i\", \"rack_column$i\", \"datacenter$i\" );" >> $SQL_FILE
echo "insert into customers VALUES(\"customer_name$i\", \"cust@email$i.com\");" >> $SQL_FILE
echo "insert into projects VALUES(\"project_name$i\", \"customer_name$i\");" >> $SQL_FILE
echo "insert into administrators VALUES(\"username$i\", \"name$i\");" >> $SQL_FILE
echo "insert into administrators_projects VALUES(\"username$i\", \"project_name$i\", \"role$i\");" >> $SQL_FILE
i=$((i+1))

done








