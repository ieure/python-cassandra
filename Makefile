SRCDIR    = cassandra
SCRIPTDIR = scripts
INTERFACE = https://svn.apache.org/repos/asf/incubator/cassandra/trunk/interface/cassandra.thrift

all: egg

egg: $(SRCDIR) scripts/Cassandra-remote
	python setup.py bdist_egg

$(SRCDIR)/Cassandra-remote: $(SRCDIR)
$(SRCDIR): $(SRCDIR)/gen-py
	mv $^/cassandra/* $@

scripts/Cassandra-remote: $(SRCDIR)/Cassandra-remote
	mkdir -p $(SCRIPTDIR)
	sed -e s/'import Cassandra'/'from cassandra import Cassandra'/ \
		-e s/'from ttypes import '/'from cassandra.ttypes import '/ \
		< $^ > $@
	chmod --reference $^ $@
	rm $^

$(SRCDIR)/gen-py: cassandra.thrift
	mkdir -p $(SRCDIR)
	thrift -o $(shell dirname $@) -gen py:new_style=True  $^

update:
	@echo "Updating to: $(shell svn info $(INTERFACE) | grep ^Last\ Changed\ Rev | cut -d: -f2)"
	svn cat $(INTERFACE) > $(shell basename $(INTERFACE))

clean:
	rm -rf $(SRCDIR) $(SCRIPTDIR) build dist *.egg-info
