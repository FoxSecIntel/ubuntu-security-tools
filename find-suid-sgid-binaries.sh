#!/bin/bash

# Script to find SUID/SGID binaries

# Output directory
OUTPUT_DIR="./suid_sgid_results"
mkdir -p "$OUTPUT_DIR"

# Function to find and print SUID/SGID files
find_suid_sgid_files() {
  local output_file="$OUTPUT_DIR/suid_sgid_files.txt"
  echo "Finding all SUID/SGID files (excluding directories)..."
  find / -type f -perm /6000 -print 2>/dev/null > "$output_file"
  local count=$(wc -l < "$output_file")
  echo "Found $count SUID/SGID files. Results saved to $output_file"
}

# Function to find and print executable SUID/SGID files
find_executable_suid_sgid_files() {
  local output_file="$OUTPUT_DIR/executable_suid_sgid_files.txt"
  echo "Finding all executable SUID/SGID files..."
  find / -type f -perm /6000 -executable -print 2>/dev/null > "$output_file"
  local count=$(wc -l < "$output_file")
  echo "Found $count executable SUID/SGID files. Results saved to $output_file"
}

# Function to find and print root-owned SUID/SGID files
find_root_owned_suid_sgid_files() {
  local output_file="$OUTPUT_DIR/root_owned_suid_sgid_files.txt"
  echo "Finding all root-owned SUID/SGID files..."
  find / -type f -perm /6000 -user root -print 2>/dev/null > "$output_file"
  local count=$(wc -l < "$output_file")
  echo "Found $count root-owned SUID/SGID files. Results saved to $output_file"
}

# Main script execution
echo "Starting SUID/SGID binary search..."

# Find all SUID/SGID files
find_suid_sgid_files

# Uncomment the following lines to enable additional searches

# Find executable SUID/SGID files
 find_executable_suid_sgid_files

# Find root-owned SUID/SGID files
 find_root_owned_suid_sgid_files

echo "SUID/SGID binary search complete."
