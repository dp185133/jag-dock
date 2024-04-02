#!/bin/sh

# does not need to run as root, should sudo as needed

. /etc/profile # need to get JAGLESSJAG/PANTHERLINUXDEV settings

if ! echo $PATH | grep sbin > /dev/null; then
    export PATH=$PATH:/sbin:/usr/sbin:/usr/local/bin
fi


# hack for kubernetes.  Relying on environment variables
# is not the greatest way because it varies by user; e.g.,
# when we are trying to configure the system and attempt to
# do something as root - voila, the KUBERNETES_* environment
# variables disappear! and suddently we're not configuring
# for the container anymore.  So I'm just going to friggin
# create the dockerenv file
if [ ! -e /.dockerenv ]; then
    sudo touch /.k8senv
fi    


# This is used for docker container, because we can't run everything at build time;
# We have to have, e.g., the .Xauthority and /tmp/.X11-unix in place to access the
# host x-windows environment.  So this has to be run after the build is done but
# using the 'run' command.
MANIFESTFILE=/opt/pcr/install/panther2-jagless-linux-config/data/sdks.json

#sudo touch /var/log/pcrfuel-config-check.log
#sudo chown pcrfuel:pcrfuel /var/log/pcrfuel-config-check.log
#mkdir -p /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant/FastPoint/Log; touch /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant/FastPoint/Log/bundle-config-check.log

mkdir -p ~/.vnc
sudo chown pcrfuel /opt/pcr/data/vnc-passwd
cp /opt/pcr/data/vnc-passwd ~/.vnc/passwd
chmod go-rw ~/.vnc/passwd

export DISPLAY=:1

USER=pcrfuel tightvncserver

ln -s /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant /home/pcrfuel/Radiant

sudo ln -s ~/Radiant/FastPoint /fp

ln -s ~/Radiant/FastPoint/Data /fp/data
ln -s ~/Radiant/FastPoint/Bin  /fp/bin
ln -s ~/Radiant/FastPoint/Log  /fp/log

chmod 666 /fp/log/bundle-config-check.log
touch /fp/log/bundle-config-check-docker-run.log
chmod 666 /fp/log/bundle-config-check-docker-run.log

# For mfc140.dll and msvcp140.dll, placed by Dockerfile
sudo mv /opt/pkg/*.dll /fp/bin/

echo `date +%c` --- Startup from docker-configure-run.sh --- > /fp/log/bundle-config-check-docker-run.log


cd /opt/pcr/install/panther2-jagless-linux-config

# Invoke labushka to install $HOME/.Xsession file. This file will
# ensure configuration is done from within an X session, which is
# necessary to allow configuration that utilizes the Wine environment.

# labushka all manifest=$MANIFESTFILE 2>&1 >> /fp/log/bundle-config-check-docker-run.log

# /opt/pcr/bin/device-info& -- this gets started by somebody else??

# exec sh after starting container processes; this keeps screen session active
#screen -e^w^w sudo su -c vxfuel-container-start root
# exec sudo vxfuel-container-start
# /opt/cxoffice/bin/wine

cd /
tar -zxf /opt/pcr/pkg/crossover-panther2*.tgz

mkdir -p /opt/pcr/fifo
mkfifo /opt/pcr/fifo/com1
mkfifo /opt/pcr/fifo/com2
mkfifo /opt/pcr/fifo/com3
mkfifo /opt/pcr/fifo/com4

cd /opt/pcr/fifo

function sp_listen() { # port, file
    while true; do
        echo "NC listening on port $1 for $2"
        nc.traditional -l -p $1 < $2 > $2
    done
}

sp_listen 5000 com1&
sp_listen 5001 com2&
sp_listen 5002 com3&
sp_listen 5003 com4&

cd /opt/config

. ./data/pcrfuel-config
. ./bin/support.sh
install_current_bablua
install_current_labushka

labushka add-ports-registry


cp /opt/pcr/data/SimpumpsJaglessJag.xml /fp/data/

cd /fp/bin
unzip /opt/pkg/SimPumps_*.zip

/opt/cxoffice/bin/wine msiexec /qn /i SimPumps.msi "INSTALLDIR=C:/Program Files/Radiant/FastPoint/Bin" "USE_JAGLESSJAG=NO"

cp /opt/pcr/data/SimpumpsJaglessJag.xml /fp/data
lua /opt/pcr/bin/update-simpumps-config.lua /fp/data/SimpumpsJaglessJag.xml

/opt/cxoffice/bin/wine ./SimPumps.exe&

# leave this guy going basically forever
tail -f /dev/null
