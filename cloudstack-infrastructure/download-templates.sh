#!/bin/bash

# Download templates from the URLs stored in the database

# TODO: convert this into a database-update triggered action, so when we deploy the db,
# we check to see if the templates exist and download them if necessary.

XENSERVER_TEMPLATE=$(mysql -s -N -D cloud -e 'select url from vm_template where type="SYSTEM" and hypervisor_type="XenServer";')
KVM_TEMPLATE=$(mysql -s -N -D cloud -e 'select url from vm_template where type="SYSTEM" and hypervisor_type="KVM";')

/vagrant/cloud-install-sys-tmplt -m /nfs/secondary -u ${XENSERVER_TEMPLATE} -h xenserver -F -o localhost -r root -d ''
/vagrant/cloud-install-sys-tmplt -m /nfs/secondary -u ${KVM_TEMPLATE} -h kvm -F -o localhost -r root -d ''
