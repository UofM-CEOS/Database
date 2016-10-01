#! /usr/bin/env python
# pylint: disable=too-many-locals,invalid-name,no-member

"""Small utility to regenerate erroneous timestamps on data.

It takes a path to a file, or standard input, containing comma-separated
data with erroneous timestamp, and regenerates the timestamps correctly,
using a given time step.

Usage
-----

For help on using this module/script, type:

regenerate_timestamps.py -h

at the command line.

"""

import sys
from datetime import datetime, timedelta
import argparse as ap
import csv

__version__ = "0.1.0"

def main(data_file, start, delta, time_field, nskip):
    """Read data file and perform timestamp regeneration.

    See parser help for description of arguments.  All arguments are
    coerced to string during execution.
    """
    beg = datetime(start[0], start[1], start[2], start[3], start[4],
                   start[5], start[6])
    tdelta = timedelta(microseconds=delta)
    with data_file as f:
        freader = csv.reader(f)
        nlines = 0
        for line in freader:
            nlines += 1
            while nlines <= nskip:
                nlines += 1
                continue
            if nlines == nskip + 1:
                tstamp = beg
                print(",".join(line))
                continue
            else:
                tstamp = tstamp + tdelta
            tstampstr = tstamp.strftime("%Y-%m-%d %H:%M:%S.%f")[:-5]
            line[time_field] = "\"{0}\"".format(tstampstr)
            print(",".join(line))


if __name__ == "__main__":
    description = "Fix erroneous timestamp on comma-separated data file."
    parser = ap.ArgumentParser(description=description,
                               formatter_class=ap.ArgumentDefaultsHelpFormatter)
    group = parser.add_argument_group("required arguments")
    parser.add_argument("data_file", metavar="data-file",
                        type=ap.FileType("r"), default=sys.stdin,
                        help="Path to file containing comma-separated data.")
    group.add_argument("-s", "--start", nargs=7, type=int, required=True,
                       metavar=("year", "month", "day", "hour", "minute",
                                "seconds", "microseconds"),
                       help=("Timestamp to start the time series at."))
    parser.add_argument("-d", "--delta", type=int, default=100000,
                        help=("Delta time step to generate new timestamps at. "
                              "Negative delta results in decreasing time "
                              "series. Units are microseconds."))
    parser.add_argument("-t", "--time-field", type=int, default=0,
                        help=("Field number (origin 0) where erroneous "
                              "timestamp is found."))
    parser.add_argument("-f", "--time-format",
                        default="\"%Y-%m-%d %H:%M:%S.%f\"",
                        help=("Format string for input and output of time "
                              "field, as expected by strptime/strftime."))
    parser.add_argument("-n", "--nskip", type=int, default=0,
                        help=("Number of rows to skip from beginning."))
    parser.add_argument("--version", action="version",
                        version="%(prog)s {}".format(__version__))
    args = parser.parse_args()
    main(args.data_file, start=args.start, delta=args.delta,
         time_field=args.time_field, nskip=args.nskip)
