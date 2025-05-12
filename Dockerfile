FROM ubuntu:22.04

ARG TARGETARCH

RUN apt update && apt install -y curl wget sudo git jq

RUN useradd -ms /bin/bash github
RUN echo 'github ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER github

WORKDIR /home/github/actions

RUN if [ $TARGETARCH = "amd64" ]; then \
    curl -o actions-runner-linux.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-x64-2.323.0.tar.gz \
    ; fi
RUN if [ $TARGETARCH = "arm64" ]; then \
    curl -o actions-runner-linux.tar.gz -L https://github.com/actions/runner/releases/download/v2.323.0/actions-runner-linux-arm64-2.323.0.tar.gz \
    ; fi
RUN tar xzf ./actions-runner-linux.tar.gz
RUN rm actions-runner-linux.tar.gz

COPY ./start.sh ./start.sh
USER root
RUN ./bin/installdependencies.sh
RUN chmod +x start.sh

USER github

CMD ["./start.sh"]
