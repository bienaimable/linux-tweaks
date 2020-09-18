#!/bin/bash
TIMESTAMP=`date +%Y%m%d%H%M%S`
FILENAME=/tmp/screenshot$TIMESTAMP.jpg
import $FILENAME
feh $FILENAME &
