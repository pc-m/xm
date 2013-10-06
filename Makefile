# XiVO paths
CTI_PATH=$(XIVO_PATH)/xivo-ctid

# PYTHONPATHS
XIVO_LIB_PYTHON_PYTHONPATH=$(XIVO_PATH)/xivo-lib-python/xivo-lib-python
XIVO_DAO_PYTHONPATH=$(XIVO_PATH)/xivo-dao/xivo-dao
XIVO_DIRD_PYTHONPATH=$(XIVO_PATH)/xivo-dird/xivo-dird
XIVO_AGENT_PYTHONPATH=$(XIVO_PATH)/xivo-agent/xivo-agent
XIVO_PROVD_PYTHONPATH=$(XIVO_PATH)/xivo-provisioning/xivo-provisioning/src
CTI_PP=$(CTI_PATH)/xivo-ctid

XIVO_PYTHONPATH=$(XIVO_LIB_PYTHON_PYTHONPATH):$(XIVO_DAO_PYTHONPATH):$(XIVO_DIRD_PYTHONPATH):$(XIVO_AGENT_PYTHONPATH):$(XIVO_PROVD_PYTHONPATH):$(CTI_PP)

# Local paths
CTI_LOCAL_PATH=$(CTI_PATH)/xivo-ctid/xivo_cti
XIVO_DAO_LOCAL_PATH=$(XIVO_DAO_PYTHONPATH)/xivo_dao
XIVO_LIBSCCP_LOCAL_PATH=$(XIVO_PATH)/xivo-libsccp
STARTING_DIR=$(CURDIR)

# Remote paths
PYTHON_PACKAGES=/usr/lib/pymodules/python2.6

# Tags
CTI_TAGS=$(CTI_PATH)/TAGS

# Commands
SYNC=rsync -vrtlp
XIVO_LIBSCCP_BUILDH=./build-tools/buildh
XIVO_LIBSCCP_DEP_COMMAND='apt-get update && apt-get install build-essential autoconf automake libtool asterisk-dev'

# xivo-ctid
cti.unittest:
ifdef TARGET_FILE
	PYTHONPATH=$(XIVO_PYTHONPATH) nosetests $(TARGET_FILE)
else
	PYTHONPATH=$(XIVO_PYTHONPATH) nosetests $(CTI_LOCAL_PATH)
endif

cti.sync:
	$(SYNC) $(CTI_LOCAL_PATH) $(XIVO_HOSTNAME):$(PYTHON_PACKAGES)
	ssh $(XIVO_HOSTNAME) '/etc/init.d/xivo-ctid restart'

cti.ctags:
	rm -f $(CTI_TAGS)
	ctags -o $(CTI_TAGS) -R -e $(CTI_LOCAL_PATH)
	ctags -o $(CTI_TAGS) -R -e -a $(XIVO_DAO_LOCAL_PATH)

# xivo-libsccp
sccp.sync:
	cd $(XIVO_LIBSCCP_LOCAL_PATH)/xivo-libsccp && $(XIVO_LIBSCCP_BUILDH) makei

sccp.dep:
	ssh $(XIVO_HOSTNAME) $(XIVO_LIBSCCP_DEP_COMMAND)

sccp.setup:
	cd $(XIVO_LIBSCCP_LOCAL_PATH)/xivo-libsccp && $(XIVO_LIBSCCP_BUILDH) init
