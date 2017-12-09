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

ROOTDIR=/mnt/CEOS_Tim/AMD/2014/FromDB
# Core low frequency views
LFREQ1=lowfreq_1w20min_2014
LFREQ1ODIR=${ROOTDIR}/LowFreq_1w20min
LFREQ2=lowfreq_1w20min_2014_flags
LFREQ2ODIR=${ROOTDIR}/LowFreq_1w20min_flags
LFREQ3=lowfreq_20min_fluxable_2014
LFREQ3ODIR=${ROOTDIR}/LowFreq_20min_fluxable
LFREQ3OFILE=L3_2014.csv
# Core high frequency views
HFREQ1=flux1_10hz_2014
HFREQ1ODIR=${ROOTDIR}/Flux1_10hz
HFREQ2=flux2_10hz_2014
HFREQ2ODIR=${ROOTDIR}/Flux2_10hz
# Program to split into daily files
SPLITISO_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDDHHMMSS.awk)
SPLITYMD_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDD.awk)

TMPDIR=$(mktemp -d -p /var/tmp)

mkdir -p ${LFREQ1ODIR} ${LFREQ2ODIR} ${LFREQ3ODIR} ${HFREQ1ODIR} ${HFREQ2ODIR}

cat <<EOF > ${TMPDIR}/lfreq1_dump.sql
CREATE OR REPLACE TEMPORARY VIEW lowfreq_1w20min AS
SELECT time_20min, time_study, longitude, longitude_avg, latitude, latitude_avg,
       speed_over_ground, speed_over_ground_avg, speed_over_ground_sd,
       speed_over_ground_v_avg, course_over_ground, course_over_ground_avg,
       course_over_ground_sd, heading, heading_avg, heading_sd, pitch,
       pitch_avg, roll, roll_avg, heave, heave_avg, atmospheric_pressure,
       atmospheric_pressure_avg, air_temperature, air_temperature_avg,
       relative_humidity, relative_humidity_avg, surface_temperature,
       surface_temperature_avg, wind_speed, wind_speed_sd, wind_speed_avg,
       wind_direction, wind_direction_sd, wind_direction_avg, wind_direction_avg_sd,
       true_wind_speed, true_wind_speed_avg, true_wind_direction, true_wind_direction_avg,
       wind_speed_u, wind_speed_u_avg, wind_speed_v, wind_speed_v_avg,
       wind_speed_w, wind_speed_w_avg, air_temperature_sonic, air_temperature_sonic_avg,
       cp_analyzer_status, "cp_CO2_fraction", "cp_CO2_fraction_avg",
       "cp_H2O_fraction", "cp_H2O_fraction_avg", cp_pressure, cp_pressure_avg,
       cp_temperature, cp_temperature_avg, "op_CO2_density", "op_CO2_density_avg",
       "op_H2O_density", "op_H2O_density_avg", op_pressure, op_pressure_avg,
       op_temperature, op_temperature_avg, "PAR", "PAR_avg", "K_down",
       "K_down_avg", "LW_down", "LW_down_avg", equ_temperature,
       equ_temperature_avg, std_value, "uw_CO2_cellA", "uw_CO2_cellA_avg",
       "uw_CO2_cellB", "uw_CO2_cellB_avg", "uw_CO2_fraction", "uw_CO2_fraction_avg",
       "uw_H2O_cellA", "uw_H2O_cellA_avg", "uw_H2O_cellB", "uw_H2O_cellB_avg",
       "uw_H2O_fraction", "uw_H2O_fraction_avg", uw_temperature_analyzer,
       uw_temperature_analyzer_avg, uw_pressure_analyzer, uw_pressure_analyzer_avg,
       equ_pressure, equ_pressure_avg, "H2O_flow", "H2O_flow_avg", air_flow_analyzer,
       air_flow_analyzer_avg, equ_speed_pump, equ_speed_pump_avg, ventilation_flow,
       ventilation_flow_avg, condensation_atm, condensation_atm_avg,
       condensation_equ, condensation_equ_avg, drip_1, drip_2, condenser_temperature,
       condenser_temperature_avg, temperature_dry_box, temperature_dry_box_avg,
       ctd_pressure, ctd_pressure_avg, ctd_temperature, ctd_temperature_avg,
       ctd_conductivity, ctd_conductivity_avg, "ctd_O2_saturation",
       "ctd_O2_saturation_avg", "ctd_O2_concentration", "ctd_O2_concentration_avg",
       "uw_pH", "uw_pH_avg", uw_redox_potential, uw_redox_potential_avg,
       temperature_external, temperature_external_avg, tsg_temperature,
       tsg_temperature_avg, tsg_salinity, tsg_salinity_avg, tsg_conductivity,
       tsg_conductivity_avg, tsg_sound_speed, tsg_sound_speed_avg,
       temperature_in, temperature_in_avg,
       bad_wind_direction_flag, very_bad_wind_direction_flag,
       bad_ice_flag, bad_atmospheric_pressure_flag, bad_anemometer_flag,
       bad_barometer_flag, bad_trh_sensor_flag, bad_ir_sensor_flag,
       nbad_ctd_flag, "nbad_CO2_flag", "nbad_H2O_flag", "nbad_H2O_flow_flag",
       nbad_pressure_analyzer_flag, nbad_temperature_analyzer_flag,
       nbad_equ_temperature_flag, nbad_temperature_external_flag
