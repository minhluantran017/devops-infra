# Prometheus

This contains Prometheus configuration files.

Learn more about Prometheus: https://prometheus.io/

## 1. Install using Ansible role: 

- https://github.com/cloudalchemy/ansible-prometheus
- https://github.com/prometheus/demo-site

```shell
ansible-galaxy install -r cloudalchemy.prometheus cloudalchemy.alertmanager

ansible-playbook --check ansible/playbooks/prometheus.yml

ansible-playbook --ask-pass --ask-become-pass --inventory-file=/path/to/inventory ansible/playbooks/prometheus.yml
```

## 2. Install using Docker image:

TBD

## 3. Install using Helm chart:

- https://github.com/prometheus-community/helm-charts
- https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus

Add Prometheus Helm repository:
```console
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

Customize your deployment in `values.yaml`:
```console
vi prometheus/helm/values.yaml
```

Install the chart with custom `values.yaml`:
```console
helm install my-prometheus prometheus-community/prometheus -f prometheus/helm/values.yaml
```

Prometheus server is now available at below URL (in my case):
```
http://k8s.mrmarsu.tk:30080/prometheus/
```

Uninstall the deployment:
```console
helm uninstall my-prometheus
```

*TODO*:
- Add scrape configs
- Add Persistent Volume 