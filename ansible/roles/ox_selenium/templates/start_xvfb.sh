#!/bin/bash

sudo -u vagrant xvfb-run --server-args="-screen 0, 1024x768x24" /opt/selenium/start_selenium.sh
