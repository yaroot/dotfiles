###################
## JUST EXAMPLES ##
###################

# http://www.linode.com/wiki/index.php/Netfilter_IPTables_Mini_Howto
# https://wiki.archlinux.org/index.php/Simple_stateful_firewall

# reset
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -F
iptables -X


# accept established connections
# -m STATE match
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# accept lo
iptables -A INPUT -i lo -j ACCEPT

# allow ICMPv6 Neighbor Discovery
iptables -A INPUT -p 41 -j ACCEPT

# drop invalid
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# drop from 10.0.0.0/8 to 172.25.0.1
iptables -A INPUT -s 10.0.0.0/8 -d 172.25.0.1 -j DROP

# accept 10.0.0.0/8 to port 113 via tcp
iptables -A INPUT -p tcp --dport 113 -s 10.0.0.0/8 -j ACCEPT

# tcp reset connection to port 113 via tcp
iptables -A INPUT -p tcp --dport 113 -j REJECT --rejectwith tcp-reset

# DROP conn to 11080 except from lo
iptables -A INPUT --dport 11080 -i lo -j ACCEPT
iptables -A INPUT --dport 11080 -j DROP

# port redirection
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080

iptables -t nat -A PREROUTING -p tcp -d 10.0.0.5 --dport 80 -j DNAT --to-destination 10.0.0.6:80

iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.0.0.6:8080
iptables -t nat -A POSTROUTING -p tcp --dport 8080 -j MASQUERADE

