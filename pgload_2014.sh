#! /bin/sh
# $Id$
# Author: Sebastian Luque
# Created: 2014-02-05T22:44:42+0000
# Last-Updated: 2014-09-23T21:43:40+0000
#           By: Sebastian P. Luque
# -------------------------------------------------------------------------
# Commentary: 
#
# This script is for preparing and loading data onto database, using
# pgloader.
# -------------------------------------------------------------------------
# Code:

# # Prepare data
# ./tables4db.sh

# Load tables
pgloader -c pgloader_gases_2014.ini -v -s navigation_omg_series
# pgloader -c pgloader_gases_2014.ini -v -s -V navigation_ceos_series
# pgloader -c pgloader_gases_2014.ini -v -s -V navigation_ceos_motion_series
# pgloader -c pgloader_gases_2014.ini -v -s meteorology_series
# pgloader -c pgloader_gases_2014.ini -v -s meteorology_logger_series
# pgloader -c pgloader_gases_2014.ini -v -s meteorology_closed_path_series
# pgloader -c pgloader_gases_2014.ini -v -s -V open_path_series_1_avg
# pgloader -c pgloader_gases_2014.ini -v -s -V open_path_series_2_avg
# pgloader -c pgloader_gases_2014.ini -v -s -V wind3d_series_analog_avg
# pgloader -c pgloader_gases_2014.ini -v -s -V wind3d_series_sdm_avg
# pgloader -c pgloader_gases_2014.ini -v -s underway_series
# pgloader -c pgloader_gases_2014.ini -v -s radiation_series
# pgloader -c pgloader_gases_2014.ini -v -s radiation_logger_series
# pgloader -c pgloader_gases_2014.ini -v -s -V open_path_series_main_A
# pgloader -c pgloader_gases_2014.ini -v -s -V open_path_series_main_B
# pgloader -c pgloader_gases_2014.ini -v -s -V open_path_series_aux_A
# pgloader -c pgloader_gases_2014.ini -v -s -V open_path_series_aux_B
# pgloader -c pgloader_gases_2014.ini -v -s -V motion_series_A
# pgloader -c pgloader_gases_2014.ini -v -s -V motion_series_B
# pgloader -c pgloader_gases_2014.ini -v -s -V wind3d_series_analog_A
# pgloader -c pgloader_gases_2014.ini -v -s -V wind3d_series_analog_B
# pgloader -c pgloader_gases_2014.ini -v -s -V wind3d_series_serial_A
# pgloader -c pgloader_gases_2014.ini -v -s -V wind3d_series_serial_B
# pgloader -c pgloader_gases_2014.ini -v -s -V wind3d_series_sdm_A
# pgloader -c pgloader_gases_2014.ini -v -s -V wind3d_series_sdm_B
# # Or all sections, if sure
# pgloader -c pgloader_gases_2014.ini -v -s -V


#_* Emacs local variables
# Local variables:
# allout-layout: (1 + : 0)
# End:
# 
# pgload_2014.sh ends here
