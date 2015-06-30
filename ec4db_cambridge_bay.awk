#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-09-18T21:06:43+0000
# Last-Updated: 2015-06-30T18:45:39+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# This is used to produce several files to be loaded onto database, which
# combines the data from the project.
#
# Example call (output written to current directory):
#
# ec4db_cambridge_bay_2014.awk *.dat
# -------------------------------------------------------------------------
# Code:

BEGIN {
    FS=OFS=","
    ec_dir="/home/sluque/Data/Cambridge_Bay/2014/EC"
    ncols=19
    wind_ofile=ec_dir "/wind.csv"
    op_ofile=ec_dir "/open_path.csv"
    print "time,record_number,program_version,wind_speed_u,wind_speed_v",
	"wind_speed_w,air_temperature_sonic,anemometer_status" > wind_ofile
    print "time,record_number,program_version",
    	"op_CO2_density,op_H2O_density,op_CO2_absorptance,op_H2O_absorptance",
    	"op_pressure,op_temperature,op_aux,op_cooler_voltage",
	"op_analyzer_status,op_bandwidth,op_delay_interval" > op_ofile
}

FNR > 4 {
    gsub(/"/, "")
    date_time=$1
    record_number=$2
    program_version=sprintf("%.1f", $3)
    # Convert 1.0 to 1.4 (this was a logger program error)
    if (program_version == "1.0") program_version="1.4"
    print date_time, record_number, program_version, $4, $5, $6, $7,
    	$8 >> wind_ofile
    printf "%s,%s,%s,", date_time, record_number,
	program_version >> op_ofile
    for (i=9; i <= (ncols - 1); i++) { printf "%s,", $i >> op_ofile }
    print $ncols >> op_ofile
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
