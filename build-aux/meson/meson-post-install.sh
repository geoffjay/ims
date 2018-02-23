#!/bin/bash

# XXX: Not sure if this is required
glib-compile-schemas /usr/share/glib-2.0/schemas/ &>/dev/null

systemctl enable ims
systemctl start ims
