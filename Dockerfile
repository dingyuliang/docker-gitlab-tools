FROM alpine:latest
MAINTAINER Mark Riedesel <mark@klowner.com>

ENV GITLAB_MIRROR_ASSETS=/assets \
	GITLAB_MIRROR_USER=git \
	GITLAB_MIRROR_HOME=/config \
	GITLAB_MIRROR_INSTALL_DIR=/opt/gitlab-mirror \
	GITLAB_MIRROR_REPO_DIR=/data \
	GITLAB_MIRROR_VERSION=0.6.0

RUN apk update \
	&& apk add bash git gettext git-svn breezy mercurial python3 py3-setuptools py3-pip libressl \
		sudo perl-git openssh-client \
	&& rm -rf /var/cache/apk/*

# git-bzr-helper
RUN wget https://raw.github.com/felipec/git-remote-bzr/master/git-remote-bzr -O /usr/local/bin/git-remote-bzr \
	&& chmod 755 /usr/local/bin/git-remote-bzr

# git-hg-helper
RUN wget https://raw.github.com/felipec/git-remote-hg/master/git-remote-hg -O /usr/local/bin/git-remote-hg \
	&& chmod 755 /usr/local/bin/git-remote-hg

# python-gitlab
RUN pip3 install python-gitlab


WORKDIR /

# gitlab-mirrors scripts
# Specific release:
#RUN mkdir -p "${GITLAB_MIRROR_INSTALL_DIR}" && \
#	wget https://github.com/samrocketman/gitlab-mirrors/archive/v${GITLAB_MIRROR_VERSION}.tar.gz -O - | \
#		tar xz --strip 1 --directory "${GITLAB_MIRROR_INSTALL_DIR}"
COPY gitlab-mirrors ${GITLAB_MIRROR_INSTALL_DIR}

# - OR -

# Latest git version
#RUN git clone --depth 1 https://github.com/samrocketman/gitlab-mirrors.git ${GITLAB_MIRROR_INSTALL_DIR}

RUN echo 'env_keep+=SSH_AUTH_SOCK' >> /etc/visudo

COPY docker-gitlab-mirrors/assets ${GITLAB_MIRROR_ASSETS}
COPY docker-gitlab-mirrors/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

VOLUME ["${GITLAB_MIRROR_REPO_DIR}", "${GITLAB_MIRROR_HOME}"]
WORKDIR ${GITLAB_MIRROR_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["help"]
