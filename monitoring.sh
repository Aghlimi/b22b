#!/bin/bash
architecture=$(uname -m)
kernel_version=$(uname -r)

physical_processors=$(grep "^core id" /proc/cpuinfo | sort -u | wc -l)

virtual_processors=$(grep -c "^processor" /proc/cpuinfo)
lvm() {
    g=$(lsblk | awk '{print $6}' | grep lvm)
    if [ -z "$g" ]; then
        echo "no"
    else
        echo "yes"
    fi
}
total_memory=$(free -mt | grep ^Total | awk '{print $2}')
used_memory=$(free -mt | grep ^Total | awk '{print $3}')
mem_usage=$(awk "BEGIN {printf \"%.2f\", ($used_memory / $total_memory) * 100}")

cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

last_boot=$(uptime -s)

lvm_status=$(lvm)

active_connections=$(ss -tuln | grep -c ':4242')

users_logged_in=$(who | wc -l)

ip_address=$(hostname -I | awk '{print $1}')
mac_address=$(ip a | grep -w link/ether | awk '{print $2}')

sudo_cmd_count=$(cat /var/log/sudo/sudo.log | grep -c COMMAND=)

tty= $(w|grep w |  awk '{print $2}')

echo "
Broadcast message from root@wil (tty1) (Sun Apr 25 15:45:00 2021):
        #Architecture: $architecture $hostname $kernel_version $architecture GNU/Linux
        #CPU physical : $physical_processors
        #vCPU : $virtual_processors
        #Memory Usage: $used_memory/$total_memory MB ($mem_usage%) MB ($mem_usage%)
       >>> #Disk Usage: $(df -m --total|grep total | awk '{print $3}')/$(df -h --total|grep total | awk '{print $2}')b ($(df -h --total|grep total | awk '{print $5}'))
        #CPU load:$cpu_load
        #Last boot: $last_boot
        #LVM use: $lvm_status
        #Connections TCP : $active_connections ESTABLISHED
        #User log: $users_logged_in
        #Network: IP $ip_address ($mac_address)
        #Sudo : $sudo_cmd_count cmd
"
