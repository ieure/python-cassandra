# -*- coding: utf-8 -*-
#
# © 2009, 2010 Digg, Inc. All rights reserved.
# Author: Ian Eure <ian@digg.com>
#

from setuptools import setup, find_packages

setup(name="python-cassandra",
      version='0.5.0',
      description="Thrift client for Cassandra",
      url="http://incubator.apache.org/cassandra/",
      packages=find_packages(exclude=['ez_setup', 'examples', 'tests']),
      include_package_data=True,
      author="Ian Eure",
      author_email="ian.eure@gmail.com",
      scripts=['scripts/Cassandra-remote'],
      keywords="database cassandra",
      install_requires=['Thrift'])
