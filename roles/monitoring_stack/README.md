# Monitoring Stack role

## Configuration and variables

### Defaults

`monitoring_stack_grafana_default_admin_password` - Password used for the first-time Grafana setup. This value must be set!

`monitoring_stack_grafana_users` - This var expects a list of dictionaries defining users. Defaults to empty list.

```yaml
- name: <string> # Human-friendly name
  is_admin: <true|false>
  username: <string> # For logging in
  email: <string>
  password: <string> # Note: can create passwords, but cannot alter existing ones!
  state: <present|absent> # For provisioning or deprovisioning users. Once a single run has been done with `state:absent`, the user entry can be removed.
```

`monitoring_stack_grafana_dashboards_import_ids` - Expects a list of dictionaries defining dashboards to be imported from https://grafana.com/grafana/dashboards. Defaults to empty list.

```yaml
 - id: <int>
   revision: <int>
   folder: <int> # Optional; if undefined, defaults to the "General" folder

# Example: imports this dashboard: https://grafana.com/grafana/dashboards/1860-node-exporter-full/
- id: 1860
  revision: 37
  folder: "Node"
```

### Vars

All the values in `vars/main.yml` are there for role-internal use and generally don't need to be changed.

## Working with Dashboard JSON files

To add dashboard JSON files to the Grafana instance, put them in the `files/dashboards/` directory of this role. You must put them in a subdirectory, the name of which will be the folder the dashboard is organized under in Grafana.

For example, if you want your new dashboard `kafka_queue_stats.json` in the `Kafka` folder in Grafana, put it in the role folder like so: `files/dashboards/Kafka/kafka_queue_stats.json`.
