#!/bin/sh
set -e

# capture original idle time value
ORIG=$(defaults -currentHost read com.apple.screensaver idleTime)

# make sure original idle time value is restored on exit 
trap "defaults -currentHost write com.apple.screensaver idleTime $ORIG" EXIT

# disable screensaver
defaults -currentHost write com.apple.screensaver idleTime 0

# run scraping with disabled display sleep
caffeinate -d gradle scrape
