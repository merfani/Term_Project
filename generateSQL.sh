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
i=1

NUM_HOSTS=50

while [ $i -lt $NUM_HOSTS ]; do

echo "insert into types VALUES(\"type$i\");" >> $SQL_FILE
echo "insert into systems VALUES(\"BHost$i\", \"descript\", \"type$i\", \"1\");" >> $SQL_FILE


i=$((i+1))

done
i=1

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
echo "insert into comments (\`date\`, \`comment\`, \`hostname\`, \`admin\`) VALUES (CURRENT_TIMESTAMP, \"comment$i\", \"BHost$i\", \"username$i\");" >> $SQL_FILE
echo "insert into models (\`make\`, \`model\`, \`height\`) VALUES(\"make$i\", \"model$i\", \"$i\");" >> $SQL_FILE
echo "insert into network_addresses VALUES(\"ip_address$i\", \"fqdn$i\", \"interface$i\", \"BHost$i\");" >> $SQL_FILE
echo "insert into operating_systems (\`name\`, \`version\`) VALUES(\"OS_name$i\", \"version$i\");" >> $SQL_FILE
echo "insert into physical_systems VALUES(\"BHost$i\", \"serial$i\", \"$i\", \"$i\", \"$i\", \"assetTag$i\");" >> $SQL_FILE
echo "insert into systems_projects VALUES(\"BHost$i\", \"project_name$i\");" >> $SQL_FILE
i=$((i+1))

done





echo "insert into virtual_systems VALUES(\"BHost1\", \"BHost2\");" >> $SQL_FILE 





