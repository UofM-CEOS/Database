#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-08-28T22:17:42+0000
# Last-Updated: 2017-10-06T01:20:01+0000
#           By: Sebastian P. Luque
#
# Commentary:
#
# Prepare data for loading onto database.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=~/Data/ArcticNet/2016
NAV=${ROOTDIR}/NAV
NAV_POSMV=${NAV}/POSMV
NAV_CNAV=${NAV}/CNAV
NAV_BEST=${NAV}/Best
METCO2=${ROOTDIR}/MET
MET_AAVOS=${ROOTDIR}/MET/AAVOS/Processed
UNDERWAY=${ROOTDIR}/UW_pCO2
UWTEMPERATURE=${UNDERWAY}/TSW
TSG=${UNDERWAY}/TSG
RAD=${ROOTDIR}/RAD
FLUX=${ROOTDIR}/EC
FLUXDIAG=${FLUX}/DIAG
LOGFILE1=${ROOTDIR}/Logs/met_log.csv
LOGFILE2=${ROOTDIR}/Logs/closed_path_log.csv
LOGFILE3=${ROOTDIR}/Logs/complete_tower_log.csv
AWKPATH=/usr/local/src/awk
TEMPDIR=$(mktemp -d -p /var/local/tmp)

# Convert from DOS EOL
fromdos ${NAV_POSMV}/*/* ${NAV_CNAV}/*/* ${NAV_BEST}/*/* \
	${METCO2}/Converted/*.dat ${METCO2}/*.dat ${MET_AAVOS}/LEG*/*.log \
	${RAD}/*.dat ${UNDERWAY}/*.txt ${UWTEMPERATURE}/*.dat \
	${FLUX}/Converted/*.dat ${FLUX}/*.dat

# NAV
# POSMV data
AWKPATH=${AWKPATH} ./nmea2csv.awk ${NAV_POSMV}/LEG*/*.log | \
    awk -F, '!x[$1]++' > ${NAV_POSMV}/POSMV_all.csv
# CNAV data
AWKPATH=${AWKPATH} ./nmea2csv.awk ${NAV_CNAV}/LEG*/*.log | \
    awk -F, '!x[$1]++' > ${NAV_CNAV}/CNAV_all.csv
# Best
./nav_proc4db.awk -v skip=23 ${NAV_BEST}/LEG_*/*.int | \
    awk -F, '!x[$1]++' > ${NAV_BEST}/navproc_all.csv

