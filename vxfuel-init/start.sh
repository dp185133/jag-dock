#!/bin/sh

#create directories needed by fluentbit container
echo "Starting: Create fluentbit folders"
mkdir -p /persist/fluentbit/db
mkdir -p /persist/fluentbit/log
echo "Finished: Create fluentbit folders"

tail -F /dev/null
