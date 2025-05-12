# docker-gha-runner

A dead-simple way to add GitHub Actions Runners to your account.

## Motivation

I kept getting annoyed by how the GitHub Actions runner script is sort of stateful and has access to the surrounding environment.
What I really want is the exact same as the GitHub Actions default runner but self-host it. This is in that direction. The actions
container is torn down and restarted when the action ends, therefore it's stateless like the default runner.

Additionally, I have a powerful dev machine and I wanted to use that as a runner so I didn't have to pay for a third-party service
to use what resources I already have.

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
docker run -e REPOSITORY=... -e ACCESS_TOKEN=... -d --rm --restart always ghcr.io/kevmo314/docker-gha-runner:main
```

Once it's running, check out your runners page:

![image](https://github.com/user-attachments/assets/1f2ee5a3-03e3-4bcb-9905-09a5cb2b1024)

You can then update your GitHub Actions workflows:

```yaml
jobs:
  build:
    runs-on: [self-hosted, linux]
```

## Usage with Docker Compose

Using `docker compose` allows some additional cool features such as adding replicas.

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

## Platform Emulation

If you want to emulate a different platform (such as an arm64 machine on an x86-64 machine), first make sure
you've configured qemu

```sh
docker run --rm --privileged multiarch/qemu-user-static --reset --persistent yes --credential yes
```

Then, set `platform` in your compose file:

```yaml
services:
  runner_amd64:
    image: ghcr.io/kevmo314/docker-gha-runner:main
    platform: linux/amd64
    restart: always
    deploy:
      mode: replicated
      replicas: 4
    environment:
      REPOSITORY: <the repository you wish to link to>
      ACCESS_TOKEN: <github access token>
  runner_arm64:
    image: ghcr.io/kevmo314/docker-gha-runner:main
    platform: linux/arm64
    restart: always
    deploy:
      mode: replicated
      replicas: 4
    environment:
      REPOSITORY: <the repository you wish to link to>
      ACCESS_TOKEN: <github access token>
```

And you should now have four x86-64 runners and four arm64 runners. Neat!
