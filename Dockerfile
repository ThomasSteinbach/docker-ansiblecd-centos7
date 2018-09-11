FROM centos:7
LABEL maintainer="Thomas Steinbach"

RUN yum -y install \
      sudo \
      python \
      openssh-server && \
    yum clean all >/dev/null

RUN /usr/bin/ssh-keygen -A

RUN useradd --home-dir /gitlab --create-home gitlab
WORKDIR /gitlab
# https://github.com/hadolint/hadolint/wiki/DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "gitlab:gitlab" | chpasswd

EXPOSE 22/tcp
HEALTHCHECK --interval=5s --timeout=3s \
  CMD < /dev/tcp/127.0.0.1/22

CMD ["/usr/bin/sshd", "-D", "-e"]
