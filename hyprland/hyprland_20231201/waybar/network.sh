#!/bin/bash

##
## check if network is connected
##

ping -q -w 3 -c 1 google.com >/dev/null \
&& echo '{"text":"\udb81\udd21","class":"connected","percentage":100}' \
|| echo '{"text":"\udb82\ude19","class":"disconnected","percentage":0}'
