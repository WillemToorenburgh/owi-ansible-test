# owi-ansible-test
Technical assessment for OWI - Ansible

## Objective

Run Grafana and Prometheus using Docker on Ubuntu Server 24.04.1 LTS.

## Requirements

* Single playbook
* No user input after playbook invocation
* Grafana dashboard showing metrics for OS and Docker daemon
  * Dashboard is configured by Ansible
* Documentation for playbook/roles, especially around working with the repo and variables
* Inventory group named `monitoring_servers`
* Single linux user per purpose

## Future work

* A dynamic inventory system using an `inventory.py` script, for a scalable inventory
* A script for encrypting and decrypting vault files using a secrets management service (Bitwarden, Azure Key Vault, AWS Secrets Manager, Hashicorp Vault, etc)

## Notes from Willem

This was built on my home workstation running NixOS, which makes the dependency management of the repo a little non-standard. If you're evaluating this on a Windows machine, using Nix on WSL may be the easiest method to replicate my working setup. If there's time after I complete this evaluation task, I'll try to add some Windows-friendly repo setup steps.

---

This was a novel experience! I've only ever worked in already established Ansible repos. Setting up a new one from scratch is interesting! It highlighed some gaps in my knowledge that I'm glad to fill in.

---

It seems that Ubuntu Server LTS 24.04.2 was released since the assessments' requirements were written. Seeing as it's just a patch version, hopefully this is acceptable.

---

Roles and collections from Galaxy are installed in `galaxy/roles` and `galaxy/collections` respectively. Install requirements using `ansible-galaxy install -r requirements.yml`

Things used from Galaxy:

* Role - `geerlingguy.docker`: The excellent Jeff Geerlings is an Ansible community hero, and I trust his efforts. No need to reinvent this particular wheel.
* Collection - `prometheus.prometheus` (specifically for the `node_exporter` role): This repeatedly came up while I was researching Prometheus and Ansible. As it's blessed by both the Ansible and Prometheus communities, I decided to trust it. I'm unfamiliar with Prometheus, and writing this installation manually would likely cause a significant delay.

---

To set up Vault:

* Copy `.ansiblevault-example` to `.ansiblevault`
* Replace the example password in `.ansiblevault` with the real password
* Make the file executable: `chmod +x ./.ansiblevault`

---

Ran a VM on my home Proxmox machine for the target server. Installation steps:

* Select `Ubuntu Server (minimized)`
* Enabled third-party drivers
* Disabled LVM for storage for simplicity
* Created `ansible_provision` user
* Enabled OpenSSH server
* Imported SSH public key generated for this task using Github
* Did not install any server snaps
* Installed Proxmox guest agent (`qemu-guest-agent`), enabled and started systemd service
* Install completed, rebooted, shutdown after boot
* Took Proxmox snapshot at this point, for easy resets

---

For the Prometheus requirement, it was unclear to me whether it should be running in Docker or on the host. I'm erring on the side of Docker for this implementation.

---
