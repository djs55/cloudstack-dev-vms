This VM contains a mysql database server and NFS exports for primary
and secondary storage.

Start the VM by:
```
vagrant up
```

The VM has 2 NICs: one using NAT for internet access and the other using
an internal shared network for cloudstack management and storage traffic.
