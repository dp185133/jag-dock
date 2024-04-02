This creates a simpumps box using CFR's propietary WINE build and the yocto base image.

Simpumps is installed from the .zip file output by the Jag github build.  This
file is copied to the container image and extracted to `C:\Program Files\Radiant\FastPoint\Bin' (aliased to /fp/bin).

The simpumps config file is copied from data/SimPumpsJaglessJag.xml, which Simpumps.exe
searches for by default in 'C:\Program Files\Radiant\FastPoint\Data' (aliased to
/fp/data).  The container image stores this config file in /opt/pcr/data, and
the configure-run.sh script copies it to /fp/data and sets the IP address
using `ip addr show' to find the current IP address (see script/update-simpumps-config.lua)




