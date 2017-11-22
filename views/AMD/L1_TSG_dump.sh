#! /bin/sh
# Author: Sebastian Luque
# Created: 2016-10-08T17:00:02+0000
# -------------------------------------------------------------------------
# Commentary:
#
# Dump L1 view along with full TSG data for Tonya Burgers.
# -------------------------------------------------------------------------
# Code:

ROOTDIR=/mnt/CEOS_Tim/AMD/2016/FromDB
# Core low frequency views
LFREQ1=lowfreq_1w20min
LFREQ1ODIR=${ROOTDIR}/LowFreq_1w20min
# Program to split into daily files
SPLITISO_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDDHHMMSS.awk)
SPLITYMD_PRG=$(realpath -e "$(dirname $0)"/../../split_YYYYMMDD.awk)

TMPDIR=$(mktemp -d -p /var/tmp)

cat <<EOF > ${TMPDIR}/lfreq1_dump.sql
CREATE OR REPLACE TEMPORARY VIEW underway_1s AS
 WITH pre AS (
         SELECT ts.time_study,
            tsw."time" AS time_1min,
            uw.uw_diag,
            uw.equ_temperature,
            uw.std_value,
            uw."uw_CO2_cellA",
            uw."uw_CO2_cellB",
            uw."uw_CO2_fraction",
            uw."uw_H2O_cellA",
            uw."uw_H2O_cellB",
            uw."uw_H2O_fraction",
            uw.uw_temperature_analyzer,
            uw.uw_pressure_analyzer,
            uw.equ_pressure,
            uw."H2O_flow",
            uw.air_flow_analyzer,
            uw.equ_speed_pump,
            uw.ventilation_flow,
            uw.condensation_atm,
            uw.condensation_equ,
            uw.drip_1,
            uw.drip_2,
            uw.condenser_temperature,
            uw.temperature_dry_box,
            uw.ctd_pressure,
            uw.ctd_temperature,
            uw.ctd_conductivity,
            uw."ctd_O2_saturation",
            uw."ctd_O2_concentration",
            uw."uw_pH",
            uw.uw_redox_potential,
            tsw.temperature_external,
            tsg.tsg_temperature,
            tsg.tsg_conductivity,
            tsg.tsg_salinity,
            tsg.tsg_fluorescence,
            uw.temperature_in,
                CASE
                    WHEN abs(uw.ctd_temperature - uw.equ_temperature) > 2::numeric OR uw.ctd_temperature = 0::numeric AND uw.ctd_pressure = 0::numeric AND uw.ctd_conductivity = 0::numeric OR uw.ctd_pressure > 10::numeric THEN true
                    ELSE false
                END AS bad_ctd_flag,
                CASE
                    WHEN uw."uw_CO2_fraction" < 0::numeric OR uw."uw_CO2_fraction" > 1000::numeric THEN true
                    ELSE false
                END AS "bad_CO2_flag",
                CASE
                    WHEN uw."uw_H2O_fraction" < 0::numeric OR uw."uw_H2O_fraction" > 100::numeric THEN true
                    ELSE false
                END AS "bad_H2O_flag",
                CASE
                    WHEN uw."H2O_flow" < 2.0 THEN true
                    ELSE false
                END AS "bad_H2O_flow_flag",
                CASE
                    WHEN uw.uw_pressure_analyzer > 1200::numeric OR uw.uw_pressure_analyzer < 900::numeric THEN true
                    ELSE false
                END AS bad_pressure_analyzer_flag,
                CASE
                    WHEN uw.uw_temperature_analyzer < 0::numeric OR uw.uw_temperature_analyzer > 100::numeric OR uw.uw_temperature_analyzer = 'NaN'::numeric THEN true
                    ELSE false
                END AS bad_temperature_analyzer_flag,
                CASE
                    WHEN uw.equ_temperature < '-20'::integer::numeric OR uw.equ_temperature > 40::numeric THEN true
                    ELSE false
                END AS bad_equ_temperature_flag,
                CASE
                    WHEN tsw.temperature_external < '-20'::integer::numeric OR tsw.temperature_external > 40::numeric THEN true
                    ELSE false
                END AS bad_temperature_external_flag
           FROM amundsen_flux.ts_1s_2016 ts
             LEFT JOIN ( SELECT underway_series.underway_record_id,
                    underway_series.logging_group_id,
                    underway_series."time",
                    underway_series.record_type,
                    underway_series.uw_diag,
                    underway_series.equ_temperature,
                    underway_series.std_value,
                    underway_series."uw_CO2_cellA",
                    underway_series."uw_CO2_cellB",
                    underway_series."uw_CO2_fraction",
                    underway_series."uw_CO2_density",
                    underway_series."uw_H2O_cellA",
                    underway_series."uw_H2O_cellB",
                    underway_series."uw_H2O_fraction",
                    underway_series."uw_H2O_density",
                    underway_series.uw_temperature_analyzer,
                    underway_series.uw_pressure_analyzer,
                    underway_series.equ_pressure,
                    underway_series."H2O_flow",
                    underway_series.air_flow_analyzer,
                    underway_series.equ_speed_pump,
                    underway_series.ventilation_flow,
                    underway_series.condensation_atm,
                    underway_series.condensation_equ,
                    underway_series.drip_1,
                    underway_series.drip_2,
                    underway_series.condenser_temperature,
                    underway_series.temperature_dry_box,
                    underway_series.ctd_pressure,
                    underway_series.ctd_temperature,
                    underway_series.ctd_conductivity,
                    underway_series."ctd_O2_saturation",
                    underway_series."ctd_O2_concentration",
                    underway_series."uw_pH",
                    underway_series.uw_redox_potential,
                    underway_series.temperature_in
                   FROM underway_series
                  WHERE underway_series.logging_group_id = 96 AND underway_series.record_type::text = 'EQU'::text) uw ON ts.time_study = date_trunc('second'::text, uw."time")
             LEFT JOIN ( SELECT underway_series.logging_group_id,
                    underway_series."time",
                    underway_series.temperature_external
                   FROM underway_series
                  WHERE underway_series.logging_group_id = 104) tsw ON date_trunc('minute'::text, ts.time_study + '00:00:30'::interval) = tsw."time"
             LEFT JOIN ( SELECT underway_series.logging_group_id,
                    underway_series."time",
                    underway_series.tsg_temperature,
                    underway_series.tsg_conductivity,
                    underway_series.tsg_salinity,
                    underway_series.tsg_sound_speed,
                    underway_series."tsg_H2O_flow",
                    underway_series.tsg_fluorescence
                   FROM underway_series
                  WHERE underway_series.logging_group_id = 105) tsg ON ts.time_study = date_trunc('second'::text, tsg."time")
        )
 SELECT pre.time_study,
    pre.time_1min,
    pre.uw_diag,
    pre.equ_temperature,
    pre.std_value,
    pre."uw_CO2_cellA",
    pre."uw_CO2_cellB",
    pre."uw_CO2_fraction",
    pre."uw_H2O_cellA",
    pre."uw_H2O_cellB",
    pre."uw_H2O_fraction",
    pre.uw_temperature_analyzer,
    pre.uw_pressure_analyzer,
    pre.equ_pressure,
    pre."H2O_flow",
    pre.air_flow_analyzer,
    pre.equ_speed_pump,
    pre.ventilation_flow,
    pre.condensation_atm,
    pre.condensation_equ,
    pre.drip_1,
    pre.drip_2,
    pre.condenser_temperature,
    pre.temperature_dry_box,
        CASE
            WHEN pre.bad_ctd_flag THEN NULL::numeric
            ELSE pre.ctd_pressure
        END AS ctd_pressure,
        CASE
            WHEN pre.bad_ctd_flag THEN NULL::numeric
            ELSE pre.ctd_temperature
        END AS ctd_temperature,
        CASE
            WHEN pre.bad_ctd_flag THEN NULL::numeric
            ELSE pre.ctd_conductivity
        END AS ctd_conductivity,
        CASE
            WHEN pre.bad_ctd_flag THEN NULL::numeric
            ELSE pre."ctd_O2_saturation"
        END AS "ctd_O2_saturation",
        CASE
            WHEN pre.bad_ctd_flag THEN NULL::numeric
            ELSE pre."ctd_O2_concentration"
        END AS "ctd_O2_concentration",
        CASE
            WHEN pre.bad_ctd_flag THEN NULL::numeric
            ELSE pre."uw_pH"
        END AS "uw_pH",
        CASE
            WHEN pre.bad_ctd_flag THEN NULL::numeric
            ELSE pre.uw_redox_potential
        END AS uw_redox_potential,
    pre.temperature_external,
    pre.tsg_temperature,
    pre.tsg_conductivity,
    pre.tsg_salinity,
    pre.tsg_fluorescence,
    pre.temperature_in,
    pre.bad_ctd_flag,
    pre."bad_CO2_flag",
    pre."bad_H2O_flag",
    pre."bad_H2O_flow_flag",
    pre.bad_pressure_analyzer_flag,
    pre.bad_temperature_analyzer_flag,
    pre.bad_equ_temperature_flag,
    pre.bad_temperature_external_flag
   FROM pre
  ORDER BY pre.time_study;


