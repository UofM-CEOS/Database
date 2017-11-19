#! /usr/bin/gawk -f
# Author: Sebastian Luque
# Created: 2014-02-10T23:24:53+0000
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
# % Cruise_Number: Amundsen_2016001
# % Start_Date_Time [UTC]: 03-Jun-2016 23:22:32
# % Initial_Latitude [deg]: 47.3338
# % Initial_Longitude [deg]: -70.4957
# % End_Date_Time [UTC]: 03-Jun-2016 23:48:08
# % Final_Latitude [deg]: 47.4347
# % Final_Longitude [deg]: -70.3764
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
# % Depth: Bottom depth [m]
# % GPS: GPS source [=1 for POS-MV and =0 for CNAV]
#
#       Date     Hour          Lat         Long    Heading       Roll      Pitch      Heave      Track      Speed      Depth        GPS
#    -------  -------      -------      -------    -------    -------    -------    -------    -------    -------    -------    -------
# 2016/06/03 23:22:32   47.3338217  -70.4956867        NaN        NaN        NaN        NaN      27.70      18.03       21.1          0
# 2016/06/03 23:22:33   47.3338950  -70.4956300        NaN        NaN        NaN        NaN      27.50      18.04       21.5          0
# 2016/06/03 23:22:34   47.3339700  -70.4955733        NaN        NaN        NaN        NaN      27.20      18.03       21.3          0
# 2016/06/03 23:22:35   47.3340433  -70.4955183        NaN        NaN        NaN        NaN      26.90      18.02       21.3          0
# 2016/06/03 23:22:36   47.3341183  -70.4954633        NaN        NaN        NaN        NaN      26.50      18.01       21.2          0
#
# Example call (file written in current directory):
#
# /.nav_proc4db.awk -v skip=23 *.dat > NAV_all.csv
# -------------------------------------------------------------------------
# Code:

BEGIN {
    OFS=","
    print "time,latitude,longitude,heading,roll,pitch,heave",
	"course_over_ground,speed_over_ground,bottom_depth,is_POSMV"
}

FNR > skip {
    gsub(/\//, "-", $1)
    printf "%s %s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n", $1, $2, $3, $4, $5, $6,
	$7, $8, $9, $10, $11, $12
}



##_ + Emacs Local Variables
# Local variables:
# allout-layout: (-2 + : 0)
# End:
