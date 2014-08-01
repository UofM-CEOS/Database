#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian Luque
# Created: 2014-02-12T04:33:42+0000
# Last-Updated: 2014-07-31T21:07:07+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# This is used to produced 6 files to be loaded onto database, which
# combines the data from the project.
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    avg_dir="/home/sluque/Data/ArcticNet/2014/LI-7500A"
    sonic1_analog_ofile=avg_dir "/sonic1_analog.csv"
    sonic2_sdm_ofile=avg_dir "/sonic2_sdm.csv"
    # Open path (LI-7500A)
    op1_ofile=avg_dir "/open_path_LI7500A_1.csv"
    op2_ofile=avg_dir "/open_path_LI7500A_2.csv"
    print "time,record_number,program_version,wind_speed_u,wind_speed_v",
	"wind_speed_w,air_temperature_sonic" > sonic1_analog_ofile
    print "time,record_number,program_version,wind_speed_u,wind_speed_v",
    	"wind_speed_w,air_temperature_sonic" > sonic2_sdm_ofile
    print "time,record_number,program_version,op_analyzer_status",
    	"op_CO2_fraction,op_H2O_fraction,op_CO2_density,op_H2O_density",
	"op_CO2_absorptance,op_H2O_absorptance,op_pressure",
    	"op_temperature,op_cooler_voltage" > op1_ofile
    print "time,record_number,program_version,op_analyzer_status",
    	"op_CO2_fraction,op_H2O_fraction,op_CO2_density,op_H2O_density",
	"op_CO2_absorptance,op_H2O_absorptance,op_pressure",
    	"op_temperature,op_cooler_voltage" > op2_ofile
}

FNR > 4 {
    gsub(/"/, "")
    date_time=$1
    record_number=$2
    program_version=$3
    print date_time, record_number, program_version, $5, $6, $7,
	$8 >> sonic1_analog_ofile
    print date_time, record_number, program_version, $9, $10, $11,
    	$12 >> sonic2_sdm_ofile
    print date_time, record_number, program_version, $22, $13, $14, $15,
    	$16, $17, $18, $19, $20, $21 >> op1_ofile
    print date_time, record_number, program_version, $32, $23, $24, $25,
    	$26, $27, $28, $29, $30, $31 >> op2_ofile
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# ec_avg_4db.awk ends here
