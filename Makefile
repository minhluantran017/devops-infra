TERRAFORM_DIR := terraform
PLAYBOOK_DIR := ansible

all: validate setup deploy test

terraform_validate:
	cd $(TERRAFORM_DIR) && terraform validate

terraform_init:
	cd $(TERRAFORM_DIR) && terraform init

terraform_apply:
	cd $(TERRAFORM_DIR) && terraform apply

terraform_destroy:
	cd $(TERRAFORM_DIR) && terraform destroy

ansible_validate:
	cd $(PLAYBOOK_DIR) && ansible-playbook --syntax-check playbook.yml

ansible_deploy:
	cd $(PLAYBOOK_DIR) && ansible-playbook -v playbook.yml

post_config:
	echo "TBD"

test_env:
	echo "TBD"

.PHONY: validate
validate: terraform_validate ansible_validate

.PHONY: setup
setup: terraform_apply

.PHONY: deploy
deploy: ansible_deploy post_config

.PHONY: test
test: test_env

.PHONY: destroy
destroy: terraform_destroy