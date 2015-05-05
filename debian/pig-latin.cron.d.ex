#
# Regular cron jobs for the pig-latin package
#
0 4	* * *	root	[ -x /usr/bin/pig-latin_maintenance ] && /usr/bin/pig-latin_maintenance
