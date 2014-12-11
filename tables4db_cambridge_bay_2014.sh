#! /bin/sh
# $Id$
# Author: Sebastian Luque
# Created: 2014-09-17T21:40:18+0000
# Last-Updated: 2014-12-10T23:59:17+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# Prepare data for loading onto database.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=~/Data/Cambridge_Bay/2014
MET=${ROOTDIR}/MET
EC=${ROOTDIR}/EC
ICE=${ROOTDIR}/IceTemp

./met4db_cambridge_bay_2014.awk ${MET}/*.dat > ${MET}/MET_RAD_all.csv
./ec4db_cambridge_bay_2014.awk ${EC}/*.dat
./snowice4db.awk ${ICE}/*.dat > ${ICE}/IceTemp_all.csv

# Split based on program version
./split_on_progversion.awk -v PROGCOL=3 ${MET}/MET_RAD_all.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/open_path.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/wind.csv
./split_on_progversion.awk -v PROGCOL=3 ${ICE}/IceTemp_all.csv



#_* emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
# 
# tables4db_cambridge_bay_2014.sh ends here
