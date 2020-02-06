FROM gitlab/gitlab-runner:v12.7.1

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install all versions of Docker Compose from 1.20 on
RUN TAGS=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP '[0-9]+\.[2-9][0-9]+\.[0-9]+$'); \
  for COMPOSE_VERSION in $TAGS; do \
  echo "Fetching Docker Compose version ${COMPOSE_VERSION}"; \
  curl -LsS -C - https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose-${COMPOSE_VERSION}; \
  done; \
  chmod a+x /usr/local/bin/docker-compose-*; \
  echo "Symlinking most recent stable Docker Compose version"; \
  ln -s /usr/local/bin/docker-compose-${COMPOSE_VERSION} /usr/local/bin/docker-compose

# Install git lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get -y install git-lfs

