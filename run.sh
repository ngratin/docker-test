#!/bin/bash

mkdir /var/log/supervisor /var/log/apache2

bash /startup.sh |& tee /var/log/startup.log
