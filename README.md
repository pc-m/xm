# xm

## Overview

xm is a simple command line tool I use to do various actions when working on XiVO
on a remote server.

This tool is 100% XiVO specific.


## Usage

xm is made of a single make file allowing some operations on specific repositories.


### Running xivo-ctid unit-tests

> make -f <path/to/xm>/Makefile cti.unittest XIVO_PATH=<path/to/xivo/source/code> [TARGET_FILE=<file>]

If the TARGET_FILE argument is supplied, the test runner will be run on the specified file
or directory only.


### Syncing to local copy of xivo-ctid to a remote XiVO

> make -f <path/to/xm>/Makefile cti.sync XIVO_PATH=<path/to/xivo/source/code> XIVO_HOSTNAME=<hostname>


## Future plan

This syntax is not very easy to use. In the near future, I plan to add a launcher that will
read a configuration file and launcher the appropriate make target with the configured values
from the configuration file.
