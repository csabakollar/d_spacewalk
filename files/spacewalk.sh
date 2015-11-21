#!/bin/bash
spacewalk-setup --disconnected --skip-db-diskspace-check --answer-file=/opt/answers
sleep 5
spacewalk-service start
exit 0