CREATE OR REPLACE TEMPORARY VIEW underway_1min AS
 SELECT date_trunc('minute'::text, uw1s.time_study) AS time_study_1min,
    avg(uw1s.equ_temperature) AS equ_temperature,
    avg(uw1s.std_value) AS std_value,
    avg(uw1s."uw_CO2_cellA") AS "uw_CO2_cellA",
    avg(uw1s."uw_CO2_cellB") AS "uw_CO2_cellB",
    avg(uw1s."uw_CO2_fraction") AS "uw_CO2_fraction",
    avg(uw1s."uw_H2O_cellA") AS "uw_H2O_cellA",
    avg(uw1s."uw_H2O_cellB") AS "uw_H2O_cellB",
    avg(uw1s."uw_H2O_fraction") AS "uw_H2O_fraction",
    avg(uw1s.uw_temperature_analyzer) AS uw_temperature_analyzer,
    avg(uw1s.uw_pressure_analyzer) AS uw_pressure_analyzer,
    avg(uw1s.equ_pressure) AS equ_pressure,
    avg(uw1s."H2O_flow") AS "H2O_flow",
    avg(uw1s.air_flow_analyzer) AS air_flow_analyzer,
    avg(uw1s.equ_speed_pump) AS equ_speed_pump,
    avg(uw1s.ventilation_flow) AS ventilation_flow,
    avg(uw1s.condensation_atm) AS condensation_atm,
    avg(uw1s.condensation_equ) AS condensation_equ,
    avg(uw1s.drip_1) AS drip_1,
    avg(uw1s.drip_2) AS drip_2,
    avg(uw1s.condenser_temperature) AS condenser_temperature,
    avg(uw1s.temperature_dry_box) AS temperature_dry_box,
    avg(uw1s.ctd_pressure) AS ctd_pressure,
    avg(uw1s.ctd_temperature) AS ctd_temperature,
    avg(uw1s.ctd_conductivity) AS ctd_conductivity,
    avg(uw1s."ctd_O2_saturation") AS "ctd_O2_saturation",
    avg(uw1s."ctd_O2_concentration") AS "ctd_O2_concentration",
    avg(uw1s."uw_pH") AS "uw_pH",
    avg(uw1s.uw_redox_potential) AS uw_redox_potential,
    avg(uw1s.temperature_external) AS temperature_external,
    avg(uw1s.tsg_temperature) AS tsg_temperature,
    avg(uw1s.tsg_conductivity) AS tsg_conductivity,
    avg(uw1s.tsg_salinity) AS tsg_salinity,
    avg(uw1s.tsg_fluorescence) AS tsg_fluorescence,
    avg(uw1s.temperature_in) AS temperature_in,
    sum(uw1s.bad_ctd_flag::integer) AS nbad_ctd_flag,
    sum(uw1s."bad_CO2_flag"::integer) AS "nbad_CO2_flag",
    sum(uw1s."bad_H2O_flag"::integer) AS "nbad_H2O_flag",
    sum(uw1s."bad_H2O_flow_flag"::integer) AS "nbad_H2O_flow_flag",
    sum(uw1s.bad_pressure_analyzer_flag::integer) AS nbad_pressure_analyzer_flag,
    sum(uw1s.bad_temperature_analyzer_flag::integer) AS nbad_temperature_analyzer_flag,
    sum(uw1s.bad_equ_temperature_flag::integer) AS nbad_equ_temperature_flag,
    sum(uw1s.bad_temperature_external_flag::integer) AS nbad_temperature_external_flag
   FROM underway_1s uw1s
  GROUP BY (date_trunc('minute'::text, uw1s.time_study))
  ORDER BY (date_trunc('minute'::text, uw1s.time_study));


