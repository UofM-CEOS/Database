#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2015-07-14T20:27:38+0000
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

pgloader -D /var/tmp/pgloader_statoil_2015 -S navigation_summary.log \
    -L /var/tmp/pgloader_statoil_2015/navigation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/navigation.pgload
pgloader -D /var/tmp/pgloader_statoil_2015 -S meteorology_summary.log \
    -L /var/tmp/pgloader_statoil_2015/meteorology.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/meteorology.pgload
pgloader -D /var/tmp/pgloader_statoil_2015 -S rad_summary.log \
    -L /var/tmp/pgloader_statoil_2015/radiation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/radiation.pgload
# pgloader -D /var/tmp/pgloader -S UWpCO2_summary.log \
#     -L /var/tmp/pgloader/uw_pCO2.log \
#     --log-min-messages debug --client-min-messages warning \
#     pgloader/uw_pCO2.pgload
# pgloader -D /var/tmp/pgloader -S Logs_summary.log \
#     -L /var/tmp/pgloader/logs.log \
#     --log-min-messages debug --client-min-messages warning \
#     pgloader/logs.pgload



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
