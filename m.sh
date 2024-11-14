lvm() {
    g=$(lsblk | awk '{print $6}' | grep lvm)
    if [ -z "$g" ]; then
        echo "no"
    else
        echo "yes"
    fi
}
echo $(lvm)

