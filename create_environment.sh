#!/bin/bash

#---------------------
# CRIANDO O AMBIENTE #
#---------------------

# echo -e "\e[44m CRIANDO REDE PARA O SERVIDOR VAULT\033[0m"
# terraform apply -auto-approve

# echo -e "\e[44m CRIANDO AMI PARA O PROJETO\033[0m"
# packer build create_image.json

# echo -e "\e[44m CRIANDO INSTANCIA PARA O PROJETO\033[0m"
# cd create_instance/ && terraform apply -auto-approve

#-------------------------
# DELETA TODO O AMBIENTE #
#-------------------------

# echo -e "\e[44m DELETANDO PROJETO PART 2\033[0m"
# cd create_instance/ && terraform destroy -auto-approve

# echo -e "\e[44m DELETANDO PROJETO PART 1\033[0m"
# terraform destroy -auto-approve