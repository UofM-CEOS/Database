#! /bin/sh
# Author: Sebastian Luque
# Created: 2016-10-08T17:00:02+0000
# -------------------------------------------------------------------------
# Commentary:
#
# Dump core views and tables to file(s) for flux analyses.
#
# Note that this outputs all the columns in each of the underlying views,
# and the colnames.html lists all the columns in that view, so *do not*
# modify the select list, as it will no longer correspond to what is shown
# in colnames.html.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=/mnt/CEOS_Tim/AMD/2015/FromDB
# Core low frequency views
LFREQ1=lowfreq_1w10min_2015
LFREQ1ODIR=${ROOTDIR}/LowFreq_1w10min
LFREQ2=lowfreq_1w10min_2015_flags
LFREQ2ODIR=${ROOTDIR}/LowFreq_1w10min_flags
# Program to split into daily files
SPLITISO_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDDHHMMSS.awk)
SPLITYMD_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDD.awk)

TMPDIR=$(mktemp -d -p /var/tmp)

mkdir -p ${LFREQ1ODIR} ${LFREQ2ODIR}

cat <<EOF > ${TMPDIR}/lfreq1_dump.sql
CREATE OR REPLACE TEMPORARY VIEW lowfreq_1w10min AS
SELECT time_10min, time_study, longitude, longitude_avg, latitude, latitude_avg,
       speed_over_ground, speed_over_ground_avg, speed_over_ground_sd,
       speed_over_ground_v_avg, course_over_ground, course_over_ground_avg,
       course_over_ground_sd, heading, heading_avg, heading_sd, pitch,
       pitch_avg, roll, roll_avg, heave, heave_avg, atmospheric_pressure,
       atmospheric_pressure_avg, air_temperature, air_temperature_avg,
       relative_humidity, relative_humidity_avg, surface_temperature,
       surface_temperature_avg, wind_speed, wind_speed_sd, wind_speed_avg,
       wind_direction, wind_direction_sd, wind_direction_avg, wind_direction_avg_sd,
       true_wind_speed, true_wind_speed_avg, true_wind_direction, true_wind_direction_avg,
       "PAR", "PAR_avg", "K_down", "K_down_avg", "LW_down", "LW_down_avg",
       equ_temperature, equ_temperature_avg, std_value, "uw_CO2_cellA",
       "uw_CO2_cellA_avg", "uw_CO2_cellB", "uw_CO2_cellB_avg", "uw_CO2_fraction",
       "uw_CO2_fraction_avg", "uw_H2O_cellA", "uw_H2O_cellA_avg", "uw_H2O_cellB",
       "uw_H2O_cellB_avg", "uw_H2O_fraction", "uw_H2O_fraction_avg",
       uw_temperature_analyzer, uw_temperature_analyzer_avg, uw_pressure_analyzer,
       uw_pressure_analyzer_avg, equ_pressure, equ_pressure_avg, "H2O_flow",
       "H2O_flow_avg", air_flow_analyzer, air_flow_analyzer_avg, equ_speed_pump,
       equ_speed_pump_avg, ventilation_flow, ventilation_flow_avg, condensation_atm,
       condensation_atm_avg, condensation_equ, condensation_equ_avg, drip_1, drip_2,
       condenser_temperature, condenser_temperature_avg, temperature_dry_box,
       temperature_dry_box_avg, ctd_pressure, ctd_pressure_avg, ctd_temperature,
       ctd_temperature_avg, ctd_conductivity, ctd_conductivity_avg, "ctd_O2_saturation",
       "ctd_O2_saturation_avg", "ctd_O2_concentration", "ctd_O2_concentration_avg",
       "uw_pH", "uw_pH_avg", uw_redox_potential, uw_redox_potential_avg,
       temperature_external, temperature_external_avg, tsg_temperature,
       tsg_temperature_avg, tsg_salinity, tsg_salinity_avg, tsg_conductivity,
       tsg_conductivity_avg, tsg_sound_speed, tsg_sound_speed_avg, temperature_in,
       temperature_in_avg, bad_wind_direction_flag, very_bad_wind_direction_flag,
       bad_ice_flag, bad_atmospheric_pressure_flag, bad_anemometer_flag,
       bad_barometer_flag, bad_trh_sensor_flag, bad_ir_sensor_flag,
       nbad_ctd_flag, "nbad_CO2_flag", "nbad_H2O_flag", "nbad_H2O_flow_flag",
       nbad_pressure_analyzer_flag, nbad_temperature_analyzer_flag,
       nbad_equ_temperature_flag, nbad_temperature_external_flag
FROM amundsen_flux.${LFREQ1}
ORDER BY time_10min, time_study;
\cd ${LFREQ1ODIR}
\copy (SELECT * FROM lowfreq_1w10min) TO PROGRAM 'awk -v fprefix=L1 -f ${SPLITYMD_PRG} -' CSV
\H
\o colnames.html
SELECT DISTINCT ON (cols.ordinal_position, cols.column_name)
    cols.ordinal_position,
    cols.column_name,
    col_description(cl.oid, cols.ordinal_position::INT)
