#! /bin/sh
# $Id: $
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2014-09-23T21:43:30+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
# 
# -------------------------------------------------------------------------
# Code:

pgloader -c pgloader_gases_2013.ini -v -s underway_series
pgloader -c pgloader_gases_2013.ini -v -s radiation_series
pgloader -c pgloader_gases_2013.ini -v -s radiation_logger_series
pgloader -c pgloader_gases_2013.ini -v -s meteorology_series
pgloader -c pgloader_gases_2013.ini -v -s meteorology_logger_series
pgloader -c pgloader_gases_2013.ini -v -s meteorology_nav_series
pgloader -c pgloader_gases_2013.ini -v -s meteorology_closed_path_series
pgloader -c pgloader_gases_2013.ini -v -s meteorology_radiation_series
pgloader -c pgloader_gases_2013.ini -v -s navigation_ceos_series
pgloader -c pgloader_gases_2013.ini -v -s navigation_ceos_motion_series
pgloader -c pgloader_gases_2013.ini -v -s -V navigation_omg_series
pgloader -c pgloader_gases_2013.ini -v -s -V open_path_series_main
pgloader -c pgloader_gases_2013.ini -v -s -V open_path_series_aux
pgloader -c pgloader_gases_2013.ini -v -s -V open_path_series_shrouded
pgloader -c pgloader_gases_2013.ini -v -s -V motion_series
pgloader -c pgloader_gases_2013.ini -v -s -V wind3d_series_analog
pgloader -c pgloader_gases_2013.ini -v -s -V wind3d_series_serial



#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
# 
# pgload_2013.sh ends here
