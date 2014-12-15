Boxes Server
============

[![Build Status](https://travis-ci.org/beraboris/boxes_server.svg?branch=master)](https://travis-ci.org/beraboris/boxes_server)

Boxes server is the server component of a collaborative drawing application. 

Boxes server is made up of multiple components. It contains: daemons, gems, web services & utilities.

The daemons and web services are packaged as [Docker](https://www.docker.com/) images.

The gems and utilities are packaged as standard Ruby gems.

Dependencies
============

To run this project you will need:

- linux
- docker 1.3.1

To build this project you will need:

- linux
- docker 1.3.1
- ruby 2.3.1
- Image Magick

Installing the ruby dependencies can be done as follows:

    # install bundler
    $ gem install bundler
    
    # install dependencies
    $ rake bundle:install

Building
========

Once you have the ruby dependencies installed, you can build the docker images with:

    $ rake docker:build
    
When run for the first time, this may take some time, since docker needs to download a bunch of images.

Running the Services
====================

To run the services, you first need to start Rabbit MQ and MongoDB

    $ rake rabbitmq:start mongodb:start

When run for the first time, this may take some time since docker needs to download the Rabbit MQ and MongoDB images.

If this fails, you can try:

    $ rake rabbitmq:restart mongodb:restart

Once Rabbit MQ and MongoDB are running, you can start the services with:

    $ rake docker:run
    
You will need to know the ports used by the drive through and gallery services when using the android app. This can be
found using:

    $ docker ps

Example output:

    CONTAINER ID        IMAGE                      COMMAND                CREATED              STATUS              PORTS                                              NAMES
    067f8e073492        boxes/gallery:1.0.0        "/sbin/my_init"        11 seconds ago       Up 7 seconds        0.0.0.0:49155->443/tcp, 0.0.0.0:49156->80/tcp      backstabbing_leakey        
    7bc7639c7562        boxes/clerk:0.0.1          "/bin/sh -c 'bundle    20 seconds ago       Up 11 seconds                                                          berserk_ritchie            
    a54612a921e4        boxes/gluegun:1.1.0        "/bin/sh -c 'bundle    26 seconds ago       Up 20 seconds                                                          high_colden                
    e01de87fd02f        boxes/forklift:1.1.0       "/bin/sh -c 'bundle    32 seconds ago       Up 27 seconds                                                          jolly_fermi                
    aaf1ad09a3e7        boxes/scalpel:1.1.0        "/bin/sh -c 'bundle    44 seconds ago       Up 33 seconds                                                          compassionate_mcclintock   
    b5f5b1758890        boxes/drivethrough:1.0.0   "/sbin/my_init"        51 seconds ago       Up 47 seconds       0.0.0.0:49153->443/tcp, 0.0.0.0:49154->80/tcp      tender_mccarthy            
    2ceeed8bd11a        mongo:2.6.5                "/entrypoint.sh --sm   About a minute ago   Up About a minute   0.0.0.0:27017->27017/tcp                           mongodb                    
    ba93090bd078        tutum/rabbitmq:latest      "/run.sh"              About a minute ago   Up About a minute   0.0.0.0:5672->5672/tcp, 0.0.0.0:15672->15672/tcp   rabbitmq 

Line 2 shows information about the gallery. `0.0.0.0:49156->80/tcp` means that it's running on port 49156.
Line 7 shows information about the drive through. `0.0.0.0:49154->80/tcp` means that it's running on port 49154.

Ingesting Pictures
==================

Ingesting pictures is done through the admin module. This can be done as follows:

    $ cd admin
    $ bundle exec ./bin/boxesctl ingest --mq_url 'amqp://boxes:boxes@localhost' path/to/image.png <rows> <columns>
    
`<row>` and `<columns>` are the number of rows and columns to split the image into.

Example:

    $ cd admin
    $ bundle exec ./bin/boxesctl ingest --mq_url 'amqp://boxes:boxes@localhost' ../features/images/mccoy.jpg 2 1

Stopping the services
=====================

You can stop all the services with:

    $ docker stop `docker ps -q`

Note that this is a rather crude way of stopping the services since it'll stop all running docker containers.

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
