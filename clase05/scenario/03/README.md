# Ejemplo

Bueno... esto es aburrido, es solo para evitar el bug de las imagenes de docker con el provider de terraform, pero en el proximo ejemplo si vamos a ver algo.....


## Probar

Para probar hay que ejecutar lo siguiente:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090); sleep 1; done
```

Probando con el healthcheck:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090/private/health_check); sleep 1; done
```

