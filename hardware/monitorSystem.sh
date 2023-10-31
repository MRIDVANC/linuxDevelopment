#!/bin/bash
# Bu satır betiğin başlangıcını belirtir ve hangi kabuk (shell) dilini kullanacağınızı tanımlar. Genellikle /bin/bash kullanılır.

# Kablosuz ve kablolu ağ arayüz isimlerini belirle
wired_interface="eth0"
wireless_interface="wlan0"

# MB cinsinden ağ verilerini almak için bir fonksiyon tanımla
get_network_data() {
    local interface="$1"
    # İstenen ağ arayüzünün gelen (rx) ve giden (tx) bayt miktarlarını oku
    local rx_bytes
    rx_bytes=$(cat "/sys/class/net/$interface/statistics/rx_bytes")
    local tx_bytes
    tx_bytes=$(cat "/sys/class/net/$interface/statistics/tx_bytes")
    # Bu bayt miktarlarını MB cinsine dönüştür
    local network_sent_mb
    network_sent_mb=$(awk "BEGIN {printf \"%.2f\", $tx_bytes / 1024 / 1024} ")
    local network_recv_mb
    network_recv_mb=$(awk "BEGIN {printf \"%.2f\", $rx_bytes / 1024 / 1024}")
    # MB cinsinden gelen ve giden veriyi döndür
    echo "$network_recv_mb $network_sent_mb"
}

# Belirtilen ağ arayüzü için ağ verilerini al
get_network_data_for_interface() {
    local interface="$1"
    # Eğer belirtilen ağ arayüzü mevcutsa ağ verilerini al, yoksa bir hata mesajı gönder
    if [[ -e "/sys/class/net/$interface" ]]; then
        get_network_data "$interface"
    else
        echo "Arayüz $interface bulunamadı"
    fi
}

# CPU ve bellek verilerini al
cpu_percent=$(top -n 1 | awk '/%Cpu/{print $2}')
cpu_cores=$(nproc)
memory_total=$(free -h | awk '/Mem/{print $2}')
memory_used=$(free -h | awk '/Mem/{print $3}')

# Bilgileri ekrana yazdır
echo "====================="
echo "CPU Kullanımı: $cpu_percent%"
echo "Toplam CPU Çekirdek Sayısı: $cpu_cores"
echo "Toplam Bellek: $memory_total"
echo "Kullanılan Bellek: $memory_used"
echo "====================="

# Kablolu arayüz için ağ verilerini göster
echo "Ağ Verileri - Kablolu (Wired) Arayüz:"
# shellcheck disable=SC2207
network_data=($(get_network_data_for_interface "$wired_interface"))
echo "Toplam İndirilen: ${network_data[0]} MB"
echo "Toplam Yüklenen: ${network_data[1]} MB"

# Kablosuz arayüz için ağ verilerini göster
echo "Ağ Verileri - Kablosuz (Wireless) Arayüz:"
# shellcheck disable=SC2207
network_data=($(get_network_data_for_interface "$wireless_interface"))
echo "Toplam İndirilen: ${network_data[0]} MB"
echo "Toplam Yüklenen: ${network_data[1]} MB"
echo "====================="
