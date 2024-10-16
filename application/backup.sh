#!/usr/bin/env sh

MYNAME="postgresql-backup-restore"
STATUS=0

echo "${MYNAME}: backup: Started"

echo "${MYNAME}: Backing up all databases"

start=$(date +%s)
$(PGPASSWORD="$DB_USERPASSWORD" pg_dumpall --host=$DB_HOST --port=5432 --username=$DB_USER > postgres-db.tar) || STATUS=$?
end=$(date +%s)

if [ $STATUS -ne 0 ]; then
    echo "${MYNAME}: FATAL: Backup returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "${MYNAME}: Backup completed in $(expr ${end} - ${start}) seconds, ($(stat -c %s postgres-db.tar) bytes)."
fi

date1=$(date +%Y%m%d-%H%M)

start=$(date +%s)
gzip -f postgres-db.tar || STATUS=$?
end=$(date +%s)

if [ $STATUS -ne 0 ]; then
    echo "${MYNAME}: FATAL: Compressing backup returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "${MYNAME}: Compressing backup completed in $(expr ${end} - ${start}) seconds."
fi

start=$(date +%s)
cos cp postgres-db.tar.gz $COS_BUCKET/$date1.tar.gz -i $COS_ACCESS_KEY_ID -k $COS_SECRET_ACCESS_KEY -e cos.$COS_REGION.myqcloud.com || STATUS=$?
end=$(date +%s)

if [ $STATUS -ne 0 ]; then
    echo "${MYNAME}: FATAL: Copy backup to ${COS_BUCKET} returned non-zero status ($STATUS) in $(expr ${end} - ${start}) seconds."
    exit $STATUS
else
    echo "${MYNAME}: Copy backup to ${COS_BUCKET} completed in $(expr ${end} - ${start}) seconds."
fi

echo "${MYNAME}: backup: Completed"
