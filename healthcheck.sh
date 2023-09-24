#!/bin/bash
if ! supervisorctl status rtpengine | grep -q 'RUNNING'; then exit 1; fi
if ! supervisorctl status kamailio | grep -q 'RUNNING'; then exit 1; fi