import argparse
import unittest

from hamcrest import assert_that
from hamcrest import equal_to
from mock import patch
from xm.parser import config_file_name_parser


class TestConfigFileNameParser(unittest.TestCase):

    def setUp(self):
        self._filename = '~/.xmrc'
        self._full_path = '/home/me/.xmrc'

    @patch('os.path.expanduser')
    def test_file(self, mock_expand_user):
        mock_expand_user.return_value = self._full_path
        parsed_args = argparse.Namespace(file=self._filename)

        c = config_file_name_parser.ConfigFileNameParser(parsed_args)

        assert_that(c.file(), equal_to(self._full_path), 'Parsed file name')
