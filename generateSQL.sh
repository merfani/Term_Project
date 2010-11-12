#!/bin/sh


NUM_SYSTEMS=5
i=1
SQL_FILE=populater.sql


rm $SQL_FILE

#echo "drop database inventory;" >> $SQL_FILE 
echo "create database inventory;" >> $SQL_FILE
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









