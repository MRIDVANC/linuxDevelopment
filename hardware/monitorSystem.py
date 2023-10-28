import psutil
import time


def get_system_usage():
    cpu_kullanim = psutil.cpu_percent()  # CPU kullanım yüzdesi
    memory_kullanim = psutil.virtual_memory()  # Bellek kullanımı
    network_kullanim = psutil.net_io_counters()  # Ağ kullanımı

    return cpu_kullanim, memory_kullanim, network_kullanim


while True:
    start_time = time.time()  # Başlangıç zamanını kaydediyoruz

    try:
        user_input = input("Programı durdurmak için 'Q' veya 'q' tuşuna basın, devam etmek için Enter tuşuna basın: ")
        if user_input.lower() == 'q':
            break
    except KeyboardInterrupt:
        pass  # KeyboardInterrupt (CTRL+C) durdurma tuşu algılandığında herhangi bir işlem yapma

    cpu_percent, memory, network = get_system_usage()

    print("=" * 40)
    print(f"CPU Kullanımı: {cpu_percent}%")
    print(f"Toplam Bellek: {memory.total / (1024 ** 3):.2f} GB")
    print(f"Kullanılan Bellek: {memory.used / (1024 ** 3):.2f} GB")
    print(f"Ağ Gönderilen: {network.bytes_sent / (1024 ** 2):.2f} MB")
    print(f"Ağ Alınan: {network.bytes_recv / (1024 ** 2):.2f} MB")
    print("=" * 40)

    elapsed_time = time.time() - start_time
    time_to_sleep = 1 - elapsed_time  # 10 saniye beklemesi gereken süreyi hesaplıyoruz

    if time_to_sleep > 0:
        time.sleep(time_to_sleep)
