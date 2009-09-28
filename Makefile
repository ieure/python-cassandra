SRCDIR    = cassandra
GENDIR    = tmp
SCRIPTDIR = scripts
INTERFACE = https://svn.apache.org/repos/asf/incubator/cassandra/trunk/interface/cassandra.thrift

all: $(SRCDIR) $(SCRIPTDIR)/Cassandra-remote

egg: all
	python setup.py bdist_egg

sdist: all
	python setup.py sdist

$(SRCDIR)/Cassandra-remote: $(SRCDIR)
$(SRCDIR): $(GENDIR)/gen-py
	mkdir -p $@
	cp -R $^/cassandra/* $@

$(SCRIPTDIR)/Cassandra-remote: $(SRCDIR)/Cassandra-remote
	mkdir -p $(SCRIPTDIR)
	sed -e s/'import Cassandra'/'from cassandra import Cassandra'/ \
		-e s/'from ttypes import '/'from cassandra.ttypes import '/ \
		< $^ > $@
	chmod --reference $^ $@

$(GENDIR)/gen-py: cassandra.thrift
	-mkdir -p $(GENDIR)
	thrift -o $(GENDIR) -gen py:new_style=True  $^

update:
	@echo "Updating to: $(shell svn info $(INTERFACE) | grep ^Last\ Changed\ Rev | cut -d: -f2)"
	svn cat $(INTERFACE) > $(shell basename $(INTERFACE))

clean:
	rm -rf $(GENDIR) $(SRCDIR) $(SCRIPTDIR) gen-* build dist *.egg-info
