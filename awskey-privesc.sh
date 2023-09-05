#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RESET='\033[0m'

use_aws_credentials() {
    aws configure
    echo -e "\n${GREEN}AWS credentials have been set.${RESET}\n"
}

list_roles_for_ec2() {
    roles_output=$(aws iam list-roles 2>&1)

    if [[ $roles_output == *"An error occurred"* ]]; then
        echo -e "\n${RED}Not authorized or an error occurred${RESET}\n"
    elif [ -z "$roles_output" ]; then
        echo -e "\n${YELLOW}No roles found${RESET}\n"
    else
        roles_ec2=$(echo "$roles_output" | jq -r '.Roles[] | select(.AssumeRolePolicyDocument.Statement[].Principal.Service == "ec2.amazonaws.com") | .RoleName')

        if [ -z "$roles_ec2" ]; then
            echo -e "\n${YELLOW}No roles found for EC2 instances${RESET}\n"
        else
            echo -e "\n${BLUE}Roles associated with EC2 instances:${RESET}\n$roles_ec2"
        fi
    fi
}

list_attached_policies() {
    read -p "Insert role: " selected_role
    attached_policies=$(aws iam list-attached-role-policies --role-name "$selected_role")

    if [[ -n "$attached_policies" ]]; then
        echo -e "\n${BLUE}Attached policies for role '$selected_role':${RESET}\n$attached_policies\n"
    else
        echo -e "\n${YELLOW}No attached policies found for role '$selected_role'${RESET}\n"
    fi
}

check_ec2_permission() {
    ec2yes=$(aws ec2 describe-instances 2>/dev/null)
    if [[ $ec2yes == *"Reservations"* ]]; then
        echo -e "\n${GREEN}Access to create Instances available${RESET}\n"
    else
        echo -e "\n${RED}Access to create Instances not available${RESET}\n"
    fi
}

main_menu() {
    echo -e "\n=== ${YELLOW}AWS CREDENTIALS - Privilege Escalation Checker${RESET} ==="
    echo -e "1. ${GREEN}Set AWS Credentials${RESET}"
    echo -e "2. ${GREEN}Check EC2 Permission${RESET}"
    echo -e "3. ${GREEN}Check List Roles for EC2 Instances${RESET}"
    echo -e "4. ${GREEN}Check List Attached Policies in Roles${RESET}"
    echo -e "5. ${RED}Exit${RESET}"

    read -rp "Enter your choice: " choice

    case $choice in
        1) use_aws_credentials ;;
        2) check_ec2_permission ;;        
        3) list_roles_for_ec2 ;;
        4) list_attached_policies ;;
        5) exit ;;
        *) echo -e "${RED}Invalid choice${RESET}";;
    esac

    main_menu
}

main_menu
