# Nagios Plugins

## Check Ethminer
Python 3 script to make use of [Ethminer API](https://github.com/ethereum-mining/ethminer/blob/master/docs/API_DOCUMENTATION.md) currently only reporting performance data in Nagios format with [miner_getstat1](https://github.com/ethereum-mining/ethminer/blob/master/docs/API_DOCUMENTATION.md#miner_getstat1) method.

## Check Reboot
Fork from [Binfalse's](https://binfalse.de/) [Check Reboot](https://binfalse.de/software/monitoring/check_reboot/). Shell script to check if a reboot is required.
It basically just checks whether the file /var/run/reboot-required is present. Should work on all Debian-based systems.

## Check Nut
Fork from [Luca Bertoncello's](http://www.lucabert.de/programs/) [check_nut](http://www.lucabert.de/programs/download.php?id=18) Check the status of the UPS using NUT (Network UPS Tools). It can check if nut daemon runs, if the UPS is online or on battery, the charge of the battery, the temperature and the load of the UPS.

## Check MongoDB
Fork from [Mike Zupan's](https://github.com/mzupan) [nagios-plugin-mongodb](https://github.com/mzupan/nagios-plugin-mongodb). This is a simple Nagios check script to monitor your MongoDB server(s).

## Check Nvidia SMI
Fork from [Anton Zhelyazkov's](https://github.com/antonzhelyazkov) [nagios script](https://github.com/antonzhelyazkov/nagiosScripts). Check nvidia GPU utilization

## Check HTTP
[Nagios plugin](https://www.nagios.org/downloads/nagios-plugins/) from version 2.3.3

## Check SSH
[Nagios plugin](https://www.nagios.org/downloads/nagios-plugins/) from version 2.3.3

## Check APT
[Nagios plugin](https://www.nagios.org/downloads/nagios-plugins/) from version 2.3.3
