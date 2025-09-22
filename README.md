# luci-app-modempower
Simple LuCI interface to switch send echo to proper gpio to switch off/on (reboot) USB power. Support Huasifei WH3000 Pro and Cudy TR3000 with modified .DTS

It simply sends for Cudy TR3000
```bash
echo 0 > /sys/class/gpio/modem_power/value
sleep 5
echo 1 > /sys/class/gpio/modem_power/value
```

For Huasifei WH3000 Pro
```bash
echo 1 > /sys/class/gpio/modem_power/value
sleep 5
echo 0 > /sys/class/gpio/modem_power/value
```