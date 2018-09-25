FROM gitlab/gitlab-runner:alpine

RUN apk --no-cache add curl docker git

# Install latest version of Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/docker/compose/releases/latest | awk -F / '{print $NF}')/docker-compose-$(uname -s)-$(uname -m)" > /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Install git lfs
RUN apk --no-cache add git-lfs
