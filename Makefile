# make init
# make upgrade
# make validate
# make plan
# make apply
# make clean

workspace     = `terraform workspace show`
project       = "eks-cluster"
planfile      = "${project}-${workspace}.tfplan"
maintfdir     = ../../terraform
backendconfig = -backend-config=${maintfdir}/remote-backend.tfvars
tfvariables   = "-var-file=eks-config.tfvars -var-file=../../terraform/shared/network.tfvars -var-file=../../terraform/shared/aws.tfvars"
YELLOW        = \033[0;33m
RED           = \033[0;31m
NC            = \033[0m

.PHONY: init
init:
	@terraform init ${backendconfig}

.PHONY: upgrade
upgrade:
	@terraform init -upgrade ${backendconfig}

.PHONY: validate
validate:
	@terraform validate "${tfvariables}" && echo "terraform successfully validated"

.PHONY: plan
plan:
	@echo "\n${YELLOW}Planning for cluster: ${workspace}${NC}" && terraform plan "${tfvariables}" -lock=true -refresh=true "-out=${planfile}" .

.PHONY: apply
apply:
	@echo "\n${YELLOW}Applying for cluster: ${workspace}${NC} (any key to continue, or ctrl-c)" && read -r answer && terraform apply -lock=true "${planfile}" && rm "${planfile}"

# Shouldn't be needed under most circumstances
.PHONY: clean
clean:
	@rm *.tfplan && rm -rf .terraform/ && echo "tfplan's removed, and .terraform plugins and local state wiped. Please 'make init' next"

.PHONY: destroy
destroy:
	@echo "\n${RED}Destroying cluster: ${workspace}${NC} (enter to continue, or ctrl-c)" && read -r answer && terraform destroy "${tfvariables}" -lock=true -refresh=true

.PHONY: ssh
ssh: connect
.PHONY: connect
connect: export HEADING = "Connecting to SSH"
connect:
	@echo -e "\nStep : ${RED}$${HEADING}${NC} - ${workspace} \n--------------------------------------------\n"
	@./connect ${project}
