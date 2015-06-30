#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-09-18T03:31:40+0000
# Last-Updated: 2015-06-30T18:47:07+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# This script is for preparing and loading data onto database, using
# pgloader.
# -------------------------------------------------------------------------
# Code:

# Prepare data
./tables4db_cambridge_bay_2014.sh

# # Load tables

# With the new pgloader, we only have the options to do one loading
# specified in a single file, or all of them.  We choose to have two
# command files: one for loading meteorology_series and radiation_series.
pgloader -v -D /var/tmp/pgloader_cambridge_bay_2014 \
    -S meteorology_summary.log \
    -L /var/tmp/pgloader_cambridge_bay_2014/meteorology_2014.log \
    --log-min-messages debug --client-min-messages warning \
    cambridge_bay_MET_2014.pgload
# And then another one for loading the flux tables: wind3d_series_analog
# and open_path_series_noshroud
pgloader -v -D /var/tmp/pgloader_cambridge_bay_2014 \
    -S EC_summary.log \
    -L /var/tmp/pgloader_cambridge_bay_2014/EC_2014.log \
    --log-min-messages debug --client-min-messages warning \
    cambridge_bay_EC_2014.pgload
# Now adding snow/ice tables
pgloader -v -D /var/tmp/pgloader_cambridge_bay_2014 \
    -S snow_ice_summary.log \
    -L /var/tmp/pgloader_cambridge_bay_2014/snow_ice_2014.log \
    --log-min-messages debug --client-min-messages warning \
    cambridge_bay_Ice_2014.pgload
pgloader -v -D /var/tmp/pgloader_cambridge_bay_2014 \
    -S snow_summary.log \
    -L /var/tmp/pgloader_cambridge_bay_2014/snow_2014.log \
    --log-min-messages debug --client-min-messages warning \
    cambridge_bay_Snow_2014.pgload


#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
