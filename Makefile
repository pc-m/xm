# XiVO paths
ASTERISK_PATH=$(XIVO_PATH)/asterisk11
AGI_PATH=$(XIVO_PATH)/xivo-agid
CTI_PATH=$(XIVO_PATH)/xivo-ctid
DOC_PATH=$(XIVO_PATH)/xivo-doc
LIB_PYTHON_PATH=$(XIVO_PATH)/xivo-lib-python
SCCP_PATH=$(XIVO_PATH)/xivo-libsccp

# PYTHONPATHS
LIB_PYTHON_PP=$(LIB_PYTHON_PATH)/xivo-lib-python
XIVO_DAO_PYTHONPATH=$(XIVO_PATH)/xivo-dao/xivo-dao
XIVO_DIRD_PYTHONPATH=$(XIVO_PATH)/xivo-dird/xivo-dird
XIVO_AGENT_PYTHONPATH=$(XIVO_PATH)/xivo-agent/xivo-agent
XIVO_PROVD_PYTHONPATH=$(XIVO_PATH)/xivo-provisioning/xivo-provisioning/src
CTI_PP=$(CTI_PATH)/xivo-ctid

XIVO_PYTHONPATH=$(LIB_PYTHON_PP):$(XIVO_DAO_PYTHONPATH):$(XIVO_DIRD_PYTHONPATH):$(XIVO_AGENT_PYTHONPATH):$(XIVO_PROVD_PYTHONPATH):$(CTI_PP)

# Local paths
AGI_LOCAL_PATH=$(AGI_PATH)/xivo-agid/xivo_agid
ASTERISK_LOCAL_PATH=$(shell /usr/bin/dirname $(shell /usr/bin/find $(ASTERISK_PATH) -name 'BUGS'))
CTI_LOCAL_PATH=$(CTI_PATH)/xivo-ctid/xivo_cti
LIB_PYTHON_LOCAL_PATH=$(LIB_PYTHON_PATH)/xivo-lib-python/xivo
XIVO_DAO_LOCAL_PATH=$(XIVO_DAO_PYTHONPATH)/xivo_dao
SCCP_LOCAL_PATH=$(XIVO_PATH)/xivo-libsccp
WEBI_LOCAL_PATH=$(XIVO_PATH)/xivo-web-interface/xivo-web-interface/src/
STARTING_DIR=$(CURDIR)

# Remote paths
PYTHON_PACKAGES=/usr/lib/pymodules/python2.6
WEBI_REMOTE_PATH=/usr/share/xivo-web-interface

# Tags
CTI_TAGS=$(CTI_PATH)/TAGS
AGI_TAGS=$(AGI_PATH)/TAGS
SCCP_TAGS=$(SCCP_PATH)/TAGS

SCCP_CSCOPE_FILES=$(SCCP_PATH)/cscope.files

# Commands
SYNC=rsync -vrtlp --filter '- *.pyc' --filter '- *.git' --filter '- *~'
XIVO_LIBSCCP_BUILDH=./build-tools/buildh
XIVO_LIBSCCP_DEP_COMMAND='apt-get update && apt-get install build-essential autoconf automake libtool asterisk-dev'

# xivo-web-interface
.PHONY : webi.sync
webi.sync:
	$(SYNC) $(WEBI_LOCAL_PATH) $(XIVO_HOSTNAME):$(WEBI_REMOTE_PATH)

# xivo-agid
.PHONY : agi.sync
agi.sync:
	$(SYNC) $(AGI_LOCAL_PATH) $(XIVO_HOSTNAME):$(PYTHON_PACKAGES)
	ssh $(XIVO_HOSTNAME) '/etc/init.d/xivo-agid restart'

agi.unittest:
.PHONY : agi.unittest
ifdef TARGET_FILE
	PYTHONPATH=$(XIVO_PYTHONPATH) nosetests $(TARGET_FILE)
else
	PYTHONPATH=$(XIVO_PYTHONPATH) nosetests $(AGI_LOCAL_PATH)
endif

.PHONY : agi.ctags
agi.ctags:
	rm -f $(AGI_TAGS)
	ctags -o $(AGI_TAGS) -R -e $(AGI_LOCAL_PATH)

# xivo-ctid
.PHONY : cti.unittest
cti.unittest:
ifdef TARGET_FILE
	PYTHONPATH=$(XIVO_PYTHONPATH) nosetests $(TARGET_FILE)
else
	PYTHONPATH=$(XIVO_PYTHONPATH) nosetests $(CTI_LOCAL_PATH)
endif

.PHONY : cti.sync
cti.sync:
	$(SYNC) $(CTI_LOCAL_PATH) $(XIVO_HOSTNAME):$(PYTHON_PACKAGES)
	ssh $(XIVO_HOSTNAME) '/etc/init.d/xivo-ctid restart'

.PHONY : cti.ctags
cti.ctags:
	rm -f $(CTI_TAGS)
	ctags -o $(CTI_TAGS) -R -e $(CTI_LOCAL_PATH)
	ctags -o $(CTI_TAGS) -R -e -a $(XIVO_DAO_LOCAL_PATH)
	ctags -o $(CTI_TAGS) -R -e -a $(LIB_PYTHON_LOCAL_PATH)

# xivo-doc
.PHONY : doc.build
doc.build:
	cd $(DOC_PATH) && make html

.PHONY : doc.clean
doc.clean:
	cd $(DOC_PATH) && make clean

# xivo-libsccp
.PHONY : sccp.sync
sccp.sync:
	cd $(SCCP_LOCAL_PATH)/xivo-libsccp && $(XIVO_LIBSCCP_BUILDH) makei

.PHONY : sccp.dep
sccp.dep:
	ssh $(XIVO_HOSTNAME) $(XIVO_LIBSCCP_DEP_COMMAND)

.PHONY : sccp.setup
sccp.setup:
	cd $(SCCP_LOCAL_PATH)/xivo-libsccp && $(XIVO_LIBSCCP_BUILDH) init

.PHONY : sccp.ctags
sccp.ctags:
	rm -f $(SCCP_TAGS)
	ctags -o $(SCCP_TAGS) -R -e $(SCCP_LOCAL_PATH)
	ctags -o $(SCCP_TAGS) -R -e -a $(ASTERISK_LOCAL_PATH)

.PHONY : sccp.cscope
sccp.cscope:
	rm -f $(SCCP_CSCOPE_FILES)
	find $(SCCP_LOCAL_PATH) -name "*.c" -o -name "*.h" > $(SCCP_CSCOPE_FILES)
	find $(ASTERISK_LOCAL_PATH) -name "*.c" -o -name "*.h" >> $(SCCP_CSCOPE_FILES)
