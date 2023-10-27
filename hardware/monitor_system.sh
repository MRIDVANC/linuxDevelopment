#!/bin/bash

while true; do
    read -t 1 -p "Programı durdurmak için 'Q' veya 'q' tuşuna basın, devam etmek için Enter tuşuna basın: " input
    if [[ $input == [qQ] ]]; then
        break
    fi
    
    python3 test.py  # Python kodunuzun dosya adı olan "test.py" burada
done

