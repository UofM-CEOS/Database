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
# For special underway dump for pCO2_Sys
PCO2SYS=lowfreq_1min_2014
PCO2SYSOFILE=L1_2014
PCO2SYSODIR=${ROOTDIR}/pCO2Sys_1min
 # Program to split into daily files
SPLITISO_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDDHHMMSS.awk)
SPLITYMD_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDD.awk)

TMPDIR=$(mktemp -d -p /var/tmp)

mkdir -p ${NAVODIR} ${METODIR} ${RADODIR} ${UWPCO2ODIR} ${PCO2SYSODIR}

# Navigation
cat <<EOF > ${TMPDIR}/nav_dump.sql
CREATE OR REPLACE TEMPORARY VIEW navigation_1min AS
SELECT time_study_1min, longitude_avg, longitude_sd, latitude_avg, latitude_sd,
       speed_over_ground_avg, speed_over_ground_sd, course_over_ground_avg,
       course_over_ground_sd, heading_avg, heading_sd, pitch_avg, roll_avg,
       heave_avg
FROM amundsen_core.${NAV};
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
FROM amundsen_core.${MET};
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
FROM amundsen_core.${RAD};
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
FROM amundsen_core.${UWPCO2};
\cd ${UWPCO2ODIR}
\copy (SELECT * FROM underway_1s) TO 'underway_1s.csv' CSV HEADER
EOF
psql -p5433 -f${TMPDIR}/uwpCO2_dump.sql gases

# Special dump for the purpose of correcting for erroneous standards using
# pCO2_Sys from D Pierrot
cat <<EOF > ${TMPDIR}/lfreq1_dump.sql
CREATE OR REPLACE TEMPORARY VIEW pco2sys_1min AS
SELECT to_char(time_study, 'DD/MM/YY') AS "date",
       to_char(time_study, 'HH24:MI:SS') AS "time", longitude, latitude,
       speed_over_ground, course_over_ground, heading, pitch, roll, heave,
       atmospheric_pressure * 10 AS atmospheric_pressure, air_temperature,
       relative_humidity, surface_temperature, wind_speed, wind_direction,
       round((truewind_vector).magnitude::numeric, 2) AS true_wind_speed,
       round((truewind_vector).angle::numeric, 2) AS true_wind_direction,
       wind_speed_u, wind_speed_v, wind_speed_w,
       air_temperature_sonic, cp_analyzer_status, "cp_CO2_dry_fraction",
       "cp_H2O_dry_fraction", cp_pressure, cp_temperature, "op_CO2_density",
       "op_H2O_density", op_pressure, op_temperature, "PAR", "K_down",
       "LW_down", "UV_a", "UV_b", uw_record_type, equ_temperature, std_value,
       "uw_CO2_fraction", "uw_H2O_fraction", uw_temperature_analyzer,
       uw_pressure_analyzer, equ_pressure, "H2O_flow", air_flow_analyzer,
       equ_speed_pump, vent_flow, condensation_atm, condensation_equ,
       drip_1, drip_2, condenser_temperature, temperature_dry_box,
       ctd_pressure, ctd_temperature, ctd_conductivity, "ctd_O2_saturation",
       "ctd_O2_concentration", "uw_pH", uw_redox_potential, tsg_temperature,
       tsg_conductivity, tsg_salinity, "tsg_H2O_flow"
FROM amundsen_UWpCO2.${PCO2SYS}
WHERE uw_record_type != 'EXTERNAL_TEMPERATURE'
ORDER BY time_study;
\cd ${LFREQ1ODIR}
\copy (SELECT * FROM pco2sys_1min) TO '${PCO2SYSOFILE}.csv' CSV HEADER DELIMITER E'\t' NULL '-999'
\H
\o colnames.html
SELECT pa.attnum AS "column_position", pa.attname AS "column_name",
    col_description(pa.attrelid, pa.attnum) AS "column_description"
FROM pg_attribute pa, pg_attribute ta
WHERE pa.attrelid = 'amundsen_UWpCO2.lowfreq_1w20min_2014'::regclass AND
    ta.attrelid = 'pco2sys_1min'::regclass AND
    pa.attname = ta.attname
ORDER BY pa.attnum;
EOF
psql -p5433 -f${TMPDIR}/lfreq1_dump.sql gases


rm -rf ${TEMPDIR}
