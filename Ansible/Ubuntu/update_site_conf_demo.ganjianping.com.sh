#!/bin/bash

# Quick script to update demo.ganjianping.com Nginx configuration
# Usage: ./update_site_config.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INVENTORY="$SCRIPT_DIR/inventory/hosts"

echo "=========================================="
echo "Updating Nginx Site Configuration"
echo "=========================================="
echo ""

ansible-playbook -i "$INVENTORY" "$SCRIPT_DIR/playbook/nginx/update_site_conf_demo.ganjianping.com.yml"

echo ""
echo "=========================================="
echo "Configuration Update Complete!"
echo "=========================================="
