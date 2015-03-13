while ! mysql -h${MYSQL_PORT_3306_TCP_ADDR} -p${MYSQL_ENV_MYSQL_ROOT_PASSWORD}  -e ";" ; do
  sleep 1s
done
~   
