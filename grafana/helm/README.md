# Grafana Helm Chart

* Installs the web dashboarding system [Grafana](http://grafana.org/)

## Installing the Chart

Add Grafana Helm repository:
```console
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

Customize your deployment in [values.yaml]:
```console
vi values.yaml
```

- Section `ingress`: to integrate with your ingress controller.
I'm using `ingress-nginx` with a configured DNS record.
- Section `grafana.ini`: to define your Grafana system configuration.

Install the chart with custom `values.yaml`:
```console
helm install -f grafana/helm/values.yaml my-grafana grafana/grafana
```

Get login password for Grafana:
```console
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

Now login to your Grafana with user `admin` and above password. In my case is:
```
http://k8s.mrmarsu.tk:30080/grafana/
```

## Uninstalling the Chart

To uninstall deployment:

```console
helm uninstall my-grafana
```