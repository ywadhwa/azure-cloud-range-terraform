ENV_DIR ?= infra/envs/baseline

fmt:
	terraform -chdir=$(ENV_DIR) fmt -recursive

validate:
	terraform -chdir=$(ENV_DIR) validate

init:
	terraform -chdir=$(ENV_DIR) init

plan:
	terraform -chdir=$(ENV_DIR) plan

apply:
	terraform -chdir=$(ENV_DIR) apply

clean:
	terraform -chdir=$(ENV_DIR) destroy -auto-approve