# MET
AWKPATH=${AWKPATH} ./met4db.awk ${METCO2}/*.dat | \
    awk -F, '!x[$1]++' > ${METCO2}/MET_all.csv
# AAVOS
AWKPATH=${AWKPATH} ./AAVOS_proc4db.awk ${MET_AAVOS}/LEG_0[234]/*.csv | \
    awk -F, '!x[$1]++' > ${MET_AAVOS}/AAVOS_LEG01-04.csv

# Underway
./underway4db.awk ${UNDERWAY}/*.txt | \
    awk '!x[$0]++' > ${UNDERWAY}/UWpCO2_2016.csv
./TSG4db.awk ${TSG}/*.cnv | \
    awk 'NR == 1 || !x[$0]++' > ${TSG}/TSG.csv
./underway_indeplogger4db.awk ${UWTEMPERATURE}/* | \
    awk '!x[$0]++' > ${UNDERWAY}/UW_H2O_temperature.csv

# RAD
AWKPATH=${AWKPATH} ./rad4db.awk ${RAD}/*.dat | \
    awk '!x[$0]++' > ${RAD}/RAD_all.csv
# Something happened between 2016-07-24 and 2016-07-30, as there seems to
# be a different program running altogether.

# Flux
# People didn't bother updating the version number string variable in the
# program, so fix that to simplify life later...
cat <<EOF > ${TEMPDIR}/fix_progversion.awk
FNR < 5 {
    if (FNR == 1) {
        progstr=\$6
        version=substr(progstr, length(progstr) - 7, 3)
        sub("_", ".", version)
    }
    print
    next
}

{
    \$3=sprintf("\"%s\"", version)
    print
}
EOF

for f in ${FLUX}/*.dat ${FLUX}/Converted/*.dat; do
    fnew=$(echo ${f%*.dat}_fixed.dat | awk '{gsub(/ /, "_"); print}')
    awk -F, -v OFS="," -f ${TEMPDIR}/fix_progversion.awk "$f" > $fnew
done

AWKPATH=${AWKPATH} ./flux4db.awk ${FLUX}/*fixed.dat \
       ${FLUX}/Converted/*fixed.dat | \
    awk -F, '!x[$1]++' > ${TEMPDIR}/flux.csv

# We need to order the output by timestamp. Maneuver for header line...
tail -n+2 ${TEMPDIR}/flux.csv | \
    sort -T${TEMPDIR} -t',' -k1,1 -o ${TEMPDIR}/flux_sorted.csv
head -n1 ${TEMPDIR}/flux.csv | \
    cat - ${TEMPDIR}/flux_sorted.csv > ${FLUX}/flux_sorted.csv
# There's some mis-timestamped data: 2008-02-13 19:35:55.7 to 2008-02-19
# 21:32:54.3.  Concomitantly, there's missing data between some time
# 2016-06-01 and 2016-06-08:
cat <<EOF > ${TEMPDIR}/subset.awk
BEGIN {
    FS=","
    beg=mktime("2016 06 01 16 47 00")
    end=mktime("2016 06 08 14 48 00")
}

FNR > 1 {
    tstr=sprintf("%s %s %s %s %s %s",
                 substr(\$1, 2, 4),
                 substr(\$1, 7, 2),
                 substr(\$1, 10, 2),
                 substr(\$1, 13, 2),
                 substr(\$1, 16, 2),
                 substr(\$1, 19, 2))
    tstamp=mktime(tstr)
    if ((tstamp > beg) && (tstamp < end)) print
}
EOF
# awk -f ${TEMPDIR}/subset.awk ${FLUX}/flux_sorted.csv
# Chatting with Tonya, the missing data were due to a power cut issue
# whereby the clock on the logger got messed up on 2016-06-01.  When power
# was restored the logger resumed logging with the wrong time stamp, until
# the problem was fixed on 2016-06-08.  This could be resolved by working
# back from the first *correct* time stamp after power was restored
# (2016-06-08 14:46:43.9).  Thus, the last mis-timestamped data could be
# made continuous with the first *correct* timestamped data.  Any missing
# data from 2016-06-01 would correspond to the power cut.
tac ${FLUX}/flux_sorted.csv | awk '$1 ~ /2008-/' | \
    ./regenerate_timestamps.py -s 2016 06 08 14 46 43 800000 -d-100000 - | \
    awk '$1 ~ /2016-/' - ${FLUX}/flux_sorted.csv | \
    sort -T${TEMPDIR} -t',' -k1,1 -o ${TEMPDIR}/flux_fixed.csv
head -n1 ${FLUX}/flux_sorted.csv | \
    cat - ${TEMPDIR}/flux_fixed.csv > ${FLUX}/flux_sorted_fixed.csv
# Check
awk -f ${TEMPDIR}/subset.awk ${FLUX}/flux_sorted_fixed.csv > ${TEMPDIR}/check_flux.csv
# There are still gaps in the data:
# 2016-07-22 03:36:07.8 - 2016-08-01 20:24:51.6
# 2016-08-02 00:00:00.0 - 2016-08-06 23:56:45.4

# Logs
./observer_log4db.awk ${LOGFILE1} > $(dirname ${LOGFILE1})/metlog_4db.csv
# ./observer_log4db.awk ${LOGFILE2} > $(dirname ${LOGFILE2})/metlog_4db.csv
# ./observer_log4db.awk ${LOGFILE3} > $(dirname ${LOGFILE3})/towerlog_4db.csv

# Split based on program version (only EC in this year)
./split_progversion.awk -v PROGCOL=2 ${FLUX}/flux_sorted_fixed.csv
# ./split_progversion.awk -v PROGCOL=2 ${FLUX_AVG}/flux_avg.csv

# Split based on flux subgroup
for f in ${FLUX}/flux_sorted_fixed_*.csv; do
    fmot=${f%*.csv}_motion.csv
    motflds='1,2,3,4,5,6,7,8'
    cut -d, -f"${motflds}" "$f" > $fmot
    fwnd_ana=${f%*.csv}_wind3d_ana.csv
    wndflds_ana='1,2,9,10,11,12'
    cut -d, -f"${wndflds_ana}" "$f" > $fwnd_ana
    fwnd_ser=${f%*.csv}_wind3d_ser.csv
    wndflds_ser='1,2,13,14,15,16,17,18'
    cut -d, -f"${wndflds_ser}" "$f" > $fwnd_ser
    opath=${f%*.csv}_opath.csv
    opathflds='1,2,19,20,21,22,23,24'
    cut -d, -f"${opathflds}" "$f" > $opath
    cpath=${f%*.csv}_cpath.csv
    cpathflds='1,2,25,26,27,28,29'
    cut -d, -f"${cpathflds}" "$f" > $cpath
done


# Clean up
rm -rf ${TEMPDIR}


#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
