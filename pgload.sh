#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2015-07-03T21:22:27+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# This script is for preparing and loading data onto database, using
# pgloader.
# -------------------------------------------------------------------------
# Code:

# Prepare data
./tables4db.sh

# Load tables

pgloader -D /var/tmp/pgloader_amundsen_2014 -S navigation_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/navigation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/navigation.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 -S meteorology_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/meteorology.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/meteorology.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 -S flux_avg_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/flux_avg.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/flux_avg.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 -S flux_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/flux.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/flux.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 -S rad_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/radiation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/radiation.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 -S UWpCO2_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/uw_pCO2.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/uw_pCO2.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 -S Logs_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/logs.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/logs.pgload



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
