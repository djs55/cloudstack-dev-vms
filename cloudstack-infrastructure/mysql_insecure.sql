use mysql;
grant all on *.* to 'root'@'%';
update user set grant_priv='Y';
flush privileges;
