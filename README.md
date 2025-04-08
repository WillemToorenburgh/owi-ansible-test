# owi-ansible-test
Technical assessment for OWI - Ansible

## Objective

Run Grafana and Prometheus using Docker on Ubuntu Server 24.04.1 LTS.

## Requirements

* [x] Single playbook
* [x] No user input after playbook invocation
* [x] Grafana dashboard showing metrics for OS and Docker daemon
  * [x] Dashboards configured by Ansible
* [x] Documentation for playbook/roles, especially around working with the repo and variables
* [x] Inventory group named `monitoring_servers`
* [x] Single Linux user per purpose
* [x] Treat this repo's secrets as confidential
* [x] Justify use of 3rd party/community resources like Galaxy roles and collections or Grafana dashboards

## Setup

1. Install Galaxy dependencies - `ansible-galaxy -r requirements.yml`
1. Set up Vault:
    * Copy `.ansiblevault-example` to `.ansiblevault`
    * Replace the example password in `.ansiblevault` with the real password, which I will provide you.
    * Make the file executable: `chmod +x ./.ansiblevault`
1. Create an SSH key pair in the `ssh/` directory: `ssh-keygen -f ssh/ansible_provision`, or bring your own! The repo expects the key to be named `ansible_provision.pem`. Because the server has to be initially set up with an SSH public key, the `ansible_provision.pub` isn't used in this codebase.
    > [!NOTE] Change the `ansible_ssh_private_key_file` variable in `group_vars/linux_hosts/vars.yml` to whatever you like if you don't want to use `ansible_provision.pem`.
1. Modify `inventory.yml` to point to your desired host(s)

## Configuration

### Group vars

#### Linux hosts

Contains connection configuration for Ansible to members of the group, and account details for the `offworld-admin` user. Be sure to drop in the public key text of your choice into the `human_ssh_public_key` variable!

#### Monitoring servers

This is all configurations specific to the monitoring stack, including user accounts and dashboards. Try adding a new Grafana user, or another dashboard from [the Grafana website!](https://grafana.com/grafana/dashboards)

### Roles

Each role's required variables are all defined in their Readme files. See [`linux_common`](roles/linux_common/README.md) and [`monitoring_stack`](roles/monitoring_stack/README.md).

## Tags

Tags have been applied to roles and tasks to allow for easily running subsets of tasks. Use them by adding the `--tags "<your tags here>` argument to `ansible-playbook`.

Tags:

* `users` - All steps relating to user management. Useful when changing credentials or adding/removing users.
* `dashboards` - All steps that manage Grafana dashboards. Use when you're wanting to quickly update or modify them.
* `configure` - All steps that configure systems and services. Helpful when modifying many configurations and variables at once.
* `configure-(containers|prometheus|grafana)` - All steps that relate to configuring the named system. Helpful when you're making changes to a single service.
* `prometheus` - All tasks that have anything to do with Prometheus.
* `grafana` - All tasks that have anything to do with Grafana.

Additionally, each role has been tagged with its own name, in case you want to run just a single role.

* `linux_common` - Tasks for all managed Linux machines.
* `docker` - Tasks for configuring Docker itself. You should include this tag if you're adding a user to the `docker` group using the `docker_users` variable.
* `node_exporter` - Tasks for configuring the `node_exporter` program which gathers system metrics for use in Prometheus.
* `monitoring_stack` - Tasks for setting up the entire monitoring stack.

## External resources used and their justifications

### Ansible Galaxy

* Role - [`geerlingguy.docker`](https://github.com/geerlingguy/ansible-role-docker)
  > The excellent Jeff Geerlings is an Ansible community hero, and I trust his efforts. No need to reinvent this particular wheel. Offers excellent configurability.
* Collection - [`prometheus.prometheus`](https://github.com/prometheus-community/ansible) (specifically for the [`node_exporter` role](https://github.com/prometheus-community/ansible/tree/main/roles/node_exporter))
  > This repeatedly came up while I was researching Prometheus and Ansible. As it's blessed by both the Ansible and Prometheus communities, I decided to trust it. I'm unfamiliar with Prometheus, and writing this installation manually would likely cause a significant delay. Also offers excellent configurability.


### Grafana dashboards

* https://grafana.com/grafana/dashboards/1860-node-exporter-full/
  > Chosen because it's brilliantly made and well documented when viewed inside Grafana. As I'm not familiar with Grafana, I turned that into an opportunity to instead implement something someone like me would appreciate: the ability to import dashboards from the Grafana site via the role.
* https://grafana.com/grafana/dashboards/21040-docker-daemons/
  > Chosen as it's the only one I could find that visualizes Docker daemon stats. It's also simple enough that I could apply a little bugfix to the source, where the `Engine cpus` readout wasn't correctly following the selected datasource (line 171: `"uid": "${DS_PROMETHEUS}` => `"uid": "$datasource"`).

## Future improvements

These are things I would look into doing, if I were to continue working on it after being hired at OWI.

* In a production environment, new users of this repo shouldn't generate fresh SSH key pairs. An already deployed SSH key for `ansible_provision` should be kept in a secrets manager and placed in the repo (or another suitable location) when setting up.
* Set up a reverse proxy (I favour Nginx) and TLS certificate.
* Dynamic inventory system using a script for a more scalable inventory setup
* Script for encrypting and decrypting vault files using a secrets management service (Bitwarden, Azure Key Vault, AWS Secrets Manager, Hashicorp Vault, etc)
* Update Grafana dashboards imported by file when the file changes
* Grafana communication with Prometheus
  * Considering both services will only be communicating with each other, perhaps they could be put on an internal-only Docker network
  * Alternatively, if there will be a need for external connections, consider adding authentication to the Prometheus endpoint and including those credentials in the Grafana datasource
* Add support for loading Grafana dashboards from more sources, like Git repos.
* _Aspirational_: I wasn't terribly impressed by the Prometheus metrics that the Docker daemon exposes. Could investigate either augmenting `node_exporter` or hand-rolling a supplemental metric exporter that exposes things like container names, compose project names, volumes and the space they consume, etc.

## Notes from Willem

This was built on my home workstation running NixOS, which makes the dependency management of the repo a little non-standard. If you're evaluating this on a Windows machine, using Nix on WSL may be the easiest method to replicate my working setup. If there's time after I complete this evaluation task, I'll try to add some Windows-friendly repo setup steps.

---

This was a novel experience! I've only ever worked in already established Ansible repos. Setting up a new one from scratch is interesting! It highlighed some gaps in my knowledge that I'm glad to fill in.

---

It seems that Ubuntu Server LTS 24.04.2 was released since the assessments' requirements were written. Seeing as it's just a patch version, hopefully this is acceptable.

---

Roles and collections from Galaxy are installed in `galaxy/roles` and `galaxy/collections` respectively.

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

Decided to use bind mounts for all containers to make it easy for me to observe and debug if necessary.
