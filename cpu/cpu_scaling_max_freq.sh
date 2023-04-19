#!/bin/bash

case "$1" in
  low)
    freq='900000'
    ;;
  medium|med)
    freq='2100000'
    ;;
  high)
    freq='3200000'
    ;;
  *)
    freq='900000'
    ;;
esac

cores=$(cat /proc/cpuinfo | grep processor | awk '{print $3}')
for core in $cores; do
  echo ${freq} | sudo tee /sys/devices/system/cpu/cpu${core}/cpufreq/scaling_max_freq;
done
