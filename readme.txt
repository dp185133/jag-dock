

=== Container registry:

   https://console.cloud.google.com/artifacts/docker/ret-edge-pltf-infra/us-east1/workloads

=== To log in to cloud:

   gcloud compute ssh --zone europe-west2-c zylevel0@s1-master-1 --tunnel-through-iap --project ret-edge-dsds-cfr

=== To check helm chart status:

   k get helmrelease -n flux-system vxfuel -o yaml

=== To port forward on master machine:

   k port-forward -n vx `fuelpod` 5903:5901

=== Edge login

   https://stage2.edge-preprod.dev/login
   organization: edge-stage2-retail-xcvotg



========================================================================================

How to build yocto root:

* take .hddimg, loop mount it
* there is a rootfs.img file there on that fs, loop mount it
* simply tar -czvf yocto-root.tgz from the top of rootfs; use --exclude to trim
  clamav (200M) and gstreamer (30M).

EXAMPLE:

matt@flippy:~/pkg$ sudo mount -oloop ~/pkg/panther2-usb-v2.2.5.2.5.hddimg /mnt/root
matt@flippy:~/pkg$ ls -la /mnt/root/
total 1477972
drwxr-xr-x 3 root root       4096 Dec 31  1969 .
drwxr-xr-x 5 root root       4096 Jun  2  2022 ..
-rwxr-xr-x 1 root root    9712288 Jun 21  2023 bzImage
drwxr-xr-x 3 root root       4096 Jun 21  2023 EFI
-rwxr-xr-x 1 root root   17207601 Jun 21  2023 initrd
-r-xr-xr-x 1 root root     124964 Jun 21  2023 ldlinux.c32
-r-xr-xr-x 1 root root      68608 Jun 21  2023 ldlinux.sys
-rwxr-xr-x 1 root root     174144 Jun 21  2023 libcom32.c32
-rwxr-xr-x 1 root root      22836 Jun 21  2023 libutil.c32
-rwxr-xr-x 1 root root 1456686080 Jun 21  2023 rootfs.img
-rwxr-xr-x 1 root root         26 Jun 21  2023 startup.nsh
-rwxr-xr-x 1 root root   29377536 Jun 21  2023 swupdate-image-panther2.ext4
-rwxr-xr-x 1 root root        756 Jun 21  2023 syslinux.cfg
-rwxr-xr-x 1 root root      27052 Jun 21  2023 vesamenu.c32
matt@flippy:~/pkg$
matt@flippy:~/pkg$ sudo mount -oloop,ro /mnt/root/rootfs.img /mnt/p2root
matt@flippy:~/pkg$ ls -la /mnt/p2root/
total 92
drwxr-xr-x 19 root root  4096 Jun 21  2023 .
drwxr-xr-x  6 root root  4096 Feb  8 09:23 ..
-rw-r--r--  1 root root    25 Jun 21  2023 .autorelabel
drwxr-xr-x  2 root root  4096 Jun 21  2023 bin
drwxr-xr-x  3 root root  4096 Jun 21  2023 boot
drwxr-xr-x  2 root root  4096 Jun 21  2023 dev
drwxr-xr-x 68 root root  4096 Jun 21  2023 etc
drwxr-xr-x  3 root root  4096 Jun 21  2023 home
drwxr-xr-x  7 root root  4096 Jun 21  2023 lib
drwxr-xr-x  6 root root  4096 Jun 21  2023 lib64
drwx------  2 root root 16384 Jun 21  2023 lost+found
drwxr-xr-x  2 root root  4096 Jun 21  2023 media
drwxr-xr-x  3 root root  4096 Jun 21  2023 mnt
dr-xr-xr-x  2 root root  4096 Jun 21  2023 proc
drwxr-xr-x  2 root root  4096 Jun 21  2023 run
drwxr-xr-x  2 root root  4096 Jun 21  2023 sbin
dr-xr-xr-x  2 root root  4096 Jun 21  2023 sys
drwxrwxrwt  2 root root  4096 Jun 21  2023 tmp
drwxr-xr-x 11 root root  4096 Jun 21  2023 usr
drwxr-xr-x 11 root root  4096 Jun 21  2023 var


matt@flippy:~/pkg$ cd /mnt/p2root
matt@flippy:~/pkg$ sudo tar -czvf ~/git/jag-dock/yocto/yocto-root.tgz --exclude=var/lib/clamav --exclude=usr/lib64/gstreamer-1.0 --exclude=lib/modules --exclude=usr/include *


VNC password: vncpass


