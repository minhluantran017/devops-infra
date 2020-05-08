SCRIPT_DIR := scripts

all: deploy test

deploy_env:
	cd $(SCRIPT_DIR) && ./deploy_env.sh

test_env:
	cd $(SCRIPT_DIR) && ./test_env.sh

destroy_env:
	cd $(SCRIPT_DIR) && ./destroy_env.sh

.PHONY: deploy
deploy: deploy_env

.PHONY: test
test: test_env

.PHONY: destroy
destroy: destroy_env