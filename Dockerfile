FROM node:12.6.0 as web

WORKDIR /web

COPY ./package.json .
COPY ./package-lock.json .
RUN npm ci

COPY ./public/ .
COPY ./src/ .
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
