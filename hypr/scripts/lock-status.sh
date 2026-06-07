#!/usr/bin/env bash

case "$1" in
  battery)
    bat="$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -n1)"

    if [ -z "$bat" ]; then
      echo "󰂑 AC"
      exit 0
    fi

    cap="$(cat "$bat/capacity" 2>/dev/null)"
    status="$(cat "$bat/status" 2>/dev/null)"

    if [ "$status" = "Charging" ]; then
      echo "󰂄 ${cap}%"
    elif [ "$cap" -le 15 ]; then
      echo "󰂎 ${cap}%"
    else
      echo "󰁹 ${cap}%"
    fi
    ;;

  uptime)
    uptime -p | sed 's/up //'
    ;;

  date)
    date "+%a, %d.%m.%Y"
    ;;

  *)
    echo ""
    ;;
esac
