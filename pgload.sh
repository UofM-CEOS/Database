#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2015-07-02T19:26:23+0000
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

Load tables

pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S navigation_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/navigation_2010.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/navigation.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S meteorology_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/meteorology_2010.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/meteorology.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S flux_avg_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/flux_avg_2010.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/flux_avg.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S flux_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/flux_2010.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/flux.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S rad_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/rad_2010.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/radiation.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S UWpCO2_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/UWpCO2_2010.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/uw_pCO2.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S Logs_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/Logs_2010.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/logs.pgload



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
