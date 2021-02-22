# kubernetes bootstrap

This contains some YAML files to bootstrap the environment for K8s cluster
before deploying infrastruture onto it.

## Ingress

I use ingress-nginx for simplicity:

```console
kubectl apply -f kubernetes/k8s-ingress-nginx.yml
```

Read this [docs](https://kubernetes.github.io/ingress-nginx/deploy/baremetal/) to deeply understand about the choices.

You can refer other ingress controllers such as Ambassador, Traefik,...

## Let's Encrypt and TLS

Formerly I use CloudFlare to host my free domain but now CloudFlare drops support
for them so I move to use self-signed:

```console
kubectl apply -f k8s-cert-issuer-selfsigned.yml
```

## TBD

TBD