FROM ruby:2.1.3

MAINTAINER Boris Bera <bboris@rsoft.ca>

RUN gem install bundler

COPY pkg/boxes-commons.gem /var/src/gems/
RUN gem install --no-rdoc --no-ri /var/src/gems/boxes-commons.gem

COPY bin /var/src/app/bin
COPY lib /var/src/app/lib
COPY Gemfile /var/src/app/
COPY Gemfile.lock /var/src/app/

WORKDIR /var/src/app

RUN bundle install --system --without dev

ENV BOXES_AMQP_URL amqp://boxes:boxes@rabbitmq

VOLUME ["/var/src/media"]
ENV BOXES_MEDIA_ROOT /var/src/media

CMD bundle exec bin/scalpel
