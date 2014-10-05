FROM ruby:2.1.3

MAINTAINER Boris Bera <bboris@rsoft.ca>

COPY docker_build/boxes-scalpel.gem /var/src/
RUN gem install --no-rdoc --no-ri /var/src/boxes-scalpel.gem

CMD scalpel
