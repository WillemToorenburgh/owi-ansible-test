# Monitoring Stack role

## Configuration and variables

### Vars

`monitoring_stack_grafana_users` - This var expects a list of dictionaries defining users:

```yaml
- name: <string> # Human-friendly name
  is_admin: <true|false>
  username: <string> # For logging in
  email: <string>
  password: <string> # Note: can create passwords, but cannot alter existing ones!
  state: <present|absent> # For provisioning or deprovisioning users. Once a single run has been done with `state:absent`, the user entry can be removed.
```

`monitoring_stack_grafana_dashboards_import_ids` - Expects a list of dictionaries defining dashboards to be imported from https://grafana.com/grafana/dashboards

```yaml
 - id: <int>
   revision: <int>
   folder: <int> # Optional; if undefined, defaults to the "General" folder

# Example: imports this dashboard: https://grafana.com/grafana/dashboards/1860-node-exporter-full/
- id: 1860
  revision: 37
  folder: "Node"
```

### Defaults

All the values in `defaults/main.yml` are there for convenience and generally don't need to be changed. The exception is `monitoring_stack_docker_compose_state`, which can be used to force the Docker compose project to restart, tear down, etc.

## Working with Dashboard JSON files

To add dashboard JSON files to the Grafana instance, put them in the `files/dashboards/` directory of this role. You must put them in a subdirectory, the name of which will be the folder the dashboard is organized under in Grafana.

For example, if you want your new dashboard `kafka_queue_stats.json` in the `Kafka` folder in Grafana, put it in the role folder like so: `files/dashboards/Kafka/kafka_queue_stats.json`.
