#!/bin/bash
# total=$(free -b|grep ^Mem|awk '{print $2}');
# used=$(free -b|grep ^Mem|awk '{print $3}');
# mem=$(awk "BEGIN {printf \"%.2f\", ($used / $total) * 100}")
# echo "
# Broadcast message from root@wil (tty1) (Sun Apr 25 15:45:00 2021):
#         #Architecture: $(uname -a)
#         #CPU physical : $(lscpu | grep -c '^Core(s) per socket:')
#         #vCPU : $(lscpu | grep -c '^CPU(s):')
#         #Memory Usage: $(free -h|grep ^Mem|awk '{print $3}')/$(free -h|grep ^Mem|awk '{print $2}') ($mem%)
#         #Disk Usage: $(df -m --total|grep total | awk '{print $3}')/$(df -h --total|grep total | awk '{print $2}')b ($(df -h --total|grep total | awk '{print $5}'))
#         #CPU load: $(lscpu |grep "CPU(s) scaling MHz"| awk '{print $4}')
#         #Last boot: 2021-04-25 14:45
#         #LVM use: yes
#         #Connections TCP : 1 ESTABLISHED
#         #User log: 1
#         #Network: IP 10.0.2.15 (08:00:27:51:9b:a5)
#         #Sudo : 42 cmd
# "
# Get architecture and kernel version
architecture=$(uname -m)
kernel_version=$(uname -r)

# Get the number of physical processors
physical_processors=$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)

# Get the number of virtual processors
virtual_processors=$(grep -c "^processor" /proc/cpuinfo)

# Get total and used memory
total_memory=$(free -mt | grep ^Total | awk '{print $2}')
used_memory=$(free -mt | grep ^Total | awk '{print $3}')
mem_usage=$(awk "BEGIN {printf \"%.2f\", ($used_memory / $total_memory) * 100}")

# Get current CPU load
cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Get last reboot time
last_boot=$(uptime -s)

# Check if LVM is active
lvm_status=if [ -n "$(lsblk |awk '{print $6}' |grep lvm)" ];then echo $text; else echo "is empty"; fi

# Get active connections
active_connections=$(ss -tuln | grep -c ':4242')

# Get the number of users logged in
users_logged_in=$(who | wc -l)

# Get IPv4 and MAC address
ip_address=$(hostname -I | awk '{print $1}')
mac_address=$(cat /sys/class/net/eth0/address)

# Get sudo command count
sudo_cmd_count=$(journalctl -u sudo | wc -l)
tty= $(w|grep w |  awk '{print $2}')
echo $tty
# Display the information
echo "Broadcast message from $(whoami)@$(hostname) ($tty) ($(date)):"
echo "#Architecture: $architecture $hostname $kernel_version $architecture GNU/Linux"
echo "#CPU physical : $physical_processors"
echo "#vCPU : $virtual_processors"
echo "#Memory Usage: $used_memory/$total_memory MB ($mem_usage%)"
echo "#CPU load: $cpu_load"
echo "#Last boot: $last_boot"
echo "#LVM use: ${lvm_status}"
echo "#Connections TCP : $active_connections"
echo "#User log: $users_logged_in"
echo "#Network: IP $ip_address ($mac_address)"
echo "#Sudo : $sudo_cmd_count cmd"
