# Escenario 

Para hacer el login:
```
$ gcloud auth login
```

para cargar la cuenta para poder ocupar terraform
```
$ gcloud auth application-default login
```

## Como probar

despues del apply, para tener la ip del nodo:

```
IP_SERVER=$(terraform output -raw public_ip)
```

y con esto hacemos un curl a esa ip:

```
$ curl ${IP_SERVER}
```
