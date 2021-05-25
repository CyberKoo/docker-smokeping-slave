#!/usr/bin/bash

echo -- Environment --
env
echo -----------------
mkdir -p /slave
echo $SLAVE_SECRET> /slave/slave_secret
chmod o-rwx /slave/slave_secret
echo -- Slave Secret --
cat /slave/slave_secret
echo ------------------
echo --- Starting ---
echo exec /usr/bin/smokeping --master-url=$MASTER_URL --cache-dir=/tmp --shared-secret=/slave/slave_secret --nodaemon
sed -i 's/my .use_debuglog;/my \$use_debuglog=1;/g' /usr/lib/Smokeping.pm
# Add log message to show data sent to server
grep 'Sending to server:'  /usr/lib/Smokeping/Slave.pm || sed -i '75iSmokeping::do_debuglog("Sending to server:\\n$data_dump");' /usr/lib/Smokeping/Slave.pm

exec /usr/bin/smokeping --master-url=$MASTER_URL --cache-dir=/tmp --shared-secret=/slave/slave_secret --nodaemon

