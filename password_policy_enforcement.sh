#!/bin/bash

# Password Policy Enforcement Script

# Function to enforce password policy
enforce_password_policy() {
    local min_length=12  # Minimum password length
    local min_classes=3  # Minimum character classes (lowercase, uppercase, digits, special characters)

    # Get list of users
    local users=$(cut -d: -f1 /etc/passwd)

    for user in $users; do
        # Check password length
        passwd_length=$(sudo chage -l $user | grep "Minimum password length" | awk '{print $NF}')
        if [ "$passwd_length" -lt "$min_length" ]; then
            echo "[WARN] User '$user': Password length is less than $min_length characters."
        fi

        # Check password complexity
        passwd_complexity=$(sudo chage -l $user | grep "Minimum number of classes" | awk '{print $NF}')
        if [ "$passwd_complexity" -lt "$min_classes" ]; then
            echo "[WARN] User '$user': Password does not meet complexity requirement of $min_classes character classes."
        fi
    done

    echo "Password policy enforcement check complete."
}

# Execute function
enforce_password_policy
