#!/bin/bash

mkdir /var/log/supervisor

bash /startup.sh |& tee /var/log/startup.log
