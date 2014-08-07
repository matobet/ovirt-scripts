#!/usr/bin/bash

make clean
make install-dev DEV_BUILD_GWT_DRAFT=1 DEV_EXTRA_BUILD_FLAGS_GWT_DEFAULTS=" -Dgwt.cssResourceStyle=pretty"
