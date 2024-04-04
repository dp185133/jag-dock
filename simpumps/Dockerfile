# --*-dockerfile-*--
ARG BUILDOF_SIMPUMPS

FROM localhost:5001/yocto-base:latest


########################################################################################
# exposed ports
########################################################################################
# Not sure about the necessity of these; connections seem to work from our host without
# these even being present in expose statements, so... ??

# vncviewer
EXPOSE 5901


########################################################################################

COPY script/profile /etc/profile
run mkdir -p /opt/pcr/data && chown -R 701:701 /opt
COPY data/vnc-passwd /opt/pcr/data/


COPY data/SimpumpsJaglessJag.xml /opt/pcr/data/


###################################################################################################
# Temporary hack to copy in new config project changes; remove this for production which
# will get the 'latest' copy from the bundle
#######################################################
COPY config.tgz /opt/pcr/install
WORKDIR /opt/pcr/install
RUN tar -zxf config.tgz
RUN rm -f config.tgz
###################################################################################################
# WORKDIR /opt/pcr/install/panther2-jagless-linux-config
# RUN /opt/pcr/install/panther2-jagless-linux-config/configure-linux.sh

RUN mkdir -p /usr/local/bin
RUN chown pcrfuel.pcrfuel /usr/local/bin
COPY script/psnot /usr/local/bin/psnot

RUN mkdir -p /opt/pcr/bin/
COPY script/update-simpumps-config.lua /opt/pcr/bin/
COPY data/SimpumpsJaglessJag.xml /opt/pcr/data/

# this is some ad-hoc crap here.  Somehow radstart expects these directories,
# maybe because we should have run Radio install before we run
# radstart?  I don't know.
RUN mkdir -p /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant/FastPoint/Bin
RUN ln -s /persist/log /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant/FastPoint/Log
RUN ln -s /persist/data /home/pcrfuel/.wine/drive_c/Program\ Files/Radiant/FastPoint/Data
RUN chown -R pcrfuel:pcrfuel /home/pcrfuel/.wine

user pcrfuel
WORKDIR /home/pcrfuel

COPY script/.bashrc /home/pcrfuel/.bashrc

RUN ln -s /opt/pcr/install/panther2-jagless-linux-config /opt/config

RUN ln -s /opt/.Xauthority /home/pcrfuel/.Xauthority

COPY script/configure-run.sh /opt/pcr/bin

COPY ${BUILDOF_SIMPUMPS} /opt/pkg/
COPY bin/msvcp140.dll /opt/pkg/
COPY bin/mfc140.dll /opt/pkg/

# Simpumps container won't have persistent volume, but some things
# still expect to find FastPoint/Data (looks for SimpumpsJaglessJag there)
# so make placeholder directories.
RUN sudo mkdir -p /persist
RUN sudo chown pcrfuel.pcrfuel /persist
RUN mkdir -p /persist/data
RUN mkdir -p /persist/log


COPY bin/netcat-traditional_1.10-47_amd64.deb /opt/pkg/
RUN sudo dpkg -i --ignore-depends=libc6 /opt/pkg/netcat-traditional_1.10-47_amd64.deb

# remove some large unnecessary files (from Bundle in Yocto base)
RUN rm -f /opt/pcr/pkg/sitetrust*.deb*

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/screen", "-e^w^w", "-h", "9999", "/opt/pcr/bin/configure-run.sh"]

