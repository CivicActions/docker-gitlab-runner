FROM gitlab/gitlab-runner:bleeding
# The bleeding tag is one that is currently passing security scans

# Install Docker
RUN curl -L https://get.docker.com/builds/Linux/x86_64/docker-17.05.0-ce.tgz > docker.tgz && \
  tar -xvzf docker.tgz && \
  mv docker/* /usr/local/bin && \
  chmod +x /usr/local/bin/* && \
  rmdir docker

# Install Docker Compose
RUN curl -L https://github.com/docker/compose/releases/download/1.12.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install git lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash && \
    apt-get -y install git-lfs