FROM amundsen_flux.${LFREQ1}
ORDER BY time_20min, time_study;
\cd ${LFREQ1ODIR}
\copy (SELECT * FROM lowfreq_1w20min) TO PROGRAM 'awk -v fprefix=L1 -f ${SPLITYMD_PRG} -' CSV
\H
\o colnames.html
SELECT DISTINCT ON (cols.ordinal_position, cols.column_name)
    cols.ordinal_position, cols.column_name,
    col_description(cl.oid, cols.ordinal_position::INT)
FROM information_schema.columns cols
    JOIN pg_class cl ON cols.table_name = cl.relname
    JOIN pg_attribute pa ON cols.column_name = pa.attname
WHERE pa.attrelid = 'lowfreq_1w20min'::regclass AND
    cl.relname = '${LFREQ1}' AND
    cols.table_catalog = 'gases' AND
    cols.table_schema = 'amundsen_flux'
ORDER BY cols.ordinal_position, cols.column_name;
EOF
psql -p5433 -f${TMPDIR}/lfreq1_dump.sql gases

cat <<EOF > ${TMPDIR}/lfreq2_dump.sql
CREATE OR REPLACE TEMPORARY VIEW lowfreq_1w20min_flags AS
SELECT time_20min, time_study, longitude, longitude_avg, latitude, latitude_avg,
       speed_over_ground, speed_over_ground_avg, speed_over_ground_sd,
       speed_over_ground_v_avg, course_over_ground, course_over_ground_avg,
       course_over_ground_sd, heading, heading_avg, heading_sd, pitch,
       pitch_avg, roll, roll_avg, heave, heave_avg, atmospheric_pressure,
       atmospheric_pressure_avg, air_temperature, air_temperature_avg,
       relative_humidity, relative_humidity_avg, surface_temperature,
       surface_temperature_avg, wind_speed, wind_speed_sd, wind_speed_avg,
       wind_direction, wind_direction_sd, wind_direction_avg, wind_direction_avg_sd,
       true_wind_speed, true_wind_speed_avg, true_wind_direction, true_wind_direction_avg,
       wind_speed_u, wind_speed_u_avg, wind_speed_v, wind_speed_v_avg,
       wind_speed_w, wind_speed_w_avg, air_temperature_sonic, air_temperature_sonic_avg,
       cp_analyzer_status, "cp_CO2_fraction", "cp_CO2_fraction_avg",
       "cp_H2O_fraction", "cp_H2O_fraction_avg", cp_pressure, cp_pressure_avg,
       cp_temperature, cp_temperature_avg, "op_CO2_density", "op_CO2_density_avg",
       "op_H2O_density", "op_H2O_density_avg", op_pressure, op_pressure_avg,
       op_temperature, op_temperature_avg, "PAR", "PAR_avg", "K_down",
       "K_down_avg", "LW_down", "LW_down_avg", equ_temperature, equ_temperature_avg,
       std_value, "uw_CO2_cellA", "uw_CO2_cellA_avg", "uw_CO2_cellB", "uw_CO2_cellB_avg",
       "uw_CO2_fraction", "uw_CO2_fraction_avg", "uw_H2O_cellA", "uw_H2O_cellA_avg",
       "uw_H2O_cellB", "uw_H2O_cellB_avg", "uw_H2O_fraction", "uw_H2O_fraction_avg",
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
       tsg_conductivity_avg, tsg_sound_speed, tsg_sound_speed_avg,
       temperature_in, temperature_in_avg,
       bad_wind_direction_flag, very_bad_wind_direction_flag,
       bad_ice_flag, bad_atmospheric_pressure_flag, bad_anemometer_flag,
       bad_barometer_flag, bad_trh_sensor_flag, bad_ir_sensor_flag,
       nbad_ctd_flag, "nbad_CO2_flag", "nbad_H2O_flag", "nbad_H2O_flow_flag",
       nbad_pressure_analyzer_flag, nbad_temperature_analyzer_flag,
       nbad_equ_temperature_flag, nbad_temperature_external_flag, fluxable_exception
