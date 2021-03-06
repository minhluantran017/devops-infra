# Demo DevOps Infrastructure as Code (IaC)

![](https://github.com/minhluantran017/devops-infra/workflows/Validate%20Terraform%20plans/badge.svg)

## What is this?

The purpose of this repo is to practise DevOps Infrastructure as Code (IaC).

List of components that will be handled in this repo: 
* Jenkins
* JFrog artifactory
* LDAP server
* InfluxDB
* Prometheus
* Grafana
* Elastic Stack

## Prerequisites

- You should have a bunch of Virtual Machines for this demo, for example KVM, OpenStack, Amazon EC2.
- Optionally, you should have an active Amazon Web Service account (free-tier eligible).

## Usage

WORKING IN-PROGRESS

```sh
# Configure the variables before setting up
./configure

# Deploy the environment
make deploy

# Test the environment
make test

# Destroy the environment
make destroy

```

## Code of Conduct

- Create branch for each component from `master` with convention: `<yourname>_<component>`.
For example: `luan_jenkins`.

- Place each component's configuration files/code under its own directory. Read its own `README.md` for more information.
- Place Terraform plans under `terraform` directory. Read [README](terraform/README.md) for more information.
- Place Ansible playbooks under `ansible` directory. Read [README](ansible/README.md) for more information.
- Place common scripts under `scripts` directory.

- Please always create Pull Request to merge it to `master`. Only merge if all the tests pass.

## Licenses

See [licenses](licences)

## Contributing

Please read above *Code of Conduct* before contributing.

See list of contributors [here](contributing.md).