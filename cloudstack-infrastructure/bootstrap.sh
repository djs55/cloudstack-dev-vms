yum install -y mysql-server

mv /etc/my.cnf /etc/my.cnf.orig
cat > /etc/my.cnf <<EOT
[mysqld]
innodb_rollback_on_timeout=1
innodb_lock_wait_timeout=600
max_connections=350
log-bin=mysql-bin
binlog-format = 'ROW'
bind-address = 0.0.0.0
EOT
cat /etc/my.cnf.orig | grep -v '\[mysqld\]' >> /etc/my.cnf

yum install -y dnsmasq
cp /vagrant/dnsmasq.conf /etc/
echo "Domain = cloud.priv" >> /etc/idmapd.conf
echo "192.168.100.10 srvr1.cloud.priv" >> /etc/hosts
chkconfig dnsmasq on
service dnsmasq start

cp /vagrant/iptables.cs /etc/sysconfig/iptables
service iptables restart
sysctl -w net.ipv4.ip_forward=1

chkconfig --level 345 mysqld on
service mysqld start

yum install -y expect
/vagrant/mysql_secure.sh
mysql -u root < /vagrant/mysql_insecure.sql

# set up the NFS exports for primary and secondary storage
yum install -y parted
parted /dev/sdb mklabel msdos
parted /dev/sdb mkpart primary 1 100%
mkfs.ext2 /dev/sdb1
mkdir /nfs
echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /nfs   ext2   defaults   0   0 >> /etc/fstab
mount /nfs

# set up the primary and secondary storage over NFS
yum install -y nfs-utils
mkdir -p /nfs/primary
mkdir -p /nfs/secondary
cat > /etc/exports <<EOT
/nfs  *(rw,async,no_root_squash,no_subtree_check)
EOT

exportfs -a
service rpcbind start
service nfs start
chkconfig nfs on
chkconfig rpcbind on

# enable IP forwarding
mkdir /etc/sysctl.d
cp /vagrant/enable-ipv4-forwarding.conf /etc/sysctl.d/enable-ipv4-forwarding.conf
sysctl -w net.ipv4.ip_forward=1
