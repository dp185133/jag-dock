# vxfuel-init

This is a docker container to be used as an init container for initialization of prerequisites required to start a pod with vxfuel container and its sidecar containers.

Currently it runs a single script (start.sh) that creates directories on a persistent volume that fluent-bit container needs to store its own logs and state.

The  start.sh script can be used for other future initialization steps.

### Building the Image

>docker build --tag vxfuel-init:<version> .

### Release History
Latest Version: 0.1.0