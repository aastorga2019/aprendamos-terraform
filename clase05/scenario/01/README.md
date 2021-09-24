# Ejemplo

Y ahora?

Ya tenemos armado un heath check, pero todavia estamos con la app abajo durante un tiempo, que hacemos?


## Probar

Para probar hay que ejecutar lo siguiente:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090); sleep 1; done
```

Probando con el healthcheck:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090/private/health_check); sleep 1; done
```

