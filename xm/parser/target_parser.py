import os

from xm import settings


class TargetParser(object):
    """
    The TargetParser class reads the input from the parsed args
    and tries to find a matching target based on the current working
    directory if no target was supplied
    """

    def __init__(self, parsed_args):
        self._target = parsed_args.target
        if not self._target:
            self._target = self._find_target_based_on_dir()

    def target(self):
        return self._target

    def _find_target_based_on_dir(self):
        current_dir = os.getcwd()

        for project_name, project_properties in settings.projects.iteritems():
            if project_properties.get('path', '') in current_dir:
                return project_name

        return None
