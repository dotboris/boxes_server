FROM phusion/passenger-ruby21:0.9.14

MAINTAINER Boris Bera <bboris@rsoft.ca>

ENV BOXES_AMQP_URL amqp://boxes:boxes@rabbitmq

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# enable passenger
RUN rm -f /etc/service/nginx/down

# configure nginx for our app
RUN rm -f /etc/nginx/sites-enabled/default
COPY nginx.conf /etc/nginx/sites-enabled/drivethrough.conf
COPY env.conf /etc/nginx/main.d/env.conf
RUN mkdir -p /home/app/drivethrough/public

# install commmons gem
COPY pkg/boxes-commons.gem /home/app/
RUN gem install --no-rdoc --no-ri /home/app/boxes-commons.gem

# install app
COPY Gemfile /home/app/drivethrough/
COPY Gemfile.lock /home/app/drivethrough/
COPY config.ru /home/app/drivethrough/
COPY lib /home/app/drivethrough/lib/
RUN gem install bundler
RUN cd /home/app/drivethrough; bundle install --system --without dev

# cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
