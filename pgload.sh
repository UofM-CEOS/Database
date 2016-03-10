#! /bin/sh
# Author: Sebastian Luque
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

pgloader -D /var/tmp/pgloader_AMD_2015 -S navigation_summary.log \
    -L /var/tmp/pgloader_AMD_2015/navigation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/navigation.pgload
pgloader -D /var/tmp/pgloader_AMD_2015 -S meteorology_summary.log \
    -L /var/tmp/pgloader_AMD_2015/meteorology.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/meteorology.pgload
pgloader -D /var/tmp/pgloader_AMD_2015 -S rad_summary.log \
    -L /var/tmp/pgloader_AMD_2015/radiation.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/radiation.pgload
pgloader -D /var/tmp/pgloader_AMD_2015 -S UWpCO2_summary.log \
    -L /var/tmp/pgloader_AMD_2015/uw_pCO2.log \
    --log-min-messages debug --client-min-messages warning \
    pgloader/uw_pCO2.pgload
# pgloader -D /var/tmp/pgloader -S Logs_summary.log \
#     -L /var/tmp/pgloader/logs.log \
#     --log-min-messages debug --client-min-messages warning \
#     pgloader/logs.pgload



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
