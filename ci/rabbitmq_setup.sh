#!/bin/sh
# sets up rabbit mq in travis ci environment
# heavily inspired from https://github.com/ruby-amqp/bunny/blob/master/bin/ci/before_build.sh

${RABBITMQ_NODENAME:="rabbit"}
${RABBITMQCTL:="sudo rabbitmqctl -n $RABBITMQ_NODENAME"}

# boxes:boxes has full access to /
${RABBITMQCTL} add_vhost /
${RABBITMQCTL} add_user boxes boxes
${RABBITMQCTL} set_permissions -p / boxes ".*" ".*" ".*"
