from xm.parser.config_file_parser import ConfigFileParser


projects = {}

def init_from_file(filename):
    with open(filename) as f:
        config = ConfigFileParser(f)
    for name in config.project_names():
        setting = config.project(name)
        projects[name] = setting
