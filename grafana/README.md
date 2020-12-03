# Grafana

This contains Grafana configuration files.

Learn more about Grafana: http://grafana.org/

## 1. Install using Ansible role:
TBD

## 2. Install using Docker image:
TBD

## 3. Install using Helm chart:

Add Grafana Helm repository:
```console
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
```

Customize your deployment in `values.yaml`:
```console
vi grafana/helm/values.yaml
```

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

To uninstall deployment:
```console
helm uninstall my-grafana
```