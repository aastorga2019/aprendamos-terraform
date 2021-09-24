# Ejemplo

Arreglamos algo para romper otra cosa :( ... que hacemos ahora?

## Actualizar NGINX

Lo que si, es que cada vez que se actualiza la IP tenemos que decirle a NGINX que actualice sus reglas.

Como lo hacemos?

```
docker exec proxy nginx -s reload
```

## Probar

Para probar hay que ejecutar lo siguiente:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090); sleep 1; done
```

Probando con el healthcheck:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090/private/health_check); sleep 1; done
```

