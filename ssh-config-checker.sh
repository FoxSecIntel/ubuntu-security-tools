#!/bin/bash

# SSH Configuration Checker Script

# Define the SSH configuration file
SSH_CONFIG_FILE="/etc/ssh/sshd_config"

# Function to check SSH server configuration settings
check_ssh_config() {
    local param_name="$1"
    local expected_value="$2"

    # Use grep to find the parameter in the SSH config file
    result=$(grep -E "^\s*$param_name\s+" "$SSH_CONFIG_FILE" | awk '{print $2}')

    if [ -z "$result" ]; then
        echo "[WARN] $param_name is not defined in $SSH_CONFIG_FILE"
    else
        if [ "$result" != "$expected_value" ]; then
            echo "[WARN] $param_name is set to $result (expected: $expected_value)"
        else
            echo "[OK] $param_name is correctly configured"
        fi
    fi
}

# Check specific SSH configuration settings
check_ssh_config "PermitRootLogin" "no"
check_ssh_config "PasswordAuthentication" "no"
check_ssh_config "AllowTcpForwarding" "no"
check_ssh_config "X11Forwarding" "no"
check_ssh_config "MaxAuthTries" "3"
check_ssh_config "Protocol" "2"
check_ssh_config "LoginGraceTime" "30s"

# Additional checks can be added based on your security policies

# Example of logging SSH banner configuration
check_ssh_config "Banner" "/etc/issue.net"

echo "SSH configuration audit complete."