FROM information_schema.columns cols
    JOIN pg_class cl ON cols.table_name = cl.relname
    JOIN pg_attribute pa ON cols.column_name = pa.attname
WHERE pa.attrelid = 'lowfreq_1w10min'::regclass AND
    cl.relname = '${LFREQ1}' AND
    cols.table_catalog = 'gases' AND
    cols.table_schema = 'amundsen_flux'
ORDER BY cols.ordinal_position, cols.column_name;
EOF
psql -p5433 -f${TMPDIR}/lfreq1_dump.sql gases

cat <<EOF > ${TMPDIR}/lfreq2_dump.sql
CREATE OR REPLACE TEMPORARY VIEW lowfreq_1w10min_flags AS
SELECT time_10min, time_study, longitude, longitude_avg, latitude, latitude_avg,
       speed_over_ground, speed_over_ground_avg, speed_over_ground_sd,
       speed_over_ground_v_avg, course_over_ground, course_over_ground_avg,
       course_over_ground_sd, heading, heading_avg, heading_sd, pitch,
       pitch_avg, roll, roll_avg, heave, heave_avg, atmospheric_pressure,
       atmospheric_pressure_avg, air_temperature, air_temperature_avg,
       relative_humidity, relative_humidity_avg, surface_temperature,
       surface_temperature_avg, wind_speed, wind_speed_sd, wind_speed_avg,
       wind_direction, wind_direction_sd, wind_direction_avg, wind_direction_avg_sd,
       true_wind_speed, true_wind_speed_avg, true_wind_direction, true_wind_direction_avg,
       "PAR", "PAR_avg", "K_down", "K_down_avg", "LW_down", "LW_down_avg",
       equ_temperature, equ_temperature_avg, std_value, "uw_CO2_cellA",
       "uw_CO2_cellA_avg", "uw_CO2_cellB", "uw_CO2_cellB_avg", "uw_CO2_fraction",
       "uw_CO2_fraction_avg", "uw_H2O_cellA", "uw_H2O_cellA_avg", "uw_H2O_cellB",
       "uw_H2O_cellB_avg", "uw_H2O_fraction", "uw_H2O_fraction_avg",
       uw_temperature_analyzer, uw_temperature_analyzer_avg, uw_pressure_analyzer,
       uw_pressure_analyzer_avg, equ_pressure, equ_pressure_avg, "H2O_flow",
       "H2O_flow_avg", air_flow_analyzer, air_flow_analyzer_avg, equ_speed_pump,
       equ_speed_pump_avg, ventilation_flow, ventilation_flow_avg, condensation_atm,
       condensation_atm_avg, condensation_equ, condensation_equ_avg, drip_1, drip_2,
       condenser_temperature, condenser_temperature_avg, temperature_dry_box,
       temperature_dry_box_avg, ctd_pressure, ctd_pressure_avg, ctd_temperature,
       ctd_temperature_avg, ctd_conductivity, ctd_conductivity_avg, "ctd_O2_saturation",
       "ctd_O2_saturation_avg", "ctd_O2_concentration", "ctd_O2_concentration_avg",
       "uw_pH", "uw_pH_avg", uw_redox_potential, uw_redox_potential_avg,
       temperature_external, temperature_external_avg, tsg_temperature,
       tsg_temperature_avg, tsg_salinity, tsg_salinity_avg, tsg_conductivity,
       tsg_conductivity_avg, tsg_sound_speed, tsg_sound_speed_avg, temperature_in,
       temperature_in_avg, bad_wind_direction_flag, very_bad_wind_direction_flag,
       bad_ice_flag, bad_atmospheric_pressure_flag, bad_anemometer_flag,
       bad_barometer_flag, bad_trh_sensor_flag, bad_ir_sensor_flag,
       nbad_ctd_flag, "nbad_CO2_flag", "nbad_H2O_flag", "nbad_H2O_flow_flag",
       nbad_pressure_analyzer_flag, nbad_temperature_analyzer_flag,
       nbad_equ_temperature_flag, nbad_temperature_external_flag, fluxable_exception
FROM amundsen_flux.${LFREQ2}
ORDER BY time_10min, time_study;
\cd ${LFREQ2ODIR}
\copy (SELECT * FROM lowfreq_1w10min_flags) TO PROGRAM 'awk -v fprefix=L2 -f ${SPLITYMD_PRG} -' CSV
\H
\o colnames.html
SELECT DISTINCT ON (cols.ordinal_position, cols.column_name)
    cols.ordinal_position,
    cols.column_name,
    col_description(cl.oid, cols.ordinal_position::INT)
FROM information_schema.columns cols
    JOIN pg_class cl ON cols.table_name = cl.relname
    JOIN pg_attribute pa ON cols.column_name = pa.attname
WHERE pa.attrelid = 'lowfreq_1w10min_flags'::regclass AND
    cl.relname = '${LFREQ2}' AND
    cols.table_catalog = 'gases' AND
    cols.table_schema = 'amundsen_flux'
ORDER BY cols.ordinal_position, cols.column_name;
EOF
psql -p5433 -f${TMPDIR}/lfreq2_dump.sql gases


rm -rf ${TMPDIR}
