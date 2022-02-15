FROM docker.io/library/ubuntu:20.04

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@parity.io" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/axlib" \
	io.parity.image.description="Axlib: The platform for blockchain innovators." \
	io.parity.image.source="https://https://github.com/AXIA-DEV/axlib/blob/${VCS_REF}/.maintain/docker/Dockerfile" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}" \
	io.parity.image.documentation="https://wiki.parity.io/Parity-Axlib"

# show backtraces
ENV RUST_BACKTRACE 1

# install tools and dependencies
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get upgrade -y && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
		libssl1.1 \
		ca-certificates \
		curl && \
# apt cleanup
	apt-get autoremove -y && \
	apt-get clean && \
	find /var/lib/apt/lists/ -type f -not -name lock -delete; \
# add user
	useradd -m -u 1000 -U -s /bin/sh -d /axlib axlib

# add axlib binary to docker image
COPY ./axlib /usr/local/bin

USER axlib

# check if executable works in this container
RUN /usr/local/bin/axlib --version

EXPOSE 30333 9933 9944
VOLUME ["/axlib"]

ENTRYPOINT ["/usr/local/bin/axlib"]
