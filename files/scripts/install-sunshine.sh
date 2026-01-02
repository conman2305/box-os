#!/bin/bash
set -eux
set -o pipefail

setcap cap_sys_admin+p $(readlink -f $(which sunshine))
