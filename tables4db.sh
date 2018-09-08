#! /bin/sh
# Author: Sebastian Luque
# Created: 2014-08-28T22:17:42+0000
# -------------------------------------------------------------------------
# Commentary:
#
# Prepare data for loading onto database.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=~/Data/ArcticNet/2018
NAV=${ROOTDIR}/NAV
# NAV_POSMV=${NAV}/POSMV
# NAV_CNAV=${NAV}/CNAV
NAV_BEST=${NAV}/Best
MET_CEOS=${ROOTDIR}/MET/CEOS
MET_AVOS=${ROOTDIR}/MET/AVOS
UNDERWAY=${ROOTDIR}/UW_pCO2
TSG=${UNDERWAY}/AMD_TSG
RAD=${ROOTDIR}/RAD
FLUX=${ROOTDIR}/EC
# FLUXDIAG=${FLUX}/DIAG
# LOGFILE1=${ROOTDIR}/Logs/met_log.csv
# LOGFILE2=${ROOTDIR}/Logs/closed_path_log.csv
# LOGFILE3=${ROOTDIR}/Logs/complete_tower_log.csv
AWKPATH=/usr/local/src/awk
TEMPDIR=$(mktemp -d -p /var/local/tmp)

# Convert from DOS EOL
fromdos ${NAV_BEST}/*/* \
	${MET_CEOS}/*/2018-*/AMD_MET_2018*.dat \
	${RAD}/*/2018-*/*.dat ${UNDERWAY}/*dat.txt \
	${TSG}/LEG_*/TSG_rawdata* ${FLUX}/*/2018-*/*.dat

# NAV
# # POSMV data
# AWKPATH=${AWKPATH} ./nmea2csv.awk ${NAV_POSMV}/LEG_0[1234]/*.log | \
#     awk -F, '!x[$1]++' > ${NAV_POSMV}/POSMV_all.csv
# # CNAV data
# AWKPATH=${AWKPATH} ./nmea2csv.awk ${NAV_CNAV}/LEG_0[1234]/*.log | \
#     awk -F, '!x[$1]++' > ${NAV_CNAV}/CNAV_all.csv
# Best
./nav_proc4db.awk -v skip=23 ${NAV_BEST}/LEG_0[1234]/*.int | \
    awk -F, '!x[$1]++' > ${NAV_BEST}/navproc_all.csv

# MET
AWKPATH=${AWKPATH} ./met4db.awk ${MET_CEOS}/*/2018-*/AMD_MET_2018*.dat | \
    awk -F, '!x[$1]++' > ${MET_CEOS}/MET_all.csv
# # AAVOS
# AWKPATH=${AWKPATH} ./AAVOS_rte4db.awk ${MET_AVOS}/LEG_*/*.log | \
#     awk -F, '!x[$1]++' > ${MET_AVOS}/AVOS_LEG01-04.csv

# Underway
./underway4db.awk ${UNDERWAY}/*dat.txt | \
    awk '!x[$0]++' > ${UNDERWAY}/UWpCO2_2018.csv
./TSG4db.awk ${TSG}/LEG_*/*.cnv | \
    awk 'NR == 1 || !x[$0]++' > ${TSG}/TSG.csv
# # Temporary for loading leg 4
# ./TSG4db.awk ${TSG}/LEG_04/*.cnv | \
#     awk 'NR == 1 || !x[$0]++' > ${TSG}/TSG_LEG_04.csv

# RAD
AWKPATH=${AWKPATH} ./rad4db.awk ${RAD}/*/2018-*/AMD_RAD_2018-*.dat | \
    awk '!x[$0]++' > ${RAD}/RAD_all.csv

# Flux

# A version number string variable was not included in the program, so fix
# that to simplify life later...
cat <<EOF > ${TEMPDIR}/fix_progversion.awk
FNR == 1 {
    progstr=\$6
    version=substr(progstr, length(progstr) - 7, 3)
    sub("_", ".", version)
    print
    next
}

FNR == 2 {
    \$3=sprintf("\"ProgVersion\",%s", \$3)
    print
    next
}

