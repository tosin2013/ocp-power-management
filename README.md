OpenShift Power Management Role
=========

Reboot or shutdown a Red Hat OpenShift Container Platform Cluster  
Based on: [How To: Stop and start a production OpenShift Cluster](https://servicesblog.redhat.com/2019/05/29/how-to-stop-and-start-a-production-openshift-cluster/)

Requirements
------------
* Red Hat Openshift Container Platform (OCP) 3.X
* Ansible 2.6

Role Variables
--------------
**options for power_state reboot, halt, running**  
```
power_state="reboot"
```

**remote user used to run plays**  
```
rhel_user="exampleuser"
```

**master_node used for master node endpoint**  
```
master_node="master.ocp.example.com"
```

**FQDN names used for power down and power up tasks**  
specifically used to drain and  unschedule nodes  
```
fdqn_node_names=["node4.ocp.example.com","node3.ocp.example.com","node2.ocp.example.com","node1.ocp.example.com"]
fqdn_compute_names=["node4.ocp.example.com","node3.ocp.example.com"]
```
**node names used for power up and power down nodes**
```
node_names=["node1","node2","node3","node4"]
infra_nodes=["node1","node2"]
compute_nodes=["node3","node4"]
```
**Uncomment the items below for rebooting nodes playbook takes single node.**
```
compute_node_single="node4"
fqdn_compute_node_single="node4.ocp.example.com"
```

Current Architecture
------------
This  role currently works with the following:
* one master node
* two infra nodes
* two compute nodes

This layout may be changed in the inventory.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters):
```
---
- hosts: localhost
  remote_user: root
  gather_facts: no
  roles:
    - ocp-power-management
```

Example Usage
----------------
Rebooting node option this will reboot a single node
```
ansible-playbook -i inventory ocp_power_management.yml  --extra-vars "rhel_user=tosin" --extra-vars "power_state=reboot" --extra-vars "compute_node_single=node4" --extra-vars "fqdn_compute_node_single=node4.ocp.example.com"
```

Shutting Down all nodes on OpenShift Cluster except for master
```
ansible-playbook -i inventory ocp_power_management.yml  --extra-vars "rhel_user=tosin" --extra-vars "power_state=halt"
```

Starting up all nodes on OpenShift Cluster
```
ansible-playbook -i inventory ocp_power_management.yml  --extra-vars "rhel_user=tosin" --extra-vars "power_state=running"
```

License
-------

BSD

Author Information
------------------
# Authors

* **Tosin Akinosho** - *Initial work* - [tosin2013](https://github.com/tosin2013)
