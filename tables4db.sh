#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-08-28T22:17:42+0000
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
MET=${ROOTDIR}/MET
MET_LOGGERNET=${MET}/LoggerNet
MET_DAILY=${MET}/CardConvert
MET_AAVOS=${ROOTDIR}/MET/AAVOS
UNDERWAY=${ROOTDIR}/UW_pCO2
UWTEMPERATURE=${UNDERWAY}/Tsw
TSG=${UNDERWAY}/TSG
TSG_proc=${TSG}/Processed/Latest/Data
RAD_LOGGERNET=${ROOTDIR}/RAD
RAD_DAILY=${RAD_LOGGERNET}/LoggerNet
LOGFILE1=${ROOTDIR}/Logs/met_log.csv
# LOGFILE2=${ROOTDIR}/Logs/complete_tower_log.csv
AWKPATH=/usr/local/src/awk

./nav_proc4db.awk ${NAV}/LEG_0[234]/NAV_*.int | \
    awk -F, '!x[$1]++' > ${NAV}/NAV_LEG02-04.csv
AWKPATH=${AWKPATH} ./met4db.awk ${MET_LOGGERNET}/*.dat \
       ${MET_DAILY}/TOA5*.dat | \
    awk -F, '!x[$1]++' > ${MET}/MET_CEOS.csv
AWKPATH=${AWKPATH} ./AAVOS_proc4db.awk ${MET_AAVOS}/LEG_0[234]/*.csv | \
    awk -F, '!x[$1]++' > ${MET_AAVOS}/AAVOS_LEG02-04.csv
./underway4db.awk ${UNDERWAY}/*.txt | \
    awk '!x[$0]++' > ${UNDERWAY}/UW_pCO2.csv
./underway4db_misc.awk ${UWTEMPERATURE}/* | \
    awk '!x[$0]++' > ${UNDERWAY}/UW_water_temperature.csv
./TSG4db.awk ${TSG}/LEG_0[234]/*.cnv | \
    awk 'NR == 1 || !x[$0]++' > ${TSG}/TSG.csv
./TSG_proc4db.awk ${TSG_proc}/TSG_*[0-9].int | \
    awk 'NR == 1 || !x[$0]++' > ${TSG_proc}/TSG_proc.csv
AWKPATH=${AWKPATH} ./rad4db.awk ${RAD_LOGGERNET}/*.dat \
       ${RAD_DAILY}/*.dat | \
    awk '!x[$0]++' > ${RAD_LOGGERNET}/RAD_all.csv
./observer_log4db.awk ${LOGFILE1} > $(dirname ${LOGFILE1})/metlog_4db.csv
# ./observer_log4db.awk ${LOGFILE3} > $(dirname ${LOGFILE3})/towerlog_4db.csv

# Split based on program version (only MET in this year)
./split_progversion.awk -v PROGCOL=3 ${MET}/MET_CEOS.csv



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
