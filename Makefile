.PHONY: deploy init apply ansible destroy help
SHELL        := bash
.SHELLFLAGS  := -e -c
.ONESHELL:

TERRAFORM_DIR := terraform
ANSIBLE_DIR   := ansible
SECRET_KEY    := secret/ec2_key.pem

define prompt_vars
	printf "\n=== Configure Terraform Variables ===\n"
	read -p "  AWS region           [us-east-1]:              " aws_region;    aws_region=$${aws_region:-us-east-1}
	read -p "  Instance type        [t3.medium]:              " instance_type; instance_type=$${instance_type:-t3.medium}
	read -p "  Key pair name        [fluxcd-gitops-key]:      " key_name;      key_name=$${key_name:-fluxcd-gitops-key}
	read -p "  Instance name        [fluxcd-gitops-instance]: " instance_name; instance_name=$${instance_name:-fluxcd-gitops-instance}
	read -p "  Root volume GB       [30]:                     " volume_size;   volume_size=$${volume_size:-30}
	printf "\n"
endef

define tf_var_flags
-var="aws_region=$$aws_region" \
-var="instance_type=$$instance_type" \
-var="key_name=$$key_name" \
-var="instance_name=$$instance_name" \
-var="root_volume_size=$$volume_size"
endef

## deploy: prompt vars → init → apply (auto-approve) → ansible
deploy:
	@$(prompt_vars)
	ROOT=$$(pwd)
	cd $(TERRAFORM_DIR) && terraform init -input=false
	terraform apply -auto-approve $(tf_var_flags)
	cd $$ROOT
	chmod 400 $(SECRET_KEY)
	cd $(ANSIBLE_DIR) && ansible-playbook playbook.yml

## init: terraform init only
init:
	@cd $(TERRAFORM_DIR) && terraform init -input=false

## apply: prompt vars → terraform apply (with confirmation)
apply:
	@$(prompt_vars)
	ROOT=$$(pwd)
	cd $(TERRAFORM_DIR) && terraform init -input=false
	terraform apply $(tf_var_flags)
	cd $$ROOT
	chmod 400 $(SECRET_KEY)

## ansible: run ansible playbook (key chmod + playbook)
ansible:
	@chmod 400 $(SECRET_KEY)
	cd $(ANSIBLE_DIR) && ansible-playbook -i inventory.ini playbook.yml

## destroy: tear down all AWS resources
destroy:
	@cd $(TERRAFORM_DIR) && terraform destroy -auto-approve

## help: list available targets
help:
	@grep -E '^## ' Makefile | sed 's/## /  /'
