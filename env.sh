#!/usr/bin/env bash
echo "===== VERILOG VERILATOR Environment Setup ====="

# Safely get the project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_ROOT
echo "Location of project: ${PROJECT_ROOT}"

# Check if Verilator is installed and get its version
VERILATOR_VERSION="$(verilator --version 2>/dev/null)"
if [ -z "$VERILATOR_VERSION" ]; then
    echo "Warning: 'verilator' command not found or failed to execute."
else
    echo "${VERILATOR_VERSION}"
    export VERILATOR_VERSION
fi