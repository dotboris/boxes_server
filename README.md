Boxes Server
============

[![Build Status](https://travis-ci.org/beraboris/boxes_server.svg?branch=master)](https://travis-ci.org/beraboris/boxes_server)

Boxes server is the server component of a collaborative drawing application. 

Boxes server is made up of multiple components. It contains: daemons, gems, web services & utilities.

The daemons and web services are packaged as [Docker](https://www.docker.com/) images.

The gems and utilities are packaged as standard Ruby gems.

Running the tests
=================

There are two sets of tests available: Unit tests (rspec) and functional tests (cucumber). The unit tests have no
special requirements and should run anywhere. The functional tests require you to have a running Rabbit MQ instance.

The functional tests assume the following:

- Rabbit MQ is listening on `localhost:5672`
- There is a user named `boxes` (password: `boxes`)
- There is a vhost named `/` (the default vhost)
- The `boxes` user has all the rights on `/`

If you are using docker and don't want to bother with all that, just run:

    $ rake rabbitmq:start
    
This will start a Rabbit MQ container with all ports mapped to the host.
