#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-08-28T22:17:42+0000
# Last-Updated: 2015-07-03T21:56:30+0000
#           By: Sebastian P. Luque
# 
# Commentary: 
#
# Prepare data for loading onto database.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=~/Data/ArcticNet/2014
POSMV=${ROOTDIR}/NAV/OMG/Renamed
SHIPNAV=${ROOTDIR}/NAV/Tower
MET=${ROOTDIR}/MET
UNDERWAY=${ROOTDIR}/UW_pCO2
UWTEMPERATURE=${UNDERWAY}/Tsw
RAD=${ROOTDIR}/RAD/STD
EC_AVG=${ROOTDIR}/LI-7500A
EC=${ROOTDIR}/EC
LOGFILE1=${ROOTDIR}/closed_path_log_2014.csv
LOGFILE2=${ROOTDIR}/met_log_2014.csv

./nmea2csv.awk ${POSMV}/*.log | \
    awk -F, '!x[$1]++' > ${POSMV}/POSMV_all.csv
./nav4db.awk ${SHIPNAV}/*.dat | \
    awk -F, '!x[$1]++' > ${SHIPNAV}/NAV_all.csv
./met4db.awk ${MET}/*.dat | \
    awk -F, '!x[$1]++' > ${MET}/MET_all.csv
./underway4db.awk ${UNDERWAY}/*dat.txt | \
    awk '!x[$0]++' > ${UNDERWAY}/AMD_2014.csv
./underway4db_misc.awk ${UWTEMPERATURE}/* | \
    awk '!x[$0]++' > ${UNDERWAY}/AMD_water_temperature_2014.csv
./rad4db.awk ${RAD}/*.dat | \
    awk '!x[$0]++' > ${RAD}/rad_all.csv
./flux_avg4db.awk ${EC_AVG}/*.dat
./flux4db.awk ${EC}/*.dat
./observer_log4db.awk ${LOGFILE1} > ${ROOTDIR}/obslog_4db.csv
./observer_log4db.awk ${LOGFILE2} > ${ROOTDIR}/metlog_4db.csv

# Split based on program version (only EC in this year)
./split_progversion.awk -v PROGCOL=3 ${EC}/motion.csv
./split_progversion.awk -v PROGCOL=3 ${EC}/open_path_LI7500A_1.csv
./split_progversion.awk -v PROGCOL=3 ${EC}/open_path_LI7500A_2.csv
./split_progversion.awk -v PROGCOL=3 ${EC}/wind1_analog.csv
./split_progversion.awk -v PROGCOL=3 ${EC}/wind1_serial.csv
./split_progversion.awk -v PROGCOL=3 ${EC}/wind2_sdm.csv



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
