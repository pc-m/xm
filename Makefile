# PYTHONPATHS
XIVO_LIB_PYTHON_PYTHONPATH=$(XIVO_PATH)/xivo-lib-python/xivo-lib-python
XIVO_DAO_PYTHONPATH=$(XIVO_PATH)/xivo-dao/xivo-dao
XIVO_DIRD_PYTHONPATH=$(XIVO_PATH)/xivo-dird/xivo-dird
XIVO_AGENT_PYTHONPATH=$(XIVO_PATH)/xivo-agent/xivo-agent
XIVO_PROVD_PYTHONPATH=$(XIVO_PATH)/xivo-provisioning/xivo-provisioning/src
XIVO_CTID_PYTHONPATH=$(XIVO_PATH)/xivo-ctid/xivo-ctid

XIVO_PYTHONPATH=$(XIVO_LIB_PYTHON_PYTHONPATH):$(XIVO_DAO_PYTHONPATH):$(XIVO_DIRD_PYTHONPATH):$(XIVO_AGENT_PYTHONPATH):$(XIVO_PROVD_PYTHONPATH):$(XIVO_CTID_PYTHONPATH)

# Local paths
XIVO_CTID_LOCAL_PATH=$(XIVO_CTID_PYTHONPATH)/xivo_cti
XIVO_DAO_LOCAL_PATH=$(XIVO_DAO_PYTHONPATH)/xivo_dao
XIVO_LIBSCCP_LOCAL_PATH=$(XIVO_PATH)/xivo-libsccp
STARTING_DIR=$(CURDIR)

# Remote paths
PYTHON_PACKAGES=/usr/lib/pymodules/python2.6

# Commands
SYNC=rsync -vrtlp
XIVO_LIBSCCP_BUILDH=./build-tools/buildh
XIVO_LIBSCCP_DEP_COMMAND='apt-get update && apt-get install build-essential autoconf automake libtool asterisk-dev'

# xivo-ctid
cti.unittest:
ifdef TARGET_FILE
	PYTHONPATH=$(XIVO_PYTHONPATH) nosetests $(TARGET_FILE)
else
	PYTHONPATH=$(XIVO_PYTHONPATH) nosetests $(XIVO_CTID_LOCAL_PATH)
endif

cti.sync:
	$(SYNC) $(XIVO_CTID_LOCAL_PATH) $(XIVO_HOSTNAME):$(PYTHON_PACKAGES)
	ssh $(XIVO_HOSTNAME) '/etc/init.d/xivo-ctid restart'

cti.ctags:
	ctags -R -e $(XIVO_CTID_LOCAL_PATH)
	ctags -R -e -a $(XIVO_DAO_LOCAL_PATH)

# xivo-libsccp
sccp.sync:
	cd $(XIVO_LIBSCCP_LOCAL_PATH)/xivo-libsccp && $(XIVO_LIBSCCP_BUILDH) makei

sccp.dep:
	ssh $(XIVO_HOSTNAME) $(XIVO_LIBSCCP_DEP_COMMAND)

sccp.setup:
	cd $(XIVO_LIBSCCP_LOCAL_PATH)/xivo-libsccp && $(XIVO_LIBSCCP_BUILDH) init
