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
FROM node:12.6.0 as front-end

COPY ./web /web
WORKDIR /web

RUN npm install
RUN npm run build

FROM ruby:2.6.3
RUN gem install bundler:2.0.1

COPY ./api /postfacto
COPY docker/release/entrypoint.sh /
COPY docker/release/create-admin-user.sh /usr/local/bin
COPY --from=front-end /web/build /postfacto/client/

WORKDIR /postfacto

RUN bundle install --without test
RUN apt-get update -qq
RUN apt-get install -y nodejs
RUN bundle exec rake assets:precompile

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV GOOGLE_OAUTH_CLIENT_ID ""
ENV ENABLE_ANALYTICS false

EXPOSE 3000

ENTRYPOINT "/entrypoint.sh"
