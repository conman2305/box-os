#!/bin/bash
set -eux
set -o pipefail

setcap cap_sys_admin+p $(readlink -f $(which sunshine))

mkdir -p /usr/etc/xdg/autostart
ln -s /usr/share/applications/dev.lizardbyte.app.Sunshine.desktop /usr/etc/xdg/autostart/dev.lizardbyte.app.Sunshine.desktop
