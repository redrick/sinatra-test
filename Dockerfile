FROM ruby:2.4

MAINTAINER Andrej Antas <andrej@antas.cz>

# add user and jump to his home
RUN useradd -ms /bin/bash app
WORKDIR /home/app

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
RUN export LANGUAGE=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

COPY Gemfile Gemfile.lock /home/app/
RUN gem install bundler --pre
RUN bundle install
ADD . /home/app
RUN chown -R app:app /home/app
USER app

ENV RACK_ENV=development

EXPOSE 9292
ENTRYPOINT bundle exec rackup -o 0.0.0.0 -E $RACK_ENV
