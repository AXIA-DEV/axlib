FROM docker.io/library/ubuntu:20.04

# metadata
ARG VCS_REF
ARG BUILD_DATE

LABEL io.parity.image.authors="devops-team@axiacoin.network" \
	io.parity.image.vendor="Parity Technologies" \
	io.parity.image.title="parity/subkey" \
	io.parity.image.description="Subkey: key generating utility for Axlib." \
	io.parity.image.source="https://https://github.com/AXIA-DEV/axlib/blob/${VCS_REF}/.maintain/docker/subkey.Dockerfile" \
	io.parity.image.revision="${VCS_REF}" \
	io.parity.image.created="${BUILD_DATE}" \
	io.parity.image.documentation="https://https://github.com/AXIA-DEV/axlib/tree/${VCS_REF}/subkey"

# show backtraces
ENV RUST_BACKTRACE 1

# add user
RUN useradd -m -u 1000 -U -s /bin/sh -d /subkey subkey

# add subkey binary to docker image
COPY ./subkey /usr/local/bin

USER subkey

# check if executable works in this container
RUN /usr/local/bin/subkey --version

ENTRYPOINT ["/usr/local/bin/subkey"]
