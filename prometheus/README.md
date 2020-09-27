Contains Prometheus configuration files.

Learn more about Prometheus: 
- https://prometheus.io/

Install using Ansible role: 
- https://github.com/cloudalchemy/ansible-prometheus
- https://github.com/prometheus/demo-site

```shell
ansible-galaxy install -r cloudalchemy.prometheus cloudalchemy.alertmanager

ansible-playbook --check ansible/playbooks/prometheus.yml

ansible-playbook --ask-pass --ask-become-pass --inventory-file=/path/to/inventory ansible/playbooks/prometheus.yml
```
