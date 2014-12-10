#! /bin/sh
# $Id$
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2014-11-29T22:26:09+0000
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

pgloader -D /var/tmp/pgloader_amundsen_2014 \
    -S navigation_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/navigation_2014.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_Navigation_2014.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 \
    -S meteorology_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/meteorology_2014.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_MET_2014.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 \
    -S flux_avg_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/flux_avg_2014.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_FluxAvg_2014.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 \
    -S flux_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/flux_2014.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_Flux_2014.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 \
    -S rad_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/rad_2014.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_RAD_2014.pgload
pgloader -D /var/tmp/pgloader_amundsen_2014 \
    -S UWpCO2_summary.log \
    -L /var/tmp/pgloader_amundsen_2014/UWpCO2_2014.log \
    --log-min-messages debug --client-min-messages warning \
    amundsen_UWpCO2_2014.pgload




#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
# 
# pgload_2014.sh ends here
