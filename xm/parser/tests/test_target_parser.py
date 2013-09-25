import argparse
import os
import unittest

from hamcrest import assert_that
from hamcrest import equal_to
from mock import patch
from xm.parser.target_parser import TargetParser
from xm import settings


class TestTargetParser(unittest.TestCase):

    def setUp(self):
        self._target = 'cti'
        self._cti_path = '/dev/xivo_cti'
        settings.projects = {self._target: {'path': self._cti_path}}

    def test_non_empty_target(self):
        parsed_args = argparse.Namespace(target=self._target)

        t = TargetParser(parsed_args)

        assert_that(t.target(), equal_to(self._target), 'Parsed target')

    @patch('os.getcwd')
    def test_empty_target(self, mock_getcwd):
        parsed_args = argparse.Namespace(target=None)
        mock_getcwd.return_value = self._cti_path + os.path.sep + 'subdir'

        t = TargetParser(parsed_args)

        assert_that(t.target(), equal_to(self._target), 'Path based target')