FROM amundsen_flux.${LFREQ2}
ORDER BY time_20min, time_study;
\cd ${LFREQ2ODIR}
\copy (SELECT * FROM lowfreq_1w20min_flags) TO PROGRAM 'awk -v fprefix=L2 -f ${SPLITYMD_PRG} -' CSV
\H
\o colnames.html
SELECT DISTINCT ON (cols.ordinal_position, cols.column_name)
    cols.ordinal_position, cols.column_name,
    col_description(cl.oid, cols.ordinal_position::INT)
FROM information_schema.columns cols
    JOIN pg_class cl ON cols.table_name = cl.relname
    JOIN pg_attribute pa ON cols.column_name = pa.attname
WHERE pa.attrelid = 'lowfreq_1w20min_flags'::regclass AND
    cl.relname = '${LFREQ2}' AND
    cols.table_catalog = 'gases' AND
    cols.table_schema = 'amundsen_flux'
ORDER BY cols.ordinal_position, cols.column_name;
EOF
psql -p5433 -f${TMPDIR}/lfreq2_dump.sql gases

cat <<EOF > ${TMPDIR}/lfreq3_dump.sql
CREATE OR REPLACE TEMPORARY VIEW lowfreq_20min_fluxable AS
SELECT time_20min, longitude, latitude, speed_over_ground, course_over_ground,
       heading, pitch, roll, heave, atmospheric_pressure, air_temperature,
       relative_humidity, surface_temperature, wind_speed, wind_direction,
       true_wind_speed, true_wind_direction, "PAR", "K_down", "LW_down",
       nfluxable
FROM amundsen_flux.${LFREQ3};
\cd {LFREQ3ODIR}
\copy (SELECT * FROM lowfreq_20min_fluxable) TO '${LFREQ3OFILE}' CSV HEADER
EOF
psql -p5433 -f${TMPDIR}/lfreq3_dump.sql gases

cat <<EOF > ${TMPDIR}/hfreq1_dump.sql
CREATE OR REPLACE TEMPORARY VIEW flux_10hz AS
SELECT time_20min, time_study, longitude, latitude, speed_over_ground,
       course_over_ground, heading, pitch, roll, heave, atmospheric_pressure,
       air_temperature, relative_humidity, surface_temperature, wind_speed,
       wind_direction, true_wind_speed, true_wind_direction, "PAR",
       "K_down", "LW_down", acceleration_x, acceleration_y, acceleration_z,
       rate_x, rate_y, rate_z, wind_speed_u, wind_speed_v, wind_speed_w,
       air_temperature_sonic, sound_speed, anemometer_status, "op_CO2_fraction",
       "op_CO2_density", "op_CO2_absorptance", "op_H2O_fraction", "op_H2O_density",
       "op_H2O_absorptance", op_pressure, op_temperature, op_temperature_base,
       op_temperature_spar, op_temperature_bulb, op_cooler_voltage,
       op_bandwidth, op_delay_interval, op_bad_chopper_wheel_temperature_flag,
       op_bad_detector_temperature_flag, op_bad_optical_wheel_rate_flag,
       op_bad_sync_flag, "op_CO2_signal_strength", op_analyzer_status,
       cp_analyzer_status, "cp_CO2_fraction", "cp_CO2_density", "cp_CO2_dry_fraction",
       "cp_CO2_absorptance", "cp_H2O_fraction", "cp_H2O_density", "cp_H2O_dry_fraction",
       "cp_H2O_absorptance", cp_pressure, cp_temperature, cp_temperature_in,
       cp_temperature_out, cp_temperature_block, cp_temperature_cell,
       "cp_CO2_signal_strength", "cp_H2O_signal_strength"
  FROM amundsen_flux.${HFREQ1};
