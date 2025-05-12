# docker-gha-runner

A dead-simple way to add GitHub Actions Runners to your account.

## Motivation

I kept getting annoyed by how the GitHub Actions runner script is sort of stateful and has access to the surrounding environment.
What I really want is the exact same as the GitHub Actions default runner but self-host it. This is in that direction. The actions
container is torn down and restarted when the action ends, therefore it's stateless like the default runner.

## Features

* Stateless execution
* Container isolation
* Self-host it wherever you want
* Architecture emulation via QEMU

## Limitations

* There's no dispatching layer so you'll pay more than something like [runs-on](https://runs-on.com/) if that's your jam.
* Docker and related actions don't work. Contributions welcome to get docker-in-docker working.

## Usage with Docker

Bring up the container, setting `ACCESS_TOKEN` and `REPOSITORY`.

```sh
docker run -e REPOSITORY=... -e ACCESS_TOKEN=... -d --rm ghcr.io/kevmo314/docker-gha-runner:main
```

## Usage with Docker Compose

Create a `docker-compose.yml`

```yaml
services:
  runner:
    image: ghcr.io/kevmo314/docker-gha-runner:main
    restart: always
    deploy:
      mode: replicated
      replicas: 4
    environment:
      REPOSITORY: <the repository you wish to link to>
      ACCESS_TOKEN: <github access token>
```

Then

```
docker compose up -d
```
