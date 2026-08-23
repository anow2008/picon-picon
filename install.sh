#!/bin/bash

# Clean up temporary files
rm -rf /CONTROL /control /postinst /preinst /prerm /postrm /tmp/*.ipk /tmp/*.tar.gz >/dev/null 2>&1

# Check for mounted storage
echo "> Checking mounted storage, please wait..."
sleep 2

ms=""
for path in "/media/hdd" "/media/usb" "/media/mmc" "/usr/share/enigma2"; do
    if mount | grep -q "$path"; then
        echo "> Mounted storage found at: $path"
        ms="$path"
        break
    fi
done

# Fallback if no specific storage is mounted
if [ -z "$ms" ]; then
    echo "> No mounted storage found, using default /usr/share/enigma2"
    ms="/usr/share/enigma2"
fi

# Create picon directory
mkdir -p "$ms/picon"

# Download and install picons
echo ""
echo "> Downloading & installing picons, please wait..."
sleep 2

# قائمة الروابط من 1 إلى 9
archives=(
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/1.tar.gz"
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/2.tar.gz"
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/3.tar.gz"
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/4.tar.gz"
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/5.tar.gz"
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/6.tar.gz"
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/7.tar.gz"
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/8.tar.gz"
    "https://raw.githubusercontent.com/anow2008/picon-picon/main/9.tar.gz"
)

# Loop through archives
for url in "${archives[@]}"; do
    plugin=$(basename "$url" .tar.gz)
    package="$ms/picon/$plugin.tar.gz"

    wget --show-progress -qO "$package" --no-check-certificate "$url"
    tar -xzf "$package" -C "$ms/picon"
    extract=$?
    rm -f "$package" >/dev/null 2>&1

    echo ""
    if [ $extract -eq 0 ]; then
        echo "> $plugin package installed successfully"
    else
        echo "> $plugin package installation failed"
    fi
    sleep 2
done

echo "> Process finished"
