sudo iptables -A INPUT -p tcp -s @your_ip_server_prometheus@ --dport 9090 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9090 -j DROP
sudo iptables -A INPUT -p tcp -s @your_ip_server_prometheus@ --dport 9100 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9100 -j DROP
sudo iptables -A INPUT -p tcp -s @your_ip_server_prometheus@ --dport 9176 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9176 -j DROP
sudo iptables -A INPUT -p tcp -s @your_ip_server_prometheus@ --dport 9093 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 9093 -j DROP

if [ $(lsb_release -d | grep -ioP 'ubuntu|mint' | wc -l) -ge 1 ]
then
	sudo iptables-save > /etc/iptables/rules.v4
else
	sudo iptables-save > /etc/sysconfig/iptables
fi