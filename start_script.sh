#!/bin/bash

perl ./daemon/twdaemon.pl &
morbo ./script/test_work &

wait
exit $?