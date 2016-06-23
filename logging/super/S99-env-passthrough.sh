#!/bin/bash

# write out values of certain env vars to /etc/environment
echo "PATH=$PATH" | tee -a /etc/environment
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH" | tee -a /etc/environment

