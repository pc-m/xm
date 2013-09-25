from os import path


class ConfigFileNameParser(object):
    """
    The ConfigFileNameParser class reads the input from the parsed args
    and finds the full path of the configuration file
    """

    def __init__(self, parsed_args):
        self._filename = parsed_args.file

    def file(self):
        return path.expanduser(self._filename)