FNR < 5 {
    \$3=sprintf("\"\",%s", \$3)
    print
    next
 }

{
    \$3=sprintf("\"%s\",%s", version, \$3)
    print
}
EOF

for f in ${FLUX}/*/2018-*/AMD_EC*.dat; do
    fnew=$(echo ${f%*.dat}_fixed.dat | awk '{gsub(/ /, "_"); print}')
    awk -F, -v OFS="," -f ${TEMPDIR}/fix_progversion.awk "$f" > $fnew
done

# Combine all files of the same version; place result in TEMPDIR, to allow
# for duplicate removal later
cat <<EOF > ${TEMPDIR}/merge_flux_parse_toa5.awk
FNR == 1 {
    progstr=\$6
    version=substr(progstr, length(progstr) - 7, 3)
    sub("_", ".", version)
    # Keep track of versions seen
    versions[version]++
    # File name for output file for current version
    fname=sprintf("${TEMPDIR}/EC_%s_%s.csv", freq, version)
    next
}

FNR < 4 && versions[version] == 1 { print > fname }

FNR > 4 { print > fname }
EOF
awk -F, -f${TEMPDIR}/merge_flux_parse_toa5.awk -v freq=10Hz \
    ${FLUX}/*/2018-*/AMD_EC_10Hz*fixed.dat
awk -F, -f${TEMPDIR}/merge_flux_parse_toa5.awk -v freq=5min \
    ${FLUX}/*/2018-*/AMD_EC_5min*fixed.dat

# Split based on flux subgroup; we ignore version 1.0 which did not include
# the final setup with Gill sonic anemometer.  Remove duplicates too
# (timestamp-based), assuming we have comma-delimited input, and timestamp
# is on first field.
for f in ${TEMPDIR}/EC_10Hz_*.csv; do
    f_nodups=${f%*.csv}_nodups.csv
    awk -F, 'NR == 1 || !x[$1]++' $f > $f_nodups
    fmot=${f%*.csv}_motion.csv
    motflds='1,2,3,36,37,38,39,40,41'
    cut -d, -f"${motflds}" "$f_nodups" > $fmot
    fwnd=${f%*.csv}_wind3d.csv
    wndflds='1,2,3,11,12,13,14,15,16,17,18,19'
    cut -d, -f"${wndflds}" "$f_nodups" > $fwnd
    opath=${f%*.csv}_opath.csv
    opathflds='1,2,3,20,21,22,23,24,25'
    cut -d, -f"${opathflds}" "$f_nodups" > $opath
    li7200=${f%*.csv}_li-7200.csv
    li7200flds='1,2,3,26,27,28,29,30,31,32,33,34,35'
    cut -d, -f"${li7200flds}" "$f_nodups" > $li7200
    lgr=${f%*.csv}_lgr.csv
    lgrflds='1,2,3,42,43,44'
    cut -d, -f"${lgrflds}" "$f_nodups" > $lgr
    # Move everything to FLUX directory
    mv $fmot $fwnd $opath $li7200 $lgr $f_nodups ${FLUX}
done
# Do only motion for 5-min to identify tower down periods
for f in ${TEMPDIR}/EC_5min_*.csv; do
    f_nodups=${f%*.csv}_nodups.csv
    awk -F, 'NR == 1 || !x[$1]++' $f > $f_nodups
    fmot=${f%*.csv}_motion.csv
    motflds='1,2,3,36,37,38,39,40,41'
    cut -d, -f"${motflds}" "$f_nodups" > $fmot
    mv $fmot $f_nodups ${FLUX}
done


# # Logs
# ./observer_log4db.awk ${LOGFILE1} > $(dirname ${LOGFILE1})/metlog_4db.csv
# # ./observer_log4db.awk ${LOGFILE2} > $(dirname ${LOGFILE2})/metlog_4db.csv
# # ./observer_log4db.awk ${LOGFILE3} > $(dirname ${LOGFILE3})/towerlog_4db.csv


# Clean up
rm -rf ${TEMPDIR}


#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
