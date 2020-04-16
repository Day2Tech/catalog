# Day2 Catalog

![](https://day2.tech/public/logo.png)

The Day2 catalog is a curated collection of Kubernetes manifests which aim to bootstrap your adoption to Kubernetes by tackling recurring needs in a cluster.

The manifests are mostly intended to be added to your set of cluster infrastructure manifests separated from any of the other application manifests, however, context is key in deciding how to implement these.

The manifests aim to be as plug and play as possible, but they also do not address explicitly resource limits and requests, high availability, etc.

These should be considered on a case by case basis.

## Infrastructure

### [ingress-nginx](ingress-nginx/)

The de-facto ingress to use on Kubernetes.

To deploy, customize the number of replicas and add the directory as a base to your cluster's kustomization.yaml.

It is expected for your cluster to be able to satisfy the request for a loadbalancer service to expose nginx-ingress.

Should that not be possible, please refer to [the official installation guide](https://kubernetes.github.io/ingress-nginx/deploy/) on how to proceed on exposing nginx to the end user.

### [external-dns](external-dns/)

external-dns adds DNS records to your DNS provider based on Kubernetes resources (services, ingresses).

This is one less external resource to create manually, and one more resource managed as code very closely to the rest of the infrastructure.

The default deployment assumes a configuration with CloudFlare.

Please refer to [their tutorials](https://github.com/kubernetes-sigs/external-dns/tree/master/docs/tutorials) to see how to implement it with other providers.

Make sure to update `secret.env` as well as the references from the deployment to the secret variables should you deploy a different provider.

### [loki-stack](loki-stack/)

Loki + Grafana configured from the official Helm charts.

Change `secret.env` to set the Grafana admin password.

An ingress pointing to `loki-stack-grafana:3000` should also be created by you.

Alternatively, Grafana can be accessed with `kubectl port-forward -n loki-stack loki-stack-grafana 3000:3000` at <http://localhost:3000>

### [cert-manager](cert-manager/)

Cert-manager is the standard way to issue ACME (Let's Encrypt) certificates on Kubernetes.

Customize `issuer.yaml` with your email details. 

Refer to [usage docs](https://cert-manager.io/docs/usage/) on how to implement it in your cluster.

## Security

### [pomerium](pomerium/)

Pomerium is an identity aware proxy. Refer to the [blog post](#) on the Day2 website for full instructions on usage.

### [common-network-policy-operator](common-network-policy-operator/)

This operator creates network policies on each namespace automatically.

Some defaults are provided for you in `policies.yaml` which will interact with the catalog's deployments for `pomerium` and `ingress-nginx`.

## Proxy

### [shadowsocks](shadowsocks/)

Shadowsocks is a smart proxy that can hide as regular HTTP+TLS traffic. Refer to the [blog post](#) on the Day2 website for full instructions on usage.