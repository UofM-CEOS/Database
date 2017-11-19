#! /bin/sh
# Author: Sebastian Luque
# Created: 2016-10-08T17:00:02+0000
# -------------------------------------------------------------------------
# Commentary:
#
# Dump low frequency core views and tables to file(s) for miscellaneous
# purposes.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=/mnt/CEOS_Tim/AMD/2014/FromDB
# Core low frequency views
NAV=navigation_1min_2014
NAVODIR=${ROOTDIR}/Navigation_1min
MET=meteorology_ceos_1min_2014
METODIR=${ROOTDIR}/Meteorology_CEOS_1min
RAD=radiation_1min_2014
RADODIR=${ROOTDIR}/RAD_1min
UWPCO2=underway_1s_2014
UWPCO2ODIR=${ROOTDIR}/UWpCO2_1s
# Program to split into daily files
SPLITISO_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDDHHMMSS.awk)
SPLITYMD_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDD.awk)

TMPDIR=$(mktemp -d -p /var/tmp)


# Navigation
cat <<EOF > ${TMPDIR}/nav_dump.sql
CREATE OR REPLACE TEMPORARY VIEW navigation_1min AS
SELECT time_study_1min, longitude_avg, longitude_sd, latitude_avg, latitude_sd,
       speed_over_ground_avg, speed_over_ground_sd, course_over_ground_avg,
       course_over_ground_sd, heading_avg, heading_sd, pitch_avg, roll_avg,
       heave_avg
FROM amundsen_flux.${NAV};
\cd ${NAVODIR}
\copy (SELECT * FROM navigation_1min) TO 'navigation_1min.csv' CSV HEADER
EOF
psql -p5433 -f${TMPDIR}/nav_dump.sql gases

# Meteorology
cat <<EOF > ${TMPDIR}/met_dump.sql
CREATE OR REPLACE TEMPORARY VIEW meteorology_1min AS
SELECT time_study, atmospheric_pressure, air_temperature, relative_humidity,
       surface_temperature, wind_speed, wind_speed_sd, wind_direction,
       wind_direction_sd, bad_barometer_flag, bad_trh_sensor_flag,
       bad_ir_sensor_flag, bad_anemometer_flag, tower_down_flag
FROM amundsen_flux.${MET};
\cd ${METODIR}
\copy (SELECT * FROM meteorology_1min) TO 'meterology_1min.csv' CSV HEADER
EOF
psql -p5433 -f${TMPDIR}/met_dump.sql gases

# Radiation
cat <<EOF > ${TMPDIR}/rad_dump.sql
CREATE OR REPLACE TEMPORARY VIEW radiation_1min AS
SELECT time_study, "PAR", "PAR_sd", "K_down", "K_down_sd", temperature_thermopile,
       temperature_thermopile_sd, temperature_case, temperature_case_sd,
       temperature_dome, temperature_dome_sd, "LW_down", "LW_down_sd"
FROM amundsen_flux.${RAD};
\cd ${RADODIR}
\copy (SELECT * FROM radiation_1min) TO 'radiation_1min.csv' CSV HEADER
EOF
psql -p5433 -f${TMPDIR}/rad_dump.sql gases

# Underway
cat <<EOF > ${TMPDIR}/uwpCO2_dump.sql
CREATE OR REPLACE TEMPORARY VIEW underway_1s AS
SELECT time_study, time_1min, equ_temperature, "uw_CO2_fraction",
       "uw_H2O_fraction", uw_temperature_analyzer, uw_pressure_analyzer,
       equ_pressure, "H2O_flow", air_flow_analyzer, condensation_equ,
       ctd_pressure, ctd_temperature, ctd_conductivity, "ctd_O2_saturation",
       "ctd_O2_concentration", temperature_external,
       bad_ctd_flag, "bad_CO2_flag", "bad_H2O_flag", "bad_H2O_flow_flag",
       bad_pressure_analyzer_flag, bad_temperature_analyzer_flag,
       bad_equ_temperature_flag, bad_temperature_external_flag
FROM amundsen_flux.${UWPCO2};
\cd ${UWPCO2ODIR}
\copy (SELECT * FROM underway_1s) TO 'underway_1s.csv' CSV HEADER
EOF
psql -p5433 -f${TMPDIR}/uwpCO2_dump.sql gases

rm -rf ${TEMPDIR}
