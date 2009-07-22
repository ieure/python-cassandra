all: egg

egg: src scripts/Cassandra-remote
	python setup.py bdist_egg

src/cassandra/Cassandra-remote: src
src: src/gen-py
	mv $^/* $@
	rmdir $^

scripts/Cassandra-remote: src/cassandra/Cassandra-remote
	mv $^ $@

src/gen-py: cassandra.thrift
	thrift -gen py -o $(shell dirname $@) $^

clean:
	rm -rf src/* scripts/Cassandra-remote build dist *.egg-info
