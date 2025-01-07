# Installing and Running Ansible Playbooks

## Step 1: Install Ansible

To install Ansible using Homebrew, use the following command:

```bash
brew install ansible
```

## Step 2: Run an Ansible Playbook

To execute a playbook, use the following command:

```bash
ansible-playbook --inventory all_vm_ssh.yaml playbook-01.yml
```

### Explanation:
- **ansible-playbook**: This is the command-line tool for running Ansible playbooks.
- **-i all_vm_ssh.yaml**: Specifies the inventory file (`all_vm_ssh.yaml`) that contains the details of the hosts (e.g., IPs, SSH configurations) where the playbook will be executed.
- **playbook-01.yml**: The name of the playbook file that contains the tasks to be performed on the target systems.



# Running an Ansible Playbook with `ansible-runner`

This guide explains how to use `ansible-runner` to execute an Ansible playbook.

## Command Overview

```bash
ansible-runner run --inventory all_vm_ssh.yaml --playbook playbook-01.yml .
```