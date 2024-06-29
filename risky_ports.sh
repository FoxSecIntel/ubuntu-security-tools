#!/bin/bash

# Script to identify open ports and services

# List of common risky ports (modify as needed)
declare -a risky_ports=("22" "23" "25" "69" "135" "139" "445" "1433" ¨8443¨ "1521" "3306" "5432" "6379")

# Function to check open port and identify service (if possible)
check_port() {
  local port="$1"
  
  # Check for open port using ss (or netstat if ss is not available)
  if command -v ss &> /dev/null; then
    open_port_info=$(sudo ss -tuln | grep ":$port ")
  else
    open_port_info=$(sudo netstat -tuln | grep ":$port ")
  fi
  
  # Check if port is open and listening
  if [[ -n "$open_port_info" ]]; then
    # Extract service name or PID (if available)
    service_info=$(echo "$open_port_info" | awk '{print $7}')
    if [[ "$service_info" =~ ^tcp/ || "$service_info" =~ ^udp/ ]]; then
      service_info="UNKNOWN"
    fi
    
    echo "  - Port $port (possibly $service_info) is open."
  fi
}

# Check open ports and services
echo "Checking for open ports and services..."

for port in "${risky_ports[@]}"; do
  check_port "$port"
done

echo "Port and service check complete."
