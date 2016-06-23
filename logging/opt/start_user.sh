#!/bin/bash

echo "---- Setup ----"
mkdir -p /opt/nopleats/bin 
cp /opt/nopleats/print_assignments.py /opt/nopleats/bin/print_assignments.py

echo "---- Socat ----"

# This means docker socket must be mounted into container
# Does it also mean we need --net=host?
# get a copy of the docker information through the docker port
sudo socat -d -d TCP-LISTEN:41000,fork UNIX:/var/run/docker.sock >/dev/null 2>&1  &

echo "---- Get self ----"
# take a short nap so the socket is available for use.
# make the docker datastructure into environment variables.
sleep 1 
curl http://localhost:41000/containers/json > /tmp/self
for i in `(/opt/nopleats/bin/print_assignments.py /tmp/self)`; do export $i; done

echo "---- Env ----"
# echo check the sorted environent
/usr/bin/env | /usr/bin/sort

echo "---- Adding user ----"
# add the external user
/usr/bin/mo /opt/nopleats/add_user.sh > /opt/nopleats/bin/add_user.sh; chmod +x /opt/nopleats/bin/add_user.sh
/opt/nopleats/bin/add_user.sh
cat /opt/nopleats/bin/add_user.sh

echo "---- Starting filebeat ----"
/usr/bin/mo /opt/nopleats/filebeat_basic.yaml  > /etc/filebeat/filebeat.yml
mkdir /var/log/self
chmod 755 /var/log/self
service filebeat start
cp /tmp/self /var/log/self


echo "---- Syslog ----"
#start the syslog if it is defined
if [ "${!_l41_rsyslog_host-x}" = "x" -a "${_l41_rsyslog_host-y}" = "y" ]; then
		echo "Rsyslog not used"
else
		echo "---- Writing out rsyslog conf ----"
		/usr/bin/mo /opt/nopleats/setup_rsyslog.conf > /etc/rsyslog.d/10-lab41.conf

echo "---- Start syslog ----"
service rsyslog start
logger `/bin/cat /tmp/self`
fi

echo "---- Making app output dir ----"
# make the output directory if it is defined
if [ "${!_l41_make_dir-x}" = "x" -a "${_l41_make_dir-y}" = "y" ]; then
	echo "no directory to make"	
else
    echo Creating ${_l41_make_dir}
		mkdir -p ${_l41_make_dir}
		chmod 777 ${_l41_make_dir}
fi

cd /opt/super
for i in `(ls | sort -n )`; do . ./$i ; done


cd /opt/user
chmod 755 ./*
for i in `(ls | sort -n )`; do sudo -E -u ${_l41_username} bash -c "cd /opt/user/ ; ./$i" ; done

echo "---- Final User ----"
su -l ${_l41_username}
