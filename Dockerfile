FROM gitlab/gitlab-runner:v12.7.1

# Install Docker
RUN curl -sSL https://get.docker.com/ | sh

# Install latest version of Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/docker/compose/releases/latest | awk -F / '{print $NF}')/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install git lfs
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && \
    apt-get -y install git-lfs

