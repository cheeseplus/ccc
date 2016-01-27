ccc Cookbook
==============================
Library cookbook for installing or upgrading the Chef Compliance software: https://www.chef.io/compliance/

Requirements
------------
chef-client 12.5+

e.g.
#### resources
- `compliance_server` - custom resource to install/upgrade
- `compliance_user` - custom resource to create Chef Compliance users

Actions
----------

Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### ccc::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Required</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ccc']['bacon']</tt></td>
    <td>Boolean</td>
    <td>yes</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>


Usage
-----
#### ccc::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `ccc` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[ccc]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
