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

## Check PG Activity
Fork from [OPM Development Group's](https://github.com/OPMDG) [nagios script](https://github.com/OPMDG/check_pgactivity). Checks many things in PostgreSQL and provides rich perfdatas : connectivity, database size, table and index bloat, streaming replication lag, database hit-ratio, etc.
Written in Perl language, the code is very easy to extend to add new features.
check_pgactivity provides many services :

* archive_folder: check archives in given folder.
* archiver: check the archiver status and number of wal files ready to archive.
* autovacuum: check the autovacuum activity.
* backends: number of connections, compared to max_connections.
* backends_status: number of connections in relation to their status.
* backup_label_age: check age of backup_label file.
* bgwriter: check the bgwriter activity.
* btree_bloat: check B-tree index bloat.
* checksum_errors: check data checksums errors.
* commit_ratio: commit and rollback rate per second and commit ratio since last execution.
* configuration: check the most important settings.
* connection: perform a simple connection test.
* custom_query: perform the given user query.
* database_size: variation of database sizes.
* extensions_versions: check that installed extensions are up-to-date.
* hit_ratio: check hit ratio on databases.
* hot_standby_delta: check delta in bytes between a master and its hot standbys.
* invalid_indexes: check for invalid indexes.
* is_hot_standby: check if cluster is a hot standby.
* is_master: check if cluster is in production.
* is_replay_paused: check if the replication is paused.
* last_analyze: check the oldest analyze (from autovacuum or not) on the database.
* last_vacuum: check the oldest vacuum (from autovacuum or not) on the database.
* locks: check the number of locks on the hosts.
* longest_query: check the longest running query.
* max_freeze_age: check oldest database in transaction age.
* minor_version: check if the PostgreSQL minor version is the latest one.
* oldest_2pc: check the oldest two-phase commit transaction.
* oldest_idlexact: check the oldest idle transaction.
* oldest_xmin: check the xmin horizon from distinct sources of xmin retention.
* pg_dump_backup: check pg_dump backups age and retention policy.
* pga_version: check the version of this check_pgactivity script.
* pgdata_permission: check that the permission on PGDATA is 700.
* replication_slots: check delta in bytes of the replication slots.
* sequences_exhausted: check that auto-incremented colums aren't reaching their upper limit.
* settings: check if the configuration file changed.
* stat_snapshot_age: check stats collector's stats age.
* streaming_delta: check delta in bytes between a master and its standbys in streaming replication.
* table_bloat: check tables bloat.
* table_unlogged: check unlogged tables
* temp_files: check temp files generation.
* uptime: time since postmaster start or configurtion reload.
* wal_files: total number of WAL files.

Works with PostgreSQL from version 7.4 to 13. It just needs psql to connect to the database.
For PostgreSQL 10 and after, check_pgactivity supports monitoring with a non-privileged user.

## Check UPS by SNMP
Fork from [Yoann LAMY's](https://github.com/ynlamy) [nagios script](https://github.com/ynlamy/check_snmp_ups). This plugin can check the status of Uninterruptible Power Supply (UPS) using SNMP v1 queries.

## Check UPS Vertiv
This plugin can check the status of Vertiv Uninterruptible Power Supply (UPS) using SNMP queries.

## Check NCPA
Official Nagios Plugin for [NCPA](https://www.nagios.org/ncpa/) Active checks from version 1.2.4

## Check APT
[Nagios plugin](https://www.nagios.org/downloads/nagios-plugins/) from version 2.3.3
