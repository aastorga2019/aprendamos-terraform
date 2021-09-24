# Ejemplo

Para probar hay que ejecutar lo siguiente:

```
while true; do echo $(date) $(curl -m 1 -s localhost:9090); sleep 1; done
```
