FROM ubuntu:22.04

ARG RUNNER_VERSION=2.328.0

RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    jq \
    git \
    sudo \
    libicu70 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 dockeruser

RUN mkdir /home/dockeruser/actions-runner
WORKDIR /home/dockeruser/actions-runner

RUN curl -L -o actions-runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf actions-runner.tar.gz && \
    rm actions-runner.tar.gz && \
    ./bin/installdependencies.sh

RUN chown -R dockeruser:dockeruser /home/dockeruser/actions-runner

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER dockeruser

ENTRYPOINT ["/entrypoint.sh"]