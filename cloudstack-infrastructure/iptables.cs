# Firewall configuration written by system-config-firewall
# Manual customization of this file is not recommended.
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p udp --dport 111 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p tcp --dport 111 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p tcp --dport 2049 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p tcp --dport 32803 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p udp --dport 32769 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p tcp --dport 892 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p udp --dport 892 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p tcp --dport 875 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p udp --dport 875 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p tcp --dport 662 -j ACCEPT
-A INPUT -s 192.168.100.0/24 -m state --state NEW -p udp --dport 662 -j ACCEPT
-A INPUT -p tcp --dport 8080 -j ACCEPT
-A INPUT -p tcp --dport 3306 -j ACCEPT
-A INPUT -i eth1 -p tcp -m tcp --dport 67 -j ACCEPT
-A INPUT -i eth1 -p udp -m udp --dport 67 -j ACCEPT
-A INPUT -i eth1 -p tcp -m tcp --dport 53 -j ACCEPT
-A INPUT -i eth1 -p udp -m udp --dport 53 -j ACCEPT
-A FORWARD -i eth1 -o eth0 -j ACCEPT
-A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
-A INPUT -j ACCEPT
-A FORWARD -j ACCEPT
COMMIT
*nat
:PREROUTING ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A POSTROUTING -s 192.168.100.0/24 -j MASQUERADE
COMMIT
