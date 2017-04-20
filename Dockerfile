FROM 538244530177.dkr.ecr.us-west-2.amazonaws.com/base-instastage:latest
COPY Gemfile* /tmp/
USER root
RUN chown -R app. /tmp/Gemfile.lock
USER app
WORKDIR /tmp
RUN RAILS_ENV=staging GEM_HOME=/bundle GEM_PATH=/bundle bundle install --jobs=4 --retry=3
ARG APP
ARG APP_SUBDOMAIN
ARG SHA
ARG VERSION_TXT
ENV RAILS_ENV staging
ENV GEM_HOME /bundle
ENV GEM_PATH /bundle
USER app
COPY . /var/lib/releases/$APP-$SHA
USER root
RUN chown -R app. /var/lib/releases/
USER app
RUN echo $SHA > /var/lib/releases/$APP-$SHA/public/version.txt
RUN ["/bin/bash", "-c", "mkdir -p /var/lib/releases/$APP-$SHA/{log,tmp/pids,tmp/cache,tmp/sockets,tmp/sessions}"]
RUN cd /var/lib/releases/$APP-$SHA && ln -s /var/lib/releases/$APP-$SHA /home/app/current
WORKDIR /home/app/current
