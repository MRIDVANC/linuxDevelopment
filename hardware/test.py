import psutil
import time

def get_system_usage():
    cpu_percent = psutil.cpu_percent(interval=1)  # CPU kullanım yüzdesi
    memory = psutil.virtual_memory()  # Bellek kullanımı
    network = psutil.net_io_counters()  # Ağ kullanımı

    return cpu_percent, memory, network

while True:
    cpu_percent, memory, network = get_system_usage()

    print(f"CPU Kullanımı: {cpu_percent}%")
    print(f"Toplam Bellek: {memory.total / (1024 ** 3):.2f} GB")
    print(f"Kullanılan Bellek: {memory.used / (1024 ** 3):.2f} GB")
    print(f"Ağ Gönderilen: {network.bytes_sent / (1024 ** 2):.2f} MB")
    print(f"Ağ Alınan: {network.bytes_recv / (1024 ** 2):.2f} MB")
    print("=" * 40)

    time.sleep(1)
