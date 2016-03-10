#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-08-28T22:17:42+0000
# Last-Updated: 2016-03-10T18:35:01+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# Prepare data for loading onto database.
#
# MET (foredeck_met_2015):
#
# There were 3 versions of the program (1.0, 1.1, 1.2), but we failed to
# update the corresponding variable at the second deployment, so the data
# only show the first and third version values 1.0 and 1.2.  We will ignore
# this problem during loading and fix this in PostgreSQL.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=~/Data/ArcticNet/2015
NAV=${ROOTDIR}/NAV/ULaval_Processed_v1
MET_CEOS=${ROOTDIR}/MET/LoggerNet
MET_AAVOS=${ROOTDIR}/MET/AAVOS
UNDERWAY=${ROOTDIR}/UW_pCO2
UWTEMPERATURE=${UNDERWAY}/Tsw
TSG=${UNDERWAY}/TSG
RAD=${ROOTDIR}/RAD
LOGFILE1=${ROOTDIR}/Logs/closed_path_log.csv
LOGFILE2=${ROOTDIR}/Logs/met_log.csv
LOGFILE3=${ROOTDIR}/Logs/complete_tower_log.csv
AWKPATH=/usr/local/src/awk

./nav_proc4db.awk ${NAV}/LEG_0[234]/NAV_*.int | \
    awk -F, '!x[$1]++' > ${NAV}/NAV_LEG02-04.csv
AWKPATH=${AWKPATH} ./met4db.awk ${MET_CEOS}/*.dat | \
    awk -F, '!x[$1]++' > ${MET_CEOS}/MET_all.csv
AWKPATH=${AWKPATH} ./AAVOS_proc4db.awk ${MET_AAVOS}/LEG_0[234]/*.csv | \
    awk -F, '!x[$1]++' > ${MET_AAVOS}/AAVOS_LEG02-04.csv
./underway4db.awk ${UNDERWAY}/*.txt | \
    awk '!x[$0]++' > ${UNDERWAY}/UW_pCO2.csv
./underway4db_misc.awk ${UWTEMPERATURE}/* | \
    awk '!x[$0]++' > ${UNDERWAY}/UW_water_temperature.csv
./TSG4db.awk ${TSG}/LEG_0[234]/*.cnv | \
    awk 'NR == 1 || !x[$0]++' > ${TSG}/TSG.csv
AWKPATH=${AWKPATH} ./rad4db.awk ${RAD}/*.dat | \
    awk '!x[$0]++' > ${RAD}/RAD_all.csv
./observer_log_4db.awk ${LOGFILE2} > $(dirname ${LOGFILE2})/metlog_4db.csv
./observer_log_4db.awk ${LOGFILE3} > $(dirname ${LOGFILE3})/towerlog_4db.csv

# Split based on program version (only MET in this year)
./split_progversion.awk -v PROGCOL=3 ${MET_CEOS}/MET_all.csv



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
