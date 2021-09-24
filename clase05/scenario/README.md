# Ejemplo

En este ejemplo vamos a tratar de armar un cambio de version de imagen y/o cambio de variables de entorno si producir downtime.

## Que cambio realizar?

La idea es cambiar a la version 2 de la imagen y ver si hay un downtime o no.

## Probar

Para probar hay que ejecutar lo siguiente:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090); sleep 1; done
```

Probando con el healthcheck:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090/private/health_check); sleep 1; done
```

## NOTA

Esto es una POSIBLE solucion, no es la unica, ni tampoco es la mejor... xD

Si hay alguna mejora u otra propuesta, por favor realiza el PR. Muchas gracias :D
