# Linux Common

Applies some nice defaults handy for _any_ managed Linux machines, regardless of task. Ripe for expansion!

## Configuration and variables

### Defaults

`linux_common_human_user` - Username for the human account this role creates. This value must be set!

`linux_common_human_password` - Password for the human account. Defaults to an empty string, but _please don't_.

`linux_common_human_ssh_public_key` - Public SSH key to be added to the human user's known keys. Defaults to empty string.

`linux_common_human_user_extra_groups` - Any extra groups the human user should be added to. Defaults to empty list.
