Create a ceph cluster within a vagrant file (and try to do the same on aws.).

On AWS, ceph cluster with 4 osds and 3 mon split in two failures group.

Before execute vagrant up, you need to modify the disks path for OSD node to match your structure.

At the moment, it's not possible to launch all with vagrant up.
To start ceph-osd node, you can do :

```
for i in 1 2 3; do vagrant up ceph-osd-$i;done;
```
