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

iptables -F
service iptables save

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
mkdir /data
echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /data   ext2   defaults   0   0 >> /etc/fstab
mount /data

# set up the primary and secondary storage over NFS
yum install -y nfs-utils
mkdir -p /data/primary
mkdir -p /data/secondary
cat > /etc/exports <<EOT
/data  *(rw,async,no_root_squash,no_subtree_check)
EOT
exportfs -a
service rpcbind start
service nfs start
chkconfig nfs on
chkconfig rpcbind on
