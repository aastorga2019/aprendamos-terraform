#!/bin/bash
PORT=$1
echo "probando en el Puerto ${PORT}"
while true; do 
  echo -n $(date) 
  output_code=$(curl -s -o /dev/null -w "%{http_code}" localhost:${PORT}/private/health_check) 
  if [[ "${output_code}" == "200" ]]; then
    break;
  fi
  echo " - Todavia no esta ok."
  sleep 1; 
done

echo " - Ahora esta todo ok."

#exist_proxy=$(docker ps | grep proxy | echo $?)
#if [ "$(docker ps | grep proxy)" ]; then 
#  docker exec proxy nginx -s reload
#fi
