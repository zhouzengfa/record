#!/bin/bash

dbs=$(mysql -uroot -proot -Ne "show databases")
echo ${dbs}

for db in $dbs
do
 exist=$(mysql -uroot -proot -D $db -Ne "show tables" | grep -ow role_0)
 if [ x"$exist" == x"" ]; then
  echo $db "not exist role"
 else
  mysql -uroot -proot -D$db -e "show tables;"
 fi

done

