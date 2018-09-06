#!/bin/sh
# sample backup script for mysql
# backup strategy: 1:00 AM every day. cron: 0 1 * * * /path/to/script

mysql_host=""
mysql_user=""
mysql_pass=""
mysql_port=""
mysql_backup_db=""
mysql_backup_dir="/data/backup/mysql"
mysql_backup_file=${mysql_backup_dir}"/"`date +"%Y-%m-%d"`".sql.gz"
mysql_dump_error=${mysql_backup_dir}"/mysqldump.error"
#if 0 means every backup will save. otherwise will save n
save_latest_n_backup=30

#check backup exist?
if [[ ! -d ${mysql_backup_dir} ]]; then
	echo "mysql backup dir is not exist"
	exit
fi

if [[ ${mysql_backup_db} == '' ]]; then
	option_database="--all-databases"
else
	option_database="--databases ${mysql_backup_db}"
fi

mysqldump -h${mysql_host} -P${mysql_port} -u${mysql_user} -p${mysql_pass} \
	--triggers \
	--routines \
	--events \
	--single-transaction \
	--log-error=${mysql_dump_error} \
	${option_database} | gzip > ${mysql_backup_file}
	

if [[ ! -f ${mysql_backup_file} ]]; then
	#backup failed
	#todo send email
	exit
fi 

if [[ ${save_latest_n_backup} -gt 0 ]]; then
	cd ${mysql_backup_dir}
	ls -t ${mysql_backup_dir} | awk -v n="${save_latest_n_backup}" 'NR > n {print}' | xargs rm -f
fi