#!/usr/bin/env python2
# -*- coding: UTF-8 -*-

from __future__ import print_function
from __future__ import unicode_literals

import argparse


DEFAULT_CONFIG_FILE = '~/.config/xmrc'


def _new_argument_parser():
    parser = argparse.ArgumentParser(
        description='Build the appropriate make command'
    )

    parser.add_argument(
        '-u', '--unittest', help='run unittest',
        action='store_const', const=True, default=False,
    )
    parser.add_argument(
        '-s', '--sync', help='sync local copy on the server',
        action='store_const', const=True, default=False,
    )
    parser.add_argument(
        '-f', '--file', help='specify the configuration file',
        default=DEFAULT_CONFIG_FILE,
    )
    parser.add_argument(
        '--setup', help='run commands that should be run before sync',
        action='store_const', const=True, default=False,
    )
    parser.add_argument(
        '-d', '--dep', help='install missing dependencies on the server',
        action='store_const', const=True, default=False,
    )
    parser.add_argument(
        'project', metavar='project', type=str, nargs='+',
        help='The selected project',
    )

    return parser


def main():
    parsed_args = _new_argument_parser().parse_args()
    print(parsed_args)


if __name__ == '__main__':
    main()
