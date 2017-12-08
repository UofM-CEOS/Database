#! /bin/sh
# Author: Sebastian Luque
# Created: 2016-10-08T17:00:02+0000
# -------------------------------------------------------------------------
# Commentary:
#
# MET data download for P Tortell (see emails 2017-11-28).
# -------------------------------------------------------------------------
# Code:

ROOTDIR=/mnt/CEOS_Tim/AMD/2015/FromDB
# Core low frequency views
LFREQ1=lowfreq_1w10min_2015
LFREQ1ODIR=${ROOTDIR}/LowFreq_1w10min
# Program to split into daily files
SPLITISO_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDDHHMMSS.awk)
SPLITYMD_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDD.awk)

TMPDIR=$(mktemp -d -p /var/tmp)

mkdir -p ${LFREQ1ODIR}

# Meteorology from L1
cat <<EOF > ${TMPDIR}/l1_met_dump.sql
CREATE OR REPLACE TEMPORARY VIEW l1_met AS
SELECT time_study, longitude, latitude, atmospheric_pressure, air_temperature,
       relative_humidity, surface_temperature, wind_speed,
       round(wind_speed * (ln(10 / 0.002) / ln(16.34 / 0.002)), 2) AS wind_speed_10,
       wind_direction, true_wind_speed,
       round(true_wind_speed * (ln(10 / 0.002) / ln(16.34 / 0.002)), 2) AS true_wind_speed_10,
       true_wind_direction,
       bad_wind_direction_flag, very_bad_wind_direction_flag,
       bad_ice_flag, bad_atmospheric_pressure_flag, bad_anemometer_flag,
       bad_barometer_flag, bad_trh_sensor_flag, bad_ir_sensor_flag
FROM amundsen_flux.${LFREQ1}
WHERE time_study < '2015-10-20 18:45:00'
ORDER BY time_study;
\cd ${LFREQ1ODIR}
\copy (SELECT * FROM l1_met) TO 'meterology_true_wind_1min_10m.csv' CSV HEADER
EOF
psql -p5433 -f${TMPDIR}/l1_met_dump.sql gases


rm -rf ${TEMPDIR}
