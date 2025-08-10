#!/usr/bin/env bash
# setup-ansible.sh
# Installs Ansible using apt and scaffolds an Ansible project with the
# specified layout and config files.

set -euo pipefail
IFS=$'\n\t'

# Target directory for the project (default: $HOME/ansible-laptop)
PROJECT_DIR="${1:-$HOME/ansible-laptop}"

# Determine apt command
if command -v apt-get >/dev/null 2>&1; then
  APT="apt-get"
elif command -v apt >/dev/null 2>&1; then
  APT="apt"
else
  echo "Error: apt/apt-get not found. Use on Debian/Ubuntu systems." >&2
  exit 1
fi

# Determine privilege escalation
SUDO=""
if [ "${EUID}" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo -H"
  else
    echo "Error: run as root or install sudo to proceed." >&2
    exit 1
  fi
fi

echo "Installing Ansible via apt..."
export DEBIAN_FRONTEND=noninteractive
$SUDO "$APT" update
if ! command -v ansible >/dev/null 2>&1; then
  $SUDO "$APT" install -y ansible
else
  echo "Ansible already installed; ensuring latest repo version is present."
  $SUDO "$APT" install -y ansible
fi

echo "Creating project at: ${PROJECT_DIR}"
mkdir -p \
  "${PROJECT_DIR}/roles" \
  "${PROJECT_DIR}/host_vars" \
  "${PROJECT_DIR}/group_vars" \
  "${PROJECT_DIR}/inventories" \
  "${PROJECT_DIR}/playbooks"

# ansible.cfg
cat >"${PROJECT_DIR}/ansible.cfg" <<'EOF'
[defaults]
inventory = inventories/hosts.yml
host_key_checking = False
stdout_callback = default
callback_result_format = yaml
interpreter_python = auto_silent
deprecation_warnings = False

[inventory]
enable_plugins = yaml, ini, auto
EOF

# inventories/hosts.yml
cat >"${PROJECT_DIR}/inventories/hosts.yml" <<'EOF'
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: "{{ ansible_playbook_python }}"
EOF

# Set friendly permissions similar to the example listing
chmod 775 \
  "${PROJECT_DIR}" \
  "${PROJECT_DIR}/roles" \
  "${PROJECT_DIR}/host_vars" \
  "${PROJECT_DIR}/group_vars" \
  "${PROJECT_DIR}/inventories" \
  "${PROJECT_DIR}/playbooks" || true

chmod 664 \
  "${PROJECT_DIR}/ansible.cfg" \
  "${PROJECT_DIR}/inventories/hosts.yml" || true

echo "Done."
echo "Project layout:"
ls -la "${PROJECT_DIR}"
