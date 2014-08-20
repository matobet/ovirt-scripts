#!/usr/bin/bash

cd ovirt-engine && make gwt-debug DEBUG_MODULE=$1
