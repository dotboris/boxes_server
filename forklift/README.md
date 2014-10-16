Forklift
========

Forklift is a daemon. Upon request, it loads a random split image and sets it up so that it can be redrawn and 
reassembled.

Requests come in through the message queue (rabbitmq). The split images are loaded from the file system. The split 
images are produced by the scalpel daemon.
