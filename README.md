# Ansible Project Setup Script

This script installs **Ansible** using `apt` and creates a basic Ansible project structure with default configuration and inventory files.

## 📂 Project Structure

After running the script, you will get:

```
ansible-laptop/
├── ansible.cfg
├── group_vars/
├── host_vars/
├── inventories/
│   └── hosts.yml
├── playbooks/
├── roles/
```

- **ansible.cfg** – Default Ansible configuration  
- **inventories/hosts.yml** – Inventory file with localhost setup  
- **roles/** – Directory for Ansible roles  
- **playbooks/** – Directory for playbooks  
- **group_vars/** & **host_vars/** – Variables for groups and hosts  

---

## 🚀 Usage

1. **Run the setup script**  
   ```bash
   chmod +x setup-ansible.sh
   ./setup-ansible.sh
   ```
   *(Optional: Pass a custom directory as the first argument)*  
   ```bash
   ./setup-ansible.sh /path/to/project
   ```

2. **Test the setup**  
   Create a simple playbook in `playbooks/test.yml`:
   ```yaml
   ---
   - name: Test Ansible Setup
     hosts: localhost
     gather_facts: false
     tasks:
       - name: Print a hello message
         debug:
           msg: "Hello! Ansible is working correctly on localhost."
   ```

3. **Run the playbook**  
   ```bash
   cd ~/ansible-laptop
   ansible-playbook playbooks/test.yml
   ```

---

## 📝 Notes
- Works on **Debian/Ubuntu** systems with `apt` package manager.
- Requires `sudo` privileges to install Ansible.
- Default inventory is set to `localhost`.
