#! /usr/bin/gawk -f
# $Id: $
# Author: Sebastian Luque
# Created: 2014-02-12T04:33:42+0000
# Last-Updated: 2014-08-01T19:10:20+0000
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
    ncols=39
    year=2013
    ec_dir="/home/sluque/Data/ArcticNet/2013/Tower/EC"
    motion_ofile=ec_dir "/motion.csv"
    wind_analog_ofile=ec_dir "/wind_analog.csv"
    wind_serial_ofile=ec_dir "/wind_serial.csv"
    # Main open path (LI-7500)
    op_ofile=ec_dir "/open_path.csv"
    # Open path (LI-7500A)
    op_a_ofile=ec_dir "/open_path_LI7500A.csv"
    op_sh_ofile=ec_dir "/open_path_shrouded.csv"
    print "time,record_number,program_version,acceleration_x,acceleration_y",
	"acceleration_z,rate_x,rate_y,rate_z" > motion_ofile
    print "time,record_number,program_version,wind_speed_u,wind_speed_v",
	"wind_speed_w,air_temperature_sonic" > wind_analog_ofile
    print "stream_type,time,record_number,program_version,wind_speed_u",
	"wind_speed_v,wind_speed_w,air_temperature_sonic,sound_speed",
	"anemometer_status" > wind_serial_ofile
    print "time,record_number,program_version,op_analyzer_status",
	"op_CO2_density,op_H2O_density,op_pressure",
	"op_temperature" > op_ofile
    print "time,record_number,program_version,op_analyzer_status",
	"op_CO2_density,op_H2O_density,op_pressure",
	"op_temperature" > op_a_ofile
    print "time,record_number,program_version,op_analyzer_status",
	"op_CO2_density,op_H2O_density,op_pressure",
	"op_temperature" > op_sh_ofile
}

FNR > 4 {
    gsub(/"/, "")
    date_time=$1
    record_number=$2
    program_version=$3
    print date_time, record_number, program_version, $4, $5, $6, $7, $8,
	$9 >> motion_ofile
    print date_time, record_number, program_version, $10, $11, $12,
	$13 >> wind_analog_ofile
    print date_time, record_number, program_version, $19, $20, $21, $22,
	$23, $24 >> wind_serial_ofile
    print date_time, record_number, program_version, $18, $14, $15, $16,
	$17 >> op_ofile
    print date_time, record_number, program_version, $30, $31, $32, $33,
	$34 >> op_a_ofile
    print date_time, record_number, program_version, $39, $35, $36, $37,
	$38 >> op_sh_ofile
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# ec4db.awk ends here
