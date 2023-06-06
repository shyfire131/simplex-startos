#!/bin/sh

set -e 

compat duplicity restore /mnt/backup/etc /etc/opt/simplex
compat duplicity restore /mnt/backup/log /var/opt/simplex