#! /bin/sh
# Author: Sebastian Luque
# Created: 2016-10-08T17:00:02+0000
# Last-Updated: 2016-10-23T01:05:01+0000
#           By: Sebastian Luque
#
# Commentary:
#
# Dump low frequency core views and tables to file(s) for miscellaneous
# purposes.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=/mnt/CEOS_Tim/AMD/2016/FromDB
# Core low frequency views
NAV=navigation_1min_2016
NAVODIR=${ROOTDIR}/Navigation_1min
MET=meteorology_ceos_1min_2016
METODIR=${ROOTDIR}/Meteorology_CEOS_1min
RAD=radiation_1min_2016
RADODIR=${ROOTDIR}/RAD_1min
# Program to split into daily files
SPLITISO_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDDHHMMSS.awk)
SPLITYMD_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDD.awk)

TMPDIR=$(mktemp -d -p /var/tmp)

cat <<EOF > ${TMPDIR}/rad_dump.sql
CREATE OR REPLACE TEMPORARY VIEW radiation_1min AS
SELECT time_study, "PAR", "PAR_sd", "K_down", "K_down_sd", temperature_thermopile,
       temperature_thermopile_sd, temperature_case, temperature_case_sd,
       temperature_dome, temperature_dome_sd, "LW_down", "LW_down_sd"
FROM amundsen_flux.radiation_1min_2016;
\cd ${RADODIR}
\copy (SELECT * FROM radiation_1min) TO 'radiation_1min.csv' CSV HEADER
EOF
psql -p5433 -f${TMPDIR}/rad_dump.sql gases

rm -rf ${TEMPDIR}
