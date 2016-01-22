#!/bin/bash

CONFIG="./mybb_config"
ORIG="./mybb"
WWWROOT="/var/www/html"

# Clean-up and copy files.
cp -r "$ORIG"/* "$WWWROOT"/

sed -e "s/__MYBB_DOMAINURL__/${__MYBB_DOMAINURL__}/g" "${CONFIG}/settings.php" > "${WWWROOT}/inc/settings.php" 

sed -e "s/__MYBB_DATABASE_HOST__/${__MYBB_DATABASE_HOST__}/g" \
    -e "s/__MYBB_DATABASE_USER__/${__MYBB_DATABASE_USER__}/g" \
    -e "s/__MYBB_DATABASE_PASSWORD__/${__MYBB_DATABASE_PASSWORD__}/g" \
    "${CONFIG}/config.php" > "${WWWROOT}/inc/config.php"

# Initialize database.
sed -e "s/__MYBB_DOMAINURL__/${__MYBB_DOMAINURL__}/g" \
    "${CONFIG}/MyBB_InitDB.sql" | mysql \
    --user="$__MYBB_DATABASE_USER__" \
    --password="$__MYBB_DATABASE_PASSWORD__" \
    --host="$__MYBB_DATABASE_HOST__" \
    --database="mybb" || echo "WE ASSUME DATA ALREADY EXISTS!"

cd "$WWWROOT"
# chown www-data:www-data *
chmod 666 inc/config.php inc/settings.php
chmod 666 inc/languages/english/*.php inc/languages/english/admin/*.php

chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/
chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/ admin/backups/
