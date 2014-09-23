#! /bin/sh
# $Id$
# tables4db_cambridge_bay_2014.sh --- prepare tables for database
# Author: Sebastian Luque
# Created: 2014-09-17T21:40:18+0000
# Last-Updated: 2014-09-23T21:43:57+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# Prepare data for loading onto database.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=~/Data/Cambridge_Bay/2014
MET=${ROOTDIR}/MET
EC=${ROOTDIR}/EC

./met4db_cambridge_bay_2014.awk ${MET}/*.dat > ${MET}/MET_RAD_all.csv
./ec4db_cambridge_bay_2014.awk ${EC}/*.dat

# Split based on program version
./split_on_progversion.awk -v PROGCOL=3 ${MET}/MET_RAD_all.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/open_path.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/wind.csv



#_* emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
# 
# tables4db_cambridge_bay_2014.sh ends here
