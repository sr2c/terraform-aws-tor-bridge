<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.11 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.2.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.2.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 3.2.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bridgeline"></a> [bridgeline](#module\_bridgeline) | matti/resource/shell | 1.5.0 |
| <a name="module_cloudinit"></a> [cloudinit](#module\_cloudinit) | sr2c/tor/cloudinit | 0.2.4 |
| <a name="module_fingerprint_ed25519"></a> [fingerprint\_ed25519](#module\_fingerprint\_ed25519) | matti/resource/shell | 1.5.0 |
| <a name="module_fingerprint_rsa"></a> [fingerprint\_rsa](#module\_fingerprint\_rsa) | matti/resource/shell | 1.5.0 |
| <a name="module_hashed_fingerprint"></a> [hashed\_fingerprint](#module\_hashed\_fingerprint) | matti/resource/shell | 1.5.0 |
| <a name="module_instance"></a> [instance](#module\_instance) | cloudposse/ec2-instance/aws | 0.45.2 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |
| <a name="module_torrc"></a> [torrc](#module\_torrc) | sr2c/torrc/null | 0.0.4 |

## Resources

| Name | Type |
|------|------|
| [aws_key_pair.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.obfs4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.obfs4](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [null_resource.wait_for_cloud_init](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_integer.obfs_port](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [random_integer.or_port](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) | resource |
| [aws_ami.debian](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_subnet.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | ID of an alternative AMI to use for the EC2 instance. The latest Debian 11 AMI will be used if left unset. | `string` | `null` | no |
| <a name="input_ami_owner"></a> [ami\_owner](#input\_ami\_owner) | The owner ID of the AMI. The Debian organisation's ID will be used if left unset. | `string` | `null` | no |
| <a name="input_contact_info"></a> [contact\_info](#input\_contact\_info) | Contact information to be published in the bridge descriptor. | `string` | n/a | yes |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_distribution_method"></a> [distribution\_method](#input\_distribution\_method) | Bridge distribution method | `string` | `"any"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance size. | `string` | `"t3.small"` | no |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Filename of private SSH key for provisioning. | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | Filename of public SSH key for provisioning. | `string` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | Username to use for SSH access (must have password-less sudo enabled). | `string` | `"admin"` | no |

### Label Inputs

This Terraform module makes use of the [cloudposse/label/null](https://registry.terraform.io/modules/cloudposse/label/null/latest)
module to generate consistent names and tags for resources.
The label module contains many inputs that are common across all our modules that use the label module, and so
these inputs have been seperated here to make it clearer which inputs are specific to this module.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ansible_inventory"></a> [ansible\_inventory](#output\_ansible\_inventory) | An Ansible inventory line that allows login to the bridge with the correct username. |
| <a name="output_bridgeline"></a> [bridgeline](#output\_bridgeline) | The bridgeline that would allow a Tor client to use this bridge. |
| <a name="output_fingerprint_ed25519"></a> [fingerprint\_ed25519](#output\_fingerprint\_ed25519) | The Ed25519 fingerprint of this bridge. |
| <a name="output_fingerprint_rsa"></a> [fingerprint\_rsa](#output\_fingerprint\_rsa) | The hex-encoded RSA fingerprint of this bridge. |
| <a name="output_hashed_fingerprint"></a> [hashed\_fingerprint](#output\_hashed\_fingerprint) | The hex-encoded hashed fingerprint of this bridge. This is used to identify the bridge in public Tor Metrics data. |
| <a name="output_id"></a> [id](#output\_id) | An identifier for the bridge formed of the ID elements. |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The IP address of the server. This is treated as sensitive as this information may be used to censor access to the bridge. |
| <a name="output_nickname"></a> [nickname](#output\_nickname) | The nickname of the bridge published in the bridge descriptors. This is based on the ID, reformatted for the nickname restrictions. |
| <a name="output_obfs_port"></a> [obfs\_port](#output\_obfs\_port) | The TCP port number used for the obfs4 port. This is treated as sensitive as this information may be used to censor access to the bridge. |
| <a name="output_or_port"></a> [or\_port](#output\_or\_port) | The TCP port number used for the OR port. This is treated as sensitive as this information may be used to censor access to the bridge. |
| <a name="output_ssh_user"></a> [ssh\_user](#output\_ssh\_user) | The username used for SSH access. |
<!-- markdownlint-restore -->
