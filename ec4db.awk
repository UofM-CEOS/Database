#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian Luque
# Created: 2014-02-12T04:33:42+0000
# Last-Updated: 2014-08-25T21:30:31+0000
#           By: Sebastian Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# This is used to produce several files to be loaded onto database, which
# combines the data from the project.
#
# Example call (output written to current directory):
#
# ec4db.awk *.dat
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ec_dir="/home/sluque/Data/ArcticNet/2013/Tower/EC"
    logger_ofile=ec_dir "/logger.csv"
    motion_ofile=ec_dir "/motion.csv"
    wind1_analog_ofile=ec_dir "/wind1_analog.csv"
    wind1_serial_ofile=ec_dir "/wind1_serial.csv"
    wind2_sdm_ofile=ec_dir "/wind2_sdm.csv"
    # Open path 1 (LI-7500)
    op1_ofile=ec_dir "/open_path_LI7500A_1.csv"
    # Open path 2 (LI-7500A)
    op2_ofile=ec_dir "/open_path_LI7500A_2.csv"
    print "time,record_number,program_version,acceleration_x,acceleration_y",
    	"acceleration_z,rate_x,rate_y,rate_z" > motion_ofile
    print "time,record_number,program_version,wind_speed_u,wind_speed_v",
	"wind_speed_w,air_temperature_sonic" > wind1_analog_ofile
    print "time,record_number,program_version,wind_speed_u,wind_speed_v",
	"wind_speed_w,air_temperature_sonic,sound_speed",
	"anemometer_status" > wind1_serial_ofile
    print "time,record_number,program_version,wind_speed_u,wind_speed_v",
    	"wind_speed_w,air_temperature_sonic",
    	"anemometer_status" > wind2_sdm_ofile
    print "time,record_number,program_version,op_analyzer_status",
    	"op_CO2_density,op_H2O_density,op_pressure",
    	"op_temperature" > op1_ofile
    print "time,record_number,program_version,op_analyzer_status",
    	"op_CO2_density,op_H2O_density,op_pressure",
    	"op_temperature" > op2_ofile
}

FNR > 4 {
    gsub(/"/, "")
    date_time=$1
    record_number=$2
    program_version=$3
    print date_time, record_number, program_version, $4, $5, $6, $7, $8,
    	$9 >> motion_ofile
    print date_time, record_number, program_version, $10, $11, $12,
	$13 >> wind1_analog_ofile
    print date_time, record_number, program_version, $14, $15, $16, $17,
    	$18, $19 >> wind1_serial_ofile
    print date_time, record_number, program_version, $20, $21, $22, $23,
    	$24 >> wind2_sdm_ofile
    print date_time, record_number, program_version, $30, $25, $26, $27,
    	$28 >> op1_ofile
    print date_time, record_number, program_version, $36, $31, $32, $33,
    	$34 >> op2_ofile
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# ec4db.awk ends here
