#!/bin/bash

# Script to add Demo.ganjianping.com Nginx configuration
# Usage: ./add_demo.ganjianping.com_nginx.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INVENTORY="$SCRIPT_DIR/inventory/hosts"

echo "=========================================="
echo "Add Demo.ganjianping.com Nginx Configuration Script"
echo "=========================================="
echo ""

# Step 1: Create SSL certificate
echo "[1/2] Creating self-signed SSL certificate..."
ansible-playbook -i "$INVENTORY" "$SCRIPT_DIR/playbook/nginx/create_ssl_certificate_demo.ganjianping.com.yml"
echo "✓ SSL certificate created"
echo ""

# Step 2: Deploy site configuration
echo "[2/2] Deploying site configuration..."
ansible-playbook -i "$INVENTORY" "$SCRIPT_DIR/playbook/nginx/deploy_site_conf_demo.ganjianping.com.yml"
echo "✓ Site configuration deployed"
echo ""

echo "=========================================="
echo "Deployment Complete!"
echo "=========================================="
echo ""
echo "Your site is now accessible at:"
echo "  HTTP:  http://demo.ganjianping.com"
echo "  HTTPS: https://demo.ganjianping.com"
echo ""
echo "Note: Self-signed certificate will show a browser warning."
echo "      Add a security exception to proceed."
echo ""
echo "To check Nginx status:"
echo "  ansible -i $INVENTORY all -m shell -a 'systemctl status nginx' -b"
echo ""
