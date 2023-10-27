#!/bin/bash

# Determine the network interface names
wired_interface="eth0"
wireless_interface="wlan0"

# Function to get network data in MB
get_network_data() {
    local interface="$1"
    local rx_bytes
    rx_bytes=$(ifconfig "$interface" | grep "RX bytes" | awk '{print $6}')
    local tx_bytes
    tx_bytes=$(ifconfig "$interface" | grep "TX bytes" | awk '{print $6}')
    local network_sent_mb
    network_sent_mb=$(bc <<< "scale=2; $rx_bytes / 1024 / 1024")
    local network_recv_mb
    network_recv_mb=$(bc <<< "scale=2; $tx_bytes / 1024 / 1024")
    echo "$network_sent_mb $network_recv_mb"
}

# Check if the wired interface exists, and if it does, use it for network info
if [[ -e "/sys/class/net/$wired_interface" ]]; then
    network_data=($(get_network_data "$wired_interface"))
else
    # If wired interface doesn't exist, use the wireless interface
    network_data=($(get_network_data "$wireless_interface"))
fi

# Get CPU and memory data
cpu_percent=$(top -n 1 | awk '/%Cpu/{print $2}')
memory_total=$(free -h | awk '/Mem/{print $2}')
memory_used=$(free -h | awk '/Mem/{print $3}')

# Display the information
echo "====================="
echo "CPU Kullanımı: $cpu_percent%"
echo "Toplam Bellek: $memory_total"
echo "Kullanılan Bellek: $memory_used"
echo "Ağ Gönderilen: ${network_data[0]} MB"
echo "Ağ Alınan: ${network_data[1]} MB"
echo "====================="

# shellcheck disable=SC2162
read -t 1 -p "Programı durdurmak için 'Q' veya 'q' tuşuna basın, devam etmek için Enter tuşuna basın: " input
if [[ $input == [qQ] ]]; then
    # shellcheck disable=SC2105
    break
fi
