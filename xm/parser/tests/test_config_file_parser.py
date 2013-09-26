import io
import unittest

from hamcrest import assert_that
from hamcrest import equal_to
from mock import patch
from xm.parser import config_file_parser


class TestConfigFileParser(unittest.TestCase):

    def setUp(self):
        self._content = """
[default]
xivo_hostname=xivo-dev

[projects]
xivo_path=~/dev/xivo

[projects.cti]
path=${projects:xivo_path}/xivo-ctid

#invalid
[projects.]
"""
        self._p = config_file_parser.ConfigFileParser(io.BytesIO(self._content))

    def test_project_names(self):
        assert_that(list(self._p.project_names()), equal_to(['cti']))

    @patch('os.path.expanduser')
    def test_project(self, mock_expand_user):
        full_cti_path = '/home/dev/xivo/xivo-ctid'
        mock_expand_user.return_value = full_cti_path

        expected = {
            'path': full_cti_path,
        }

        assert_that(self._p.project('cti'), equal_to(expected))
        mock_expand_user.assert_called_once_with('~/dev/xivo/xivo-ctid')
