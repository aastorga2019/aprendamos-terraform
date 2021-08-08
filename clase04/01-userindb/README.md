# Base de datos con usuarios

Hola, para poder acceder al PHPmyAdmin desde localhost:9090 prueba con el usuario root y el password esta aqui:

```
terraform show -json | jq -r '.values.root_module.resources[] | select(.address=="random_password.admin_db_password").values.result'
```

Para listar los usuarios:

```
select user from mysql.user;
```


Para ver los permisos de los usuarios:

```
show grants for 'vilma';
```
