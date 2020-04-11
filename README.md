# Demo DevOps Infrastructure as Code (IaC)

## What is this?

The purpose of this repo is to create a basic DevOps environment for practice.

## Prerequisites

- You should have a bunch of Virtual Machines for this demo.
Here I use KVM and OpenStack for hosting.

- Optionally, you should have an active Amazon Web Service account (free-tier eligible).

## Usage

```sh
# Configure the variables before setting up
./configure

# Code validation
make validate

# Setup the virtual machines
make setup

# Deploy the environment
make deploy

# Test the environment
make test

# Destroy the environment
make destroy

```

## Code of Conduct

- Create branch for each component from `master` with convention: `dev_<yourname>_<component>`.
For example: `dev_luan_jenkins`.

- Specify each component's configuration files/code under its directory.
And Ansible playbooks/ inventories under `ansible` directory.

- Please always create Pull Request to merge it to `master`.

- If you see any issue with code in `master` branch, just create an [issue](https://github.com/minhluantran017/devops-infra/issues/new/) with title: `[component] Issue ABC bla bla`

## Licenses

See licenses

## Contributing

Please read above *Code of Conduct* before contributing.

See list of contributors [here](contributing).