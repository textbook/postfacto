#
# Postfacto, a free, open-source and self-hosted retro tool aimed at helping
# remote teams.
#
# Copyright (C) 2016 - Present Pivotal Software, Inc.
#
# This program is free software: you can redistribute it and/or modify
#
# it under the terms of the GNU Affero General Public License as
#
# published by the Free Software Foundation, either version 3 of the
#
# License, or (at your option) any later version.
#
#
#
# This program is distributed in the hope that it will be useful,
#
# but WITHOUT ANY WARRANTY; without even the implied warranty of
#
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#
# GNU Affero General Public License for more details.
#
#
#
# You should have received a copy of the GNU Affero General Public License
#
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
FROM node:12.6.0 as client

COPY ./web/package.json .
COPY ./web/package-lock.json .

RUN npm install

COPY ./web/public public/
COPY ./web/src src/

RUN npm run build

FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y nodejs

COPY ./api/Gemfile .
COPY ./api/Gemfile.lock .

RUN gem install bundler:2.0.1
RUN bundle install --without test

COPY ./api/app app/
COPY ./api/bin bin/
COPY ./api/config config/
COPY ./api/db/seeds.rb db/
COPY ./api/db/migrate db/migrate/
COPY ./api/lib lib/
COPY ./api/public public/
COPY ./api/config.ru .
COPY ./api/Rakefile .

RUN export RAILS_ENV='test' SECRET_KEY_BASE='temp' \
    && bundle exec rake assets:precompile \
    && unset RAILS_ENV SECRET_KEY_BASE

COPY --from=client ./build public/

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

EXPOSE 4000

COPY ./docker/release/entrypoint.sh /usr/bin

ENTRYPOINT ["entrypoint.sh"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "4000"]
