FROM ruby:2.1.3

MAINTAINER Boris Bera <bboris@rsoft.ca>

COPY docker_build/boxes-commons.gem /var/src/
COPY docker_build/boxes-scalpel.gem /var/src/
RUN gem install --no-rdoc --no-ri /var/src/boxes-commons.gem
RUN gem install --no-rdoc --no-ri /var/src/boxes-scalpel.gem

ENV BOXES_AMQP_URL amqp://boxes:boxes@rabbitmq

CMD scalpel
