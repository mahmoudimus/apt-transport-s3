chef-apt_transport_s3 Cookbook
===================

This cookbook provides recipes to help with configuring Amazon's S3 to host an `apt` repository alongside an eco-system of tools that can upload, package, and configure all packages with ease.

Requirements
------------

- Requires **Chef 11.0.0**

#### Platform

- Ubuntu
- Debian

#### packages
- [apt](https://github.com/opscode-cookbooks/apt)
- [deb-s3](https://github.com/krobertson/deb-s3) - A simple Ruby gem that assists in make creating and managing APT repositories on S3
-

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### chef-apt_transport_s3::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['chef-apt_transport_s3']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### chef-apt_transport_s3::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `chef-apt_transport_s3` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[chef-apt_transport_s3]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
