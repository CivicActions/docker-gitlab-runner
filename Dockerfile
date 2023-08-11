FROM gitlab/gitlab-runner:ubuntu-v16.1.1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install previous and final v1 versions
# TODO: This can be removed once all projects have migrated to compose 2+
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o "/usr/local/bin/docker-compose-1.29.2" && \
  curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o "/usr/local/bin/docker-compose-1.27.4"

# Install most recent 10 versions of Docker Compose
RUN TAGS=$(git ls-remote https://github.com/docker/compose | grep refs/tags | grep -oP 'v[0-9]+\.[0-9]+\.[0-9]+$' | sort -V | tail -n10); \
  for COMPOSE_VERSION in $TAGS; do \
  export FILE="/usr/local/bin/docker-compose-${COMPOSE_VERSION}" && \
  echo "Fetching Docker Compose version ${COMPOSE_VERSION} to ${FILE}" && \
  curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o "${FILE}" && \
  # Occasionally the tag will be created but there won't be a release yet so check we have an executable.
  if [[ "$(/usr/bin/file --brief --mime-type ${FILE})" == "application/x-executable" ]]; then LATEST="${FILE}"; else rm "${FILE}"; fi; \
  done; \
  chmod a+x /usr/local/bin/docker-compose-* && \
  # For now, hardcode LATEST to old version, but encourage projects to update.
  LATEST="/usr/local/bin/docker-compose-1.27.4" && \
  echo "Symlinking most recent stable Docker Compose version: ${LATEST}" && \
  ln -s "${LATEST}" /usr/local/bin/docker-compose

# Install git lfs and rsync
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
  apt-get -y install git-lfs rsync
