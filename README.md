# owi-ansible-test
Technical assessment for OWI - Ansible

## Notes from Willem

This was built on my home workstation running NixOS, which makes the dependency management of the repo a little non-standard. If you're evaluating this on a Windows machine, using Nix on WSL may be the easiest method to replicate my working setup. If there's time after I complete this evaluation task, I'll try to add some Windows-friendly repo setup steps.

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
