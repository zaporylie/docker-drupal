#!/bin/sh

WaitForMySQL ()
{
    LOOP_LIMIT=60
    for (( i=0 ; ; i++ )); do
        if [ ${i} -eq ${LOOP_LIMIT} ]; then
            echo "Time out."
            exit 1
        fi
        echo "=> Waiting for confirmation of MySQL service startup, trying ${i}/${LOOP_LIMIT} ..."
        sleep 1
        mysql -h${MYSQL_HOST_NAME} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD}  -e ";" > /dev/null 2>&1 && break
    done
}

WaitForMySQL
