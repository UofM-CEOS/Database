#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2015-07-01T13:21:38+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# This script is for preparing and loading data onto database, using
# pgloader.
# -------------------------------------------------------------------------
# Code:

# Prepare data
./tables4db.sh

Load tables

pgloader -D /var/tmp/pgloader -S navigation_summary.log \
    -L /var/tmp/pgloader/navigation.log \
    --log-min-messages debug --client-min-messages warning \
    navigation.pgload
pgloader -D /var/tmp/pgloader -S meteorology_summary.log \
    -L /var/tmp/pgloader/meteorology.log \
    --log-min-messages debug --client-min-messages warning \
    meteorology.pgload
pgloader -D /var/tmp/pgloader -S flux_avg_summary.log \
    -L /var/tmp/pgloader/flux_avg.log \
    --log-min-messages debug --client-min-messages warning \
    flux_avg.pgload
pgloader -D /var/tmp/pgloader -S flux_summary.log \
    -L /var/tmp/pgloader/flux.log \
    --log-min-messages debug --client-min-messages warning \
    flux.pgload
pgloader -D /var/tmp/pgloader -S rad_summary.log \
    -L /var/tmp/pgloader/radiation.log \
    --log-min-messages debug --client-min-messages warning \
    radiation.pgload
pgloader -D /var/tmp/pgloader -S UWpCO2_summary.log \
    -L /var/tmp/pgloader/uw_pCO2.log \
    --log-min-messages debug --client-min-messages warning \
    uw_pCO2.pgload
pgloader -D /var/tmp/pgloader -S Logs_summary.log \
    -L /var/tmp/pgloader/logs.log \
    --log-min-messages debug --client-min-messages warning \
    logs.pgload



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
