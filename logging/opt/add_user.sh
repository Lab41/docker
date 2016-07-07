#!/bin/bash

echo "{{_l41_username}}:{{_l41_groupname}}"
groupadd -g {{_l41_gid}} {{_l41_groupname}} 
useradd -m -s /bin/bash -u {{_l41_uid}} -g {{_l41_gid}} {{_l41_username}} && \
  usermod -aG sudo {{_l41_username}} && \
  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


