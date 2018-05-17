FROM centos:7
MAINTAINER Thomas Steinbach
# with credits upstream: https://hub.docker.com/r/geerlingguy/docker-centos7-ansible/
# with credits upstream: https://github.com/naftulikay/docker-centos-vm.git
# with credits to https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/

ENV container=docker

RUN yum makecache fast \
    && yum -y install deltarpm epel-release initscripts \
    && yum -y update  \
    && yum -y install sudo which less  \
    && yum clean all >/dev/null \

RUN \
    rm -f /usr/lib/systemd/system/sysinit.target.wants/systemd-firstboot.service; \
    rm -f /etc/systemd/system/*.wants/*; \
    rm -f /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup.service; \
    rm -f /lib/systemd/system/multi-user.target.wants/*; \
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*; \
    rm -f /lib/systemd/system/anaconda.target.wants/*;

# disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/' /etc/sudoers

# custom utility for awaiting systemd "boot" in the container
COPY bin/systemd-await-target /usr/bin/systemd-await-target
COPY bin/wait-for-boot /usr/bin/wait-for-boot

# use fixed yum mirror to make effort of proxy cache
RUN sed -i 's%mirrorlist%#mirrorlist%g' /etc/yum.repos.d/*; \
    sed -i 's%#baseurl%baseurl%g' /etc/yum.repos.d/*

VOLUME ["/sys/fs/cgroup"]
ENTRYPOINT ["/usr/sbin/init"]
