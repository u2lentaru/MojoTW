#!/bin/bash

TZ=Europe/Moscow perl ./daemon/twdaemon.pl &
TZ=Europe/Moscow morbo ./script/test_work>srv.log &

wait
exit $?