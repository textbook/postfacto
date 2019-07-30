This is the Docker configuration for a release, bundling the Rails app and React frontend together.

To build the image, you can run:

```bash
docker build -f ./docker/release/Dockerfile -t postfacto/release:dev .
```

The following environment variables are required to start the container:

  - `DATABASE_URL`: configuration for the Postgres database
  - `REDIS_URL`: configuration for the Redis queue
  - `SECRET_KEY_BASE`: used to verify signed cookies

## Compose

If you want to use `docker-compose` to run a network locally, you can use the following command:

```bash
SECRET_KEY_BASE=... docker-compose -f ./docker/release/docker-compose.yml up
```

This will build the app and pull images for Postgres and Redis, then start the network.

Note that the database will not be configured for operation yet. Open a new terminal and run the following:

```bash
docker-compose -f ./docker/release/docker-compose.yml run rails rake db:migrate
SECRET_KEY_BASE=... docker-compose -f ./docker/release/docker-compose.yml run \
    -e ADMIN_EMAIL=... \
    -e ADMIN_PASSWORD=... \
    rails rake admin:create_user
```
