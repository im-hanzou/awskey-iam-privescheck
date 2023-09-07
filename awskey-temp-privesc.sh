#!/bin/bash
# Use Linux / GitBash

set_session_token() {
    read -p "Access key ID: " access_key_id
    read -p "Secret Key: " secret_access_key
    read -p "Session token: " session_token

    if [[ -n "$access_key_id" && -n "$secret_access_key" && -n "$session_token" ]]; then
        export AWS_ACCESS_KEY_ID="$access_key_id"
        export AWS_SECRET_ACCESS_KEY="$secret_access_key"
        export AWS_SESSION_TOKEN="$session_token"
        echo "\nSession token has been set.\n"
    else
        echo "\nMissing input. Session token was not set.\n"
    fi
}

list_roles_for_ec2() {
    roles_output=$(aws iam list-roles 2>&1)

    if [[ $roles_output == *"An error occurred"* ]]; then
        echo -e "\nNot authorized or an error occurred\n"
    elif [ -z "$roles_output" ]; then
        echo -e "\nNo roles found\n"
    else
        roles_ec2=$(echo "$roles_output" | jq -r '.Roles[] | select(.AssumeRolePolicyDocument.Statement[].Principal.Service == "ec2.amazonaws.com") | .RoleName')

        if [ -z "$roles_ec2" ]; then
            echo -e "\nNo roles found for EC2 instances\n"
        else
            echo -e "\nRoles associated with EC2 instances:\n$roles_ec2"
        fi
    fi

}

list_attached_policies() {
    read -p "Insert role: " selected_role
    attached_policies=$(aws iam list-attached-role-policies --role-name "$selected_role")

    if [[ -n "$attached_policies" ]]; then
        echo -e "\nAttached policies for role '$selected_role':\n$attached_policies\n"
    else
        echo -e "\nNo attached policies found for role '$selected_role'\n"
    fi
}

check_ec2_permission() {
    ec2yes=$(aws ec2 describe-instances 2>/dev/null)
    if [[ $ec2yes == *"Reservations"* ]]; then
        echo -e "\nAccess to create Instances available\n"
    else
        echo -e "\nAccess to create Instances not available\n"
    fi
}
unset_session_token() {
    unset AWS_SESSION_TOKEN
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_ACCESS_KEY_ID
    echo "\nSession token has been unset.\n"
}

main_menu() {
    echo -e "\n=== SESSION TOKEN - Permission Check ==="
    echo -e "Permanent env? use : 'source script.sh'\n"
    echo "1. Set AWS Session Token"
    echo "2. Check EC2 Permission"
    echo "3. Check List Roles for EC2 Instances"
    echo "4. Check List Attached Policies" 
    echo "5. Unset Session Token"
    echo -e "\nExit? Press CTRL + C to exit"

    read -rp "Enter your choice: " choice

    case $choice in
        1) set_session_token ;;
        2) check_ec2_permission ;;
        3) list_roles_for_ec2 ;;
        4) list_attached_policies ;;
        5) unset_session_token ;;
        *) echo "Invalid choice";;
    esac

    main_menu
}

main_menu
