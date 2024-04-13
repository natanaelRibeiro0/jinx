#!/bin/bash
  setterm -cursor off

WIFI_NAME=$(nmcli -t -f active | awk 'FNR==1 {print $4}')

checkWifi(){
  WIFI_CONDITION=$(nmcli -t -f STATE general)
  case $WIFI_CONDITION in
    "connected")
    echo "󰤨 WIfi:        │   $WIFI_NAME"
    ;;
    "disconnected") echo "󰤭 Wifi:            No service"  
    ;;
    *) echo "Error"
    ;;
  esac
}

checkBattery(){
  BATTERY_PERCENT=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/percentage/ {print $2}' | tr -d '%')
  
  if [ $BATTERY_PERCENT -le 100 ] && [ $BATTERY_PERCENT -ge 75 ]; then
    echo "󰁹 Battery:     │   $BATTERY_PERCENT %"
  elif [ $BATTERY_PERCENT -le 75 ] && [ $BATTERY_PERCENT -ge 50 ]; then
    echo "󰁾 Battery:     │   $BATTERY_PERCENT %"
  elif [ $BATTERY_PERCENT -le 50 ] && [ $BATTERY_PERCENT -ge 25 ]; then
    echo "󰁼 Battery:     │   $BATTERY_PERCENT %"
  elif [ $BATTERY_PERCENT -le 25 ] && [ $BATTERY_PERCENT -ge 10 ]; then
    echo "󱃍 Battery:     │   $BATTERY_PERCENT %"
  else
    echo "Error: Invalid battery percentage"
  fi
}

status(){
  clear
  ACCOUNT=$(hostname)
  DATE=$(date --date='TZ="Brazil/Brasilia"' | awk '{ print $1, $2, $3 }')

  KERNEL=$(uname  -s) 
  KERNEL_VERSION=$(lsb_release -d | awk '{print $2,$3}') 
  ARCHITECTURE=$(uname -m)

  UPTIME=$(uptime -p)

  WIFI_STATUS=$(checkWifi)
  WIFI_QUALITY=$(nmcli device wifi list | awk "/$WIFI_NAME/"'{print $8}')

  BATTERY=$(checkBattery)

  CPU=$(lscpu | awk "/Nome do modelo/"'{print $4 $5 $6 $7 $8}')

echo -e "
⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠉⠉⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⡀⠀⠀⠀⠈⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢟⣯⣭⢭⣭⣽⡻⠀⠀ ╭──────󰥱────────╮
⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⣴⣾⡿⠷⠠⠀⠄⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣵⠏⠰⢧⠛⠐⠛⢰⠀⠀                 
⠀⠀⣿⣿⣿⣿⣿⣿⣿⠿⢛⣛⣛⡛⠙⠦⠤⠤⠤⠤⠤⠤⠴⠛⢉⣉⣭⣝⡻⣿⣿⡶⢰⣷⣦⠀⣠⣬⣸⠀⠀ │  User:        │   $ACCOUNT
⠀⠀⣿⣿⣿⣿⣿⣿⡁⠁⠀⠀⠉⠉⠳⢶⣶⣶⣶⣶⣶⣾⠿⠿⠉⠁⠀⠀⣉⣿⡟⠀⣼⠟⣹⣾⣿⣷⣿⠀⠀ │  Date:        │   $DATE          
⠀⠀⣿⣿⣿⣿⣿⣿⡿⠶⠶⠒⢀⠀⠲⠦⠔⣠⣶⡄⠲⠴⠖⢀⠴⣀⠀⠒⠛⣛⠁⢀⠇⢸⣿⠑⣿⣿⣿⠀⠀ │  Kernel:      │   $KERNEL
⠀⠀⣿⣿⡿⠿⣿⣭⣤⣤⡀⠀⢡⢦⣦⣀⡴⠈⠋⢰⣤⢰⣶⣾⣷⡈⠁⡄⡶⠛⠀⣾⡆⠈⡁⠀⢹⣿⣿⠀⠀ │  Distro:      │   $KERNEL_VERSION
⠀⠀⡟⣹⠟⢩⣶⣿⡿⢛⣿⣷⣄⠰⢽⣿⣧⣿⣶⣿⣼⣾⣿⣿⠥⠁⠀⠜⡻⣬⡥⢞⠛⠒⡂⠀⢸⣿⣿⠀⠀ │ 󱔼 Arch:        │   $ARCHITECTURE
⠀⠀⠃⣿⠀⠘⣿⣿⠿⠿⠋⣴⡿⠀⠟⣻⣿⣿⣿⣿⣿⡿⣿⠻⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠆⠀⣸⣿⣿⠀⠀ │  Uptime:      │   $UPTIME
⠀⠀⠀⣭⣁⢸⡄⣼⡇⣰⣗⡭⠂⠀⠈⠁⠘⠁⠹⠏⠃⠁⠙⠃⠀⠀⠀⠀⠀⠠⠄⠀⢠⡉⠀⢠⣿⣿⣿⠀⠀ │ $WIFI_STATUS     
⠀⠀⡀⠀⠉⠛⠛⠉⢛⠁⠀⠀⡃⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠠⠀⢁⠀⠀⠀⠀⣿⣿⣿⣿⠀⠀ | 󱛄 Wifi sinal:  │   $WIFI_QUALITY %
⠀⠀⣷⡀⠀⠀⠀⠀⠸⢀⡦⠀⠀⠀⠀⠀⡂⠀⠀⠀⠀⠀⠤⠀⠐⢀⠀⠀⠈⠤⢠⣥⣾⣷⣾⣿⣿⣿⣿⠀⠀ │ $BATTERY         
⠀⠀⣿⣷⣄⣀⣀⣴⠷⠛⠀⠀⠠⢀⠀⠠⠁⠀⠤⠀⠀⠀⠀⠃⠀⠀⠀⢃⠀⠀⠀⠉⠻⠿⣿⣿⣿⣿⣿⠀  │ 󰍛 CPU:         │   $CPU
⠀⠀⣿⣿⣋⣉⠀⢀⣠⣖⣶⠶⢢⡀⠀⠀⠀⠠⠖⠀⢀⠠⠉⠀⠀⠢⠄⣠⡔⢶⣶⣖⣦⣀⣤⣽⣿⣿⣿⠀⠀                 
⠀⠀⣿⣿⣿⡟⣶⣿⢋⣫⣴⣿⣿⣿⣷⣤⣤⣀⣀⣤⣬⣴⣤⣤⣼⣿⣿⣿⣿⣷⣬⣌⡋⢿⣼⢻⣿⣿⣿⠀⠀ ╰────────────────╯                          ༺ 𝓳𝓲𝓷𝔁 ༻
  "
}

while : 
do
  status
  sleep 10
done
