# Problema

que pasa si ahora tenemos ambiente prod y ambiente dev?


## Como probar

Para hacer el login:
```
$ gcloud auth login
```

para cargar la cuenta para poder ocupar terraform
```
$ gcloud auth application-default login
```

## Cuales son las IPs

despues del apply, para tener la ip del nodo:

Para dev:

```
IP_SERVER_DEV=$(terraform output -raw public_ip_dev)
```

y con esto hacemos un curl a esa ip:

```
$ curl ${IP_SERVER_DEV}
```

Para prod:

```
IP_SERVER_PROD=$(terraform output -raw public_ip_prod)
```

y con esto hacemos un curl a esa ip:

```
$ curl ${IP_SERVER_PROD}
```

