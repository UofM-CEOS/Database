#! /bin/sh
# $Id: $
# Author: Sebastian Luque
# Created: 2014-08-28T22:17:42+0000
# Last-Updated: 2014-09-23T21:51:08+0000
#           By: Sebastian P. Luque
# 
# Commentary: 
#
# Prepare data for loading onto database.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=~/Data/ArcticNet/2014
POSMV=${ROOTDIR}/NAV/OMG
SHIPNAV=${ROOTDIR}/NAV/Tower
MET=${ROOTDIR}/MET
UNDERWAY=${ROOTDIR}/UW_pCO2
RAD=${ROOTDIR}/RAD/STD
EC_AVG=${ROOTDIR}/LI-7500A
EC=${ROOTDIR}/EC

./nmea2csv.awk ${POSMV}/*.log > ${POSMV}/POSMV_all.csv
./nav4db.awk ${SHIPNAV}/*.dat > ${SHIPNAV}/NAV_all.csv
./met4db.awk ${MET}/*.dat > ${MET}/MET_all.csv
./underway4db.awk ${UNDERWAY}/*.txt > ${UNDERWAY}/AMD_2014.csv
./rad4db.awk ${RAD}/*.dat > ${RAD}/rad_all.csv
./ec_avg_4db.awk ${EC_AVG}/*.dat
./ec4db.awk ${EC}/*.dat

# Split based on program version (only EC in this year)
./split_on_progversion.awk -v PROGCOL=3 ${EC}/motion.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/open_path_LI7500A_1.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/open_path_LI7500A_2.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/wind1_analog.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/wind1_serial.csv
./split_on_progversion.awk -v PROGCOL=3 ${EC}/wind2_sdm.csv



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
# 
# tables4db_amundsen_flux.sh ends here
