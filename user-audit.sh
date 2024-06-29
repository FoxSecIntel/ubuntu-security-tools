#!/bin/bash

# User Account Audit Script

# Function to check for inactive user accounts
check_inactive_accounts() {
    local inactive_days_threshold=90  # Adjust as per your organization's policy
    local today=$(date +%s)
    
    echo "Checking for inactive user accounts..."

    while IFS=: read -r username _ uid _ _ home shell; do
        if [ -d "$home" ]; then
            last_login=$(sudo lastlog -u "$username" -t 365 | grep "$username" | awk '{print $4" "$5" "$6}')
            if [ -n "$last_login" ]; then
                last_login_epoch=$(date -d "$last_login" +%s)
                inactive_days=$(( (today - last_login_epoch) / (24 * 3600) ))
                if [ $inactive_days -gt $inactive_days_threshold ]; then
                    echo "[WARN] User '$username' has been inactive for $inactive_days days."
                fi
            else
                echo "[WARN] User '$username' has never logged in."
            fi
        fi
    done < /etc/passwd

    echo "Inactive account check complete."
}

# Function to check for unauthorized privilege escalation
check_privilege_escalation() {
    echo "Checking for unauthorized privilege escalation..."

    # List sudoers with NOPASSWD privilege
    sudo grep -Po '^(?!#)\s*\b\w+\b\s+(ALL=(ALL:ALL) NOPASSWD:ALL)' /etc/sudoers

    # List suoders without NOPASSWD privilege
    sudo grep -Po '^(?!#)\s*\b\w+\b\s+ALL=(ALL:ALL)' /etc/sudoers

    echo "Privilege escalation check complete."
}

# Function to check for unusual login patterns
check_unusual_logins() {
    echo "Checking for unusual login patterns..."

    # Example: List users who have logged in from IP addresses outside a specified range
    lastlog | grep -v 'Never logged in' | awk '{print $1}' | while read -r user; do
        last -i "$user" | grep -v 'still logged in' | awk '{print $3}' | grep -v '0.0.0.0' | grep -v '192.168.' | grep -v '127.0.' | grep -v '10.' | grep -v '172.[16-32].' | awk '{print $1}' | sort | uniq -c | sort -n | tail -1
    done

    echo "Unusual login pattern check complete."
}

# Execute functions
check_inactive_accounts
check_privilege_escalation
check_unusual_logins

echo "User account audit script complete."
