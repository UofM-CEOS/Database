#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2017-12-24T20:02:23+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary:
#
# This script is for preparing and loading data onto database, using
# pgloader.
# -------------------------------------------------------------------------
# Code:

# Prepare data
./tables4db_amundsen_flux.sh

# Load tables

pgloader -D /var/tmp/pgloader/AMD2013 \
    -S navigation_summary.log \
    -L /var/tmp/pgloader/AMD2013/navigation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/navigation.pgload
pgloader -D /var/tmp/pgloader/AMD2013 \
    -S meteorology_summary.log \
    -L /var/tmp/pgloader/AMD2013/meteorology.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/meteorology.pgload
pgloader -D /var/tmp/pgloader/AMD2013 \
    -S flux_avg_summary.log \
    -L /var/tmp/pgloader/AMD2013/flux_avg.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/flux_avg.pgload
pgloader -D /var/tmp/pgloader/AMD2013 \
    -S flux_summary.log \
    -L /var/tmp/pgloader/AMD2013/flux.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/flux.pgload
pgloader -D /var/tmp/pgloader/AMD2013 \
    -S rad_summary.log \
    -L /var/tmp/pgloader/AMD_2013/rad.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/radiation.pgload
pgloader -D /var/tmp/pgloader/AMD2013 \
    -S UWpCO2_summary.log \
    -L /var/tmp/pgloader/AMD2013/UWpCO2.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/uw_pCO2.pgload
pgloader -D /var/tmp/pgloader/AMD2013 \
    -S Logs_summary.log \
    -L /var/tmp/pgloader/AMD2013/Logs.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/logs.pgload



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
