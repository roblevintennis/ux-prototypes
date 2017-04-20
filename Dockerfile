FROM 538244530177.dkr.ecr.us-west-2.amazonaws.com/base-instastage:latest
COPY Gemfile* /tmp/
COPY package.json /tmp/
COPY yarn.lock /tmp/
USER root
RUN chown -R app. /tmp/yarn.lock
RUN chown -R app. /tmp/Gemfile.lock
USER app
WORKDIR /tmp
RUN RAILS_ENV=staging GEM_HOME=/bundle GEM_PATH=/bundle bundle install --jobs=4 --retry=3
RUN RAILS_ENV=staging GEM_HOME=/bundle GEM_PATH=/bundle yarn install --force
ARG APP
ARG APP_SUBDOMAIN
ARG SHA
ARG VERSION_TXT
ENV RAILS_ENV staging
ENV GEM_HOME /bundle
ENV GEM_PATH /bundle
ENV DATABASE ${APP_SUBDOMAIN}_mavenlink_staging
ENV DATABASE_USERNAME root
ENV DATABASE_HOST localhost
ENV DATABASE_PORT 30215
ENV DATABASE_PASSWORD password
USER app
COPY . /var/lib/releases/$APP-$SHA
USER root
RUN chown -R app. /var/lib/releases/
USER app
RUN echo $SHA > /var/lib/releases/$APP-$SHA/public/version.txt
RUN ["/bin/bash", "-c", "mkdir -p /var/lib/releases/$APP-$SHA/{log,tmp/pids,tmp/cache,tmp/sockets,tmp/sessions}"]
RUN cd /var/lib/releases/$APP-$SHA && ln -s /var/lib/releases/$APP-$SHA /home/app/current && ln -s /tmp/node_modules /home/app/current/node_modules
WORKDIR /home/app/current
RUN yarn install --force
RUN bundle exec rake db:create
RUN mysqldump --opt -h${DATABASE_HOST} -u${DATABASE_USERNAME} -p${DATABASE_PASSWORD} -P30215 --no-create-db ${SOURCE_DB} > /tmp/sqldump.sql && mysql -h${DATABASE_HOST} -u${DATABASE_USERNAME} -p${DATABASE_PASSWORD} -P30215 ${DATABASE} < /tmp/sqldump.sql && rm /tmp/sqldump.sql
RUN bundle exec rake db:migrate
RUN bundle exec rake assets:precompile webpack:compile
