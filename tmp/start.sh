#!/bin/sh

echo -- Set Timezone --
echo timezone: $TZ
cp /usr/share/zoneinfo/$TZ /etc/localtime
echo "$TZ" > /etc/timezone
echo now: `date`
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
# Enable debug log
sed -i 's/my .use_debuglog;/my \$use_debuglog=1;/g' /usr/share/perl5/vendor_perl/Smokeping.pm
# Add log message to show data sent to server
#grep 'Sending to server:'  /usr/share/perl5/vendor_perl/Smokeping/Slave.pm || sed -i '75iSmokeping::do_debuglog("Sending to server:\\n$data_dump");' /usr/share/perl5/vendor_perl/Smokeping/Slave.pm

exec /usr/bin/smokeping --master-url=$MASTER_URL --cache-dir=/tmp --shared-secret=/slave/slave_secret --nodaemon

