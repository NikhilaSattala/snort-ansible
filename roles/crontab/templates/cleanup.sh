#!/bin/bash -x
###############################################################################
# Description: Script cleanups older event logs.                              #
#              Will be executed by a Cronjob daily.                           #
#                                                                             #
#                                                                             #
###############################################################################

function start_services() {
  service snort start
  [[ $? -ne 0 ]] && abort "[ERROR] Snort failed to start !!!"
  service barnyard2 start
  [[ $? -ne 0 ]] && abort "[ERROR] Barnyard2 failed to start !!!"
}

function stop_services() {
  service snort stop
  [[ $? -ne 0 ]] && abort "[ERROR] Snort failed to stop !!!"
  service barnyard2 stop
  [[ $? -ne 0 ]] && abort "[ERROR] Barnyard2 failed to stop !!!"
}

function cleanup() {
  echo '' > /var/log/snort/alert
  rm -f /var/log/snort/archived_logs/* 
}

### MAIN ###
stop_services
cleanup
start_services
exit 0