CREATE OR REPLACE TEMPORARY VIEW ${LFREQ1} AS
 WITH pre AS (
         SELECT nav.time_study_1min AS time_study,
            ts_20min.time_20min,
            nav.longitude_avg AS longitude,
            nav.latitude_avg AS latitude,
            nav.speed_over_ground_avg AS speed_over_ground,
            nav.course_over_ground_avg AS course_over_ground,
            nav.heading_avg AS heading,
            nav.pitch_avg AS pitch,
            nav.roll_avg AS roll,
            nav.heave_avg AS heave,
            met.atmospheric_pressure,
            met.air_temperature,
            met.relative_humidity,
            met.surface_temperature,
            met.wind_speed,
            met.wind_speed_sd,
            met.wind_direction,
            met.wind_direction_sd,
            truewind(ROW(0::double precision, nav.course_over_ground_avg, nav.speed_over_ground_avg::double precision, nav.heading_avg, met.wind_direction::double precision, met.wind_speed::double precision)::vessel_wind_parameters) AS truewind_vector,
            wind.wind_speed_u_avg AS wind_speed_u,
            wind.wind_speed_v_avg AS wind_speed_v,
            wind.wind_speed_w_avg AS wind_speed_w,
            wind.air_temperature_sonic_avg AS air_temperature_sonic,
            cp.cp_analyzer_status,
            cp."cp_CO2_fraction",
            cp."cp_H2O_fraction",
            cp.cp_pressure,
            cp.cp_temperature,
            op."op_CO2_density_avg" AS "op_CO2_density",
            op."op_H2O_density_avg" AS "op_H2O_density",
            op.op_pressure_avg AS op_pressure,
            op.op_temperature_avg AS op_temperature,
            rad."PAR",
            rad."K_down",
            rad."LW_down",
            uw.equ_temperature,
            uw.std_value,
            uw."uw_CO2_cellA",
            uw."uw_CO2_cellB",
            uw."uw_CO2_fraction",
            uw."uw_H2O_cellA",
            uw."uw_H2O_cellB",
            uw."uw_H2O_fraction",
            uw.uw_temperature_analyzer,
            uw.uw_pressure_analyzer,
            uw.equ_pressure,
            uw."H2O_flow",
            uw.air_flow_analyzer,
            uw.equ_speed_pump,
            uw.ventilation_flow,
            uw.condensation_atm,
            uw.condensation_equ,
            uw.drip_1,
            uw.drip_2,
            uw.condenser_temperature,
            uw.temperature_dry_box,
            uw.ctd_pressure,
            uw.ctd_temperature,
            uw.ctd_conductivity,
            uw."ctd_O2_saturation",
            uw."ctd_O2_concentration",
            uw."uw_pH",
            uw.uw_redox_potential,
            uw.temperature_external,
            uw.tsg_temperature,
            uw.tsg_conductivity,
            uw.tsg_salinity,
            uw.tsg_fluorescence,
            uw.temperature_in,
                CASE
                    WHEN met.wind_direction > 90.0 AND met.wind_direction < 270.0 THEN true
                    ELSE false
                END AS bad_wind_direction_flag,
                CASE
                    WHEN met.wind_direction > 170.0 AND met.wind_direction < 190.0 THEN true
                    ELSE false
                END AS very_bad_wind_direction_flag,
                CASE
                    WHEN nav.speed_over_ground_sd > 3.0 OR nav.course_over_ground_sd > 20.0::double precision THEN true
                    ELSE false
                END AS bad_ice_flag,
                CASE
                    WHEN met.atmospheric_pressure < 94::numeric THEN true
                    ELSE false
                END AS bad_atmospheric_pressure_flag,
                CASE
                    WHEN nav.pitch_avg > 50.0::double precision THEN true
                    ELSE false
                END AS bad_pitch_flag,
            met.bad_anemometer_flag,
            met.bad_barometer_flag,
            met.bad_trh_sensor_flag,
            met.bad_ir_sensor_flag,
            uw.nbad_ctd_flag,
            uw."nbad_CO2_flag",
            uw."nbad_H2O_flag",
            uw."nbad_H2O_flow_flag",
            uw.nbad_pressure_analyzer_flag,
            uw.nbad_temperature_analyzer_flag,
            uw.nbad_equ_temperature_flag,
            uw.nbad_temperature_external_flag
           FROM amundsen_flux.ts_20min_2016 ts_20min
             LEFT JOIN amundsen_flux.navigation_1min_2016 nav ON nav.time_study_1min >= ts_20min.time_20min AND nav.time_study_1min < (ts_20min.time_20min + '00:20:00'::interval)
             LEFT JOIN amundsen_flux.meteorology_ceos_1min_2016 met ON nav.time_study_1min = met.time_study
             LEFT JOIN amundsen_flux.radiation_1min_2016 rad USING (time_study)
             LEFT JOIN amundsen_flux.wind3d_analog_1min_2016 wind USING (time_study_1min)
             LEFT JOIN amundsen_flux.cpath_1min_2016 cp USING (time_study)
             LEFT JOIN amundsen_flux.opath_1min_2016 op ON nav.time_study_1min = op.time_study_1min AND op."op_CO2_signal_strength_avg" >= 50::numeric AND op."op_CO2_signal_strength_avg" <= 99::numeric
             LEFT JOIN underway_1min uw ON nav.time_study_1min = uw.time_study_1min
        )
 SELECT pre.time_20min,
    pre.time_study,
    pre.longitude,
    round(avg(pre.longitude) OVER w, 7) AS longitude_avg,
    pre.latitude,
    round(avg(pre.latitude) OVER w, 7) AS latitude_avg,
    pre.speed_over_ground,
    round(avg(pre.speed_over_ground) OVER w, 3) AS speed_over_ground_avg,
    stddev(pre.speed_over_ground) OVER w AS speed_over_ground_sd,
    round((avg(decompose_angle(pre.course_over_ground, pre.speed_over_ground::double precision)) OVER w).magnitude::numeric, 3) AS speed_over_ground_v_avg,
    pre.course_over_ground,
    round((avg(decompose_angle(pre.course_over_ground, pre.speed_over_ground::double precision)) OVER w).angle::numeric, 4) AS course_over_ground_avg,
    stddev(decompose_angle(pre.course_over_ground, 1::double precision)) OVER w AS course_over_ground_sd,
    pre.heading,
    round(avg(pre.heading) OVER w::numeric, 4) AS heading_avg,
    stddev(decompose_angle(pre.heading, 1::double precision)) OVER w AS heading_sd,
    pre.pitch,
    round(avg(pre.pitch) OVER w::numeric, 4) AS pitch_avg,
    pre.roll,
    round(avg(pre.roll) OVER w::numeric, 4) AS roll_avg,
    pre.heave,
    round(avg(pre.heave) OVER w, 3) AS heave_avg,
        CASE
            WHEN pre.bad_atmospheric_pressure_flag THEN NULL::numeric
            ELSE pre.atmospheric_pressure
        END AS atmospheric_pressure,
    round(avg(
        CASE
            WHEN pre.bad_atmospheric_pressure_flag THEN NULL::numeric
            ELSE pre.atmospheric_pressure
        END) OVER w, 2) AS atmospheric_pressure_avg,
        CASE
            WHEN pre.very_bad_wind_direction_flag THEN NULL::numeric
            ELSE pre.air_temperature
        END AS air_temperature,
    round(avg(
        CASE
            WHEN pre.very_bad_wind_direction_flag THEN NULL::numeric
            ELSE pre.air_temperature
        END) OVER w, 2) AS air_temperature_avg,
        CASE
            WHEN pre.very_bad_wind_direction_flag THEN NULL::numeric
            ELSE pre.relative_humidity
        END AS relative_humidity,
    round(avg(
        CASE
            WHEN pre.very_bad_wind_direction_flag THEN NULL::numeric
            ELSE pre.relative_humidity
        END) OVER w, 2) AS relative_humidity_avg,
    pre.surface_temperature,
    round(avg(pre.surface_temperature) OVER w, 2) AS surface_temperature_avg,
        CASE
            WHEN pre.bad_wind_direction_flag THEN NULL::numeric
            ELSE pre.wind_speed
        END AS wind_speed,
        CASE
            WHEN pre.bad_wind_direction_flag THEN NULL::numeric
            ELSE pre.wind_speed_sd
        END AS wind_speed_sd,
    round((avg(
        CASE
            WHEN pre.bad_wind_direction_flag THEN decompose_angle(NULL::double precision, NULL::double precision)
            ELSE decompose_angle(pre.wind_direction, pre.wind_speed)
        END) OVER w).magnitude::numeric, 2) AS wind_speed_avg,
        CASE
            WHEN pre.bad_wind_direction_flag THEN NULL::numeric
            ELSE pre.wind_direction
        END AS wind_direction,
        CASE
            WHEN pre.bad_wind_direction_flag THEN NULL::numeric
            ELSE pre.wind_direction_sd
        END AS wind_direction_sd,
    round((avg(
        CASE
            WHEN pre.bad_wind_direction_flag THEN decompose_angle(NULL::double precision, NULL::double precision)
            ELSE decompose_angle(pre.wind_direction, pre.wind_speed)
        END) OVER w).angle::numeric, 2) AS wind_direction_avg,
    stddev(decompose_angle(pre.wind_direction::double precision, 1::double precision)) OVER w AS wind_direction_avg_sd,
    round((pre.truewind_vector).magnitude::numeric, 2) AS true_wind_speed,
    round((avg(
        CASE
            WHEN pre.bad_wind_direction_flag THEN decompose_angle(NULL::double precision, NULL::double precision)
            ELSE decompose_angle((pre.truewind_vector).angle, (pre.truewind_vector).magnitude)
        END) OVER w).magnitude::numeric, 2) AS true_wind_speed_avg,
    round((pre.truewind_vector).angle::numeric, 2) AS true_wind_direction,
    round((avg(
        CASE
            WHEN pre.bad_wind_direction_flag THEN decompose_angle(NULL::double precision, NULL::double precision)
            ELSE decompose_angle((pre.truewind_vector).angle, (pre.truewind_vector).magnitude)
        END) OVER w).angle::numeric, 2) AS true_wind_direction_avg,
    pre.wind_speed_u,
    avg(pre.wind_speed_u) OVER w AS wind_speed_u_avg,
    pre.wind_speed_v,
    avg(pre.wind_speed_v) OVER w AS wind_speed_v_avg,
    pre.wind_speed_w,
    avg(pre.wind_speed_w) OVER w AS wind_speed_w_avg,
    pre.air_temperature_sonic,
    avg(pre.air_temperature_sonic) OVER w AS air_temperature_sonic_avg,
    pre.cp_analyzer_status,
    pre."cp_CO2_fraction",
    avg(pre."cp_CO2_fraction") OVER w AS "cp_CO2_fraction_avg",
    pre."cp_H2O_fraction",
    avg(pre."cp_H2O_fraction") OVER w AS "cp_H2O_fraction_avg",
    pre.cp_pressure,
    avg(pre.cp_pressure) OVER w AS cp_pressure_avg,
    pre.cp_temperature,
    avg(pre.cp_temperature) OVER w AS cp_temperature_avg,
    pre."op_CO2_density",
    avg(pre."op_CO2_density") OVER w AS "op_CO2_density_avg",
    pre."op_H2O_density",
    avg(pre."op_H2O_density") OVER w AS "op_H2O_density_avg",
    pre.op_pressure,
    avg(pre.op_pressure) OVER w AS op_pressure_avg,
    pre.op_temperature,
    avg(pre.op_temperature) OVER w AS op_temperature_avg,
    pre."PAR",
    round(avg(pre."PAR") OVER w, 2) AS "PAR_avg",
    pre."K_down",
    round(avg(pre."K_down") OVER w, 2) AS "K_down_avg",
    pre."LW_down",
    round(avg(pre."LW_down") OVER w, 2) AS "LW_down_avg",
    pre.equ_temperature,
    round(avg(pre.equ_temperature) OVER w, 2) AS equ_temperature_avg,
    pre.std_value,
    pre."uw_CO2_cellA",
    round(avg(pre."uw_CO2_cellA") OVER w, 2) AS "uw_CO2_cellA_avg",
    pre."uw_CO2_cellB",
    round(avg(pre."uw_CO2_cellB") OVER w, 2) AS "uw_CO2_cellB_avg",
    pre."uw_CO2_fraction",
    round(avg(pre."uw_CO2_fraction") OVER w, 2) AS "uw_CO2_fraction_avg",
    pre."uw_H2O_cellA",
    round(avg(pre."uw_H2O_cellA") OVER w, 2) AS "uw_H2O_cellA_avg",
    pre."uw_H2O_cellB",
    round(avg(pre."uw_H2O_cellB") OVER w, 2) AS "uw_H2O_cellB_avg",
    pre."uw_H2O_fraction",
    round(avg(pre."uw_H2O_fraction") OVER w, 2) AS "uw_H2O_fraction_avg",
    pre.uw_temperature_analyzer,
    round(avg(pre.uw_temperature_analyzer) OVER w, 2) AS uw_temperature_analyzer_avg,
    pre.uw_pressure_analyzer,
    round(avg(pre.uw_pressure_analyzer) OVER w, 2) AS uw_pressure_analyzer_avg,
    pre.equ_pressure,
    round(avg(pre.equ_pressure) OVER w, 2) AS equ_pressure_avg,
    pre."H2O_flow",
    round(avg(pre."H2O_flow") OVER w, 2) AS "H2O_flow_avg",
    pre.air_flow_analyzer,
    round(avg(pre.air_flow_analyzer) OVER w, 2) AS air_flow_analyzer_avg,
    pre.equ_speed_pump,
    round(avg(pre.equ_speed_pump) OVER w, 2) AS equ_speed_pump_avg,
    pre.ventilation_flow,
    round(avg(pre.ventilation_flow) OVER w, 2) AS ventilation_flow_avg,
    pre.condensation_atm,
    round(avg(pre.condensation_atm) OVER w, 2) AS condensation_atm_avg,
    pre.condensation_equ,
    round(avg(pre.condensation_equ) OVER w, 2) AS condensation_equ_avg,
    pre.drip_1,
    pre.drip_2,
    pre.condenser_temperature,
    round(avg(pre.condenser_temperature) OVER w, 2) AS condenser_temperature_avg,
    pre.temperature_dry_box,
    round(avg(pre.temperature_dry_box) OVER w, 2) AS temperature_dry_box_avg,
    pre.ctd_pressure,
    round(avg(pre.ctd_pressure) OVER w, 2) AS ctd_pressure_avg,
    pre.ctd_temperature,
    round(avg(pre.ctd_temperature) OVER w, 2) AS ctd_temperature_avg,
    pre.ctd_conductivity,
    round(avg(pre.ctd_conductivity) OVER w, 2) AS ctd_conductivity_avg,
    pre."ctd_O2_saturation",
    round(avg(pre."ctd_O2_saturation") OVER w, 2) AS "ctd_O2_saturation_avg",
    pre."ctd_O2_concentration",
    round(avg(pre."ctd_O2_concentration") OVER w, 2) AS "ctd_O2_concentration_avg",
    pre."uw_pH",
    round(avg(pre."uw_pH") OVER w, 2) AS "uw_pH_avg",
    pre.uw_redox_potential,
    round(avg(pre.uw_redox_potential) OVER w, 2) AS uw_redox_potential_avg,
    pre.temperature_external,
    round(avg(pre.temperature_external) OVER w, 2) AS temperature_external_avg,
    pre.tsg_temperature,
    round(avg(pre.tsg_temperature) OVER w, 2) AS tsg_temperature_avg,
    pre.tsg_conductivity,
    round(avg(pre.tsg_conductivity) OVER w, 2) AS tsg_conductivity_avg,
    pre.tsg_salinity,
    round(avg(pre.tsg_salinity) OVER w, 2) AS tsg_salinity_avg,
    pre.tsg_fluorescence,
    round(avg(pre.tsg_fluorescence) OVER w, 2) AS tsg_fluorescence_avg,
    pre.temperature_in,
    round(avg(pre.temperature_in) OVER w, 2) AS temperature_in_avg,
    pre.bad_wind_direction_flag,
    pre.very_bad_wind_direction_flag,
    pre.bad_ice_flag,
    pre.bad_atmospheric_pressure_flag,
    pre.bad_anemometer_flag,
    pre.bad_barometer_flag,
    pre.bad_trh_sensor_flag,
    pre.bad_ir_sensor_flag,
    pre.nbad_ctd_flag,
    pre."nbad_CO2_flag",
    pre."nbad_H2O_flag",
    pre."nbad_H2O_flow_flag",
    pre.nbad_pressure_analyzer_flag,
    pre.nbad_temperature_analyzer_flag,
    pre.nbad_equ_temperature_flag,
    pre.nbad_temperature_external_flag
   FROM pre
  WINDOW w AS (PARTITION BY pre.time_20min ORDER BY pre.time_20min)
  ORDER BY pre.time_study;
\cd ${LFREQ1ODIR}
-- \copy (SELECT * FROM ${LFREQ1}) TO PROGRAM 'awk -v fprefix=L1 -f ${SPLITYMD_PRG} -' CSV
\H
\o colnames.html
SELECT cols.ordinal_position, cols.column_name,
  col_description(cl.oid, cols.ordinal_position::INT)
FROM pg_class cl, information_schema.columns cols
WHERE cols.table_catalog='gases' AND
cols.table_name = '${LFREQ1}' AND cols.table_name = cl.relname
ORDER BY cols.ordinal_position::INT;
EOF
psql -p5433 -f${TMPDIR}/lfreq1_dump.sql gases


rm -rf ${TMPDIR}
