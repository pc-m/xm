from configparser import ExtendedInterpolation
from configparser import SafeConfigParser
from itertools import ifilter
from os import path


_PROJECT_SECTION_PREFIX = 'projects'
_PROJECT_SECTION_SEPARATOR = '.'


class ConfigFileParser(object):

    def __init__(self, file_like_content):
        self._config = SafeConfigParser(interpolation=ExtendedInterpolation())
        self._config.readfp(file_like_content)

    def project_names(self):
        for section in ifilter(_is_valid_project_section_name, self._config.sections()):
            yield section.partition(_PROJECT_SECTION_SEPARATOR)[2]

    def project(self, project_name):
        section = '%s%s%s' % (_PROJECT_SECTION_PREFIX, _PROJECT_SECTION_SEPARATOR, project_name)
        return dict((key, self._get(section, key)) for key in self._config.options(section))

    def _get(self, section, key):
        return path.expanduser(self._config.get(section, key))


def _is_valid_project_section_name(section):
    prefix, _, name = section.partition(_PROJECT_SECTION_SEPARATOR)
    return prefix == _PROJECT_SECTION_PREFIX and name
