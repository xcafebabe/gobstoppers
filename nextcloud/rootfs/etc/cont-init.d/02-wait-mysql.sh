#!/usr/bin/with-contenv sh

if [ ${DB_TYPE} = "mysql" ]; then
  echo "Waiting for Mysql"
  until mysql -h"${DB_HOST}" -u"${DB_NAME}" -p"${DB_PASSWORD}" &> /dev/null
  do
    printf "."
    sleep 1
  done

  echo -e "\nmysql is ready"
fi