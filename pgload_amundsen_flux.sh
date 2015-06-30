#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2015-06-30T18:46:58+0000
#           By: Sebastian P. Luque
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
    amundsen_Navigation_2010.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S meteorology_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/meteorology_2010.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_MET_2010.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S flux_avg_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/flux_avg_2010.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_FluxAvg_2010.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S flux_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/flux_2010.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_Flux_2010.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S rad_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/rad_2010.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_RAD_2010.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S UWpCO2_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/UWpCO2_2010.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_UWpCO2_2010.pgload
pgloader -D /var/tmp/pgloader_amundsen_2010 \
    -S Logs_summary.log \
    -L /var/tmp/pgloader_amundsen_2010/Logs_2010.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_Logs_2010.pgload



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