\cd ${HFREQ1ODIR}
\copy (SELECT * FROM flux_10hz) TO PROGRAM 'awk -v fprefix=EC -f ${SPLITISO_PRG} -' CSV
\H
\o colnames.html
SELECT DISTINCT ON (cols.ordinal_position, cols.column_name)
    cols.ordinal_position, cols.column_name,
    col_description(cl.oid, cols.ordinal_position::INT)
FROM information_schema.columns cols
    JOIN pg_class cl ON cols.table_name = cl.relname
    JOIN pg_attribute pa ON cols.column_name = pa.attname
WHERE pa.attrelid = 'flux_10hz'::regclass AND
    cl.relname = '${HFREQ1}' AND
    cols.table_catalog = 'gases' AND
    cols.table_schema = 'amundsen_flux'
ORDER BY cols.ordinal_position, cols.column_name;
EOF
psql -p5433 -f${TMPDIR}/hfreq1_dump.sql gases

cat <<EOF > ${TMPDIR}/hfreq2_dump.sql
CREATE OR REPLACE TEMPORARY VIEW flux_10hz AS
SELECT time_20min, time_study, longitude, latitude, speed_over_ground,
       course_over_ground, heading, pitch, roll, heave, atmospheric_pressure,
       air_temperature, relative_humidity, surface_temperature, wind_speed,
       wind_direction, true_wind_speed, true_wind_direction, "PAR",
       "K_down", "LW_down", acceleration_x, acceleration_y, acceleration_z,
       rate_x, rate_y, rate_z, wind_speed_u, wind_speed_v, wind_speed_w,
       air_temperature_sonic, sound_speed, anemometer_status, "op_CO2_fraction",
       "op_CO2_density", "op_CO2_absorptance", "op_H2O_fraction", "op_H2O_density",
       "op_H2O_absorptance", op_pressure, op_temperature, op_temperature_base,
       op_temperature_spar, op_temperature_bulb, op_cooler_voltage,
       op_bandwidth, op_delay_interval, op_bad_chopper_wheel_temperature_flag,
       op_bad_detector_temperature_flag, op_bad_optical_wheel_rate_flag,
       op_bad_sync_flag, "op_CO2_signal_strength", op_analyzer_status,
       cp_analyzer_status, "cp_CO2_fraction", "cp_CO2_density", "cp_CO2_dry_fraction",
       "cp_CO2_absorptance", "cp_H2O_fraction", "cp_H2O_density", "cp_H2O_dry_fraction",
       "cp_H2O_absorptance", cp_pressure, cp_temperature, cp_temperature_in,
       cp_temperature_out, cp_temperature_block, cp_temperature_cell,
       "cp_CO2_signal_strength", "cp_H2O_signal_strength"
  FROM amundsen_flux.${HFREQ2};
\cd ${HFREQ2ODIR}
\copy (SELECT * FROM flux_10hz) TO PROGRAM 'awk -v fprefix=EC -f ${SPLITISO_PRG} -' CSV
\H
\o colnames.html
SELECT DISTINCT ON (cols.ordinal_position, cols.column_name)
    cols.ordinal_position, cols.column_name,
    col_description(cl.oid, cols.ordinal_position::INT)
FROM information_schema.columns cols
    JOIN pg_class cl ON cols.table_name = cl.relname
    JOIN pg_attribute pa ON cols.column_name = pa.attname
WHERE pa.attrelid = 'flux_10hz'::regclass AND
    cl.relname = '${HFREQ2}' AND
    cols.table_catalog = 'gases' AND
    cols.table_schema = 'amundsen_flux'
ORDER BY cols.ordinal_position, cols.column_name;
EOF
psql -p5433 -f${TMPDIR}/hfreq2_dump.sql gases


rm -rf ${TMPDIR}
