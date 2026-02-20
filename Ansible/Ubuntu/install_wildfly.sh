#!/bin/bash
# Install WildFly 39 Application Server on Ubuntu servers

cd "$(dirname "$0")" || exit 1

ansible-playbook -i inventory/hosts playbook/apache/install_wildfly.yml "$@"
