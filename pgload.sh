#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
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

pgloader -D /var/tmp/pgloader/AMD2017 -S navigation_summary.log \
    -L /var/tmp/pgloader/AMD2017/navigation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/navigation.pgload
pgloader -D /var/tmp/pgloader/AMD2017 -S meteorology_summary.log \
    -L /var/tmp/pgloader/AMD2017/meteorology.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/meteorology.pgload
pgloader -D /var/tmp/pgloader/AMD2017 -S rad_summary.log \
    -L /var/tmp/pgloader/AMD2017/radiation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/radiation.pgload
pgloader -D /var/tmp/pgloader/AMD2017 -S UWpCO2_summary.log \
    -L /var/tmp/pgloader/AMD2017/uw_pCO2.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/uw_pCO2.pgload
pgloader -D /var/tmp/pgloader/AMD2017 -S flux_summary.log \
    -L /var/tmp/pgloader/AMD2017/flux.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/flux.pgload



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
