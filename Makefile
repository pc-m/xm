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

# Remote paths
PYTHON_PACKAGES=/usr/lib/pymodules/python2.6

# Commands
SYNC=rsync -vrtlp

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
