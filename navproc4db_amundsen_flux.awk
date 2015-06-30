#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-02-10T23:24:53+0000
# Last-Updated: 2015-06-23T16:54:43+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
# 
# See the pgloader configuration file for details.
#
# This prepares the processed NAV files (ship POSMV and GPS) for loading
# into database.
#
# Input has following structure:
#
# % Cruise_Number: Amundsen_2010001
# % Start_Date_Time [UTC]: 02-Jul-2010 19:23:56
# % Initial_Latitude [deg]: 46.8093
# % Initial_Longitude [deg]: -71.2022
# % End_Date_Time [UTC]: 02-Jul-2010 23:59:58
# % Final_Latitude [deg]: 47.4688
# % Final_Longitude [deg]: -70.2171
# %
# % Date: Acquisition date [yyyymmdd]
# % Hour: Acquisition hour [HHMMSS]
# % lat: Latidude [degrees N]
# % long: Longitude [degrees E]
# % Heading: Vessel heading [degrees N]
# % Roll: Vessel roll [degrees N]
# % Pitch: Vessel pitch [degrees N]
# % Heave: Vessel heave [meter]
# % Track: Vessel true direction [degrees N]
# % Speed: Vessel true speed [Knt]
# % GPS: GPS source [=1 for POS-MV and =0 for CNAV]
#
#       Date     Hour          Lat         Long    Heading       Roll      Pitch      Heave      Track      Speed        GPS
#    -------  -------      -------      -------    -------    -------    -------    -------    -------    -------    -------
# 2010/07/02 19:23:56   46.8093273  -71.2021983        NaN        NaN        NaN        NaN     243.40       0.01          0
# 2010/07/02 19:23:57   46.8093275  -71.2021985        NaN        NaN        NaN        NaN     270.00       0.00          0
# 2010/07/02 19:23:58   46.8093275  -71.2021985        NaN        NaN        NaN        NaN     149.00       0.01          0
# 2010/07/02 19:23:59   46.8093273  -71.2021983        NaN        NaN        NaN        NaN     113.20       0.02          0
# 2010/07/02 19:24:00   46.8093273  -71.2021983        NaN        NaN        NaN        NaN      90.00       0.02          0
# 
# Example call (file written in current directory):
#
# /.navproc4db.awk *.dat > NAV_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    OFS=","
    print "time,latitude,longitude,heading,roll,pitch,heave",
	"course_over_ground,speed_over_ground,is_POSMV"
}

FNR > 22 {
    gsub(/\//, "-", $1)
    printf "%s %s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5, $6,
	$7, $8, $9, $10, $11
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
# 
# nav4db.awk ends here
