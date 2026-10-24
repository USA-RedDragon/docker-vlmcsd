FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a AS builder

WORKDIR /build

RUN apk add --no-cache build-base

COPY . ./

ARG VLMCSD_VERSION=${DOCKER_TAG}
RUN make vlmcsd

FROM alpine:3.24.3@sha256:be2656061b536c1883c4034790e21d0a09c5aaaf51968b89368a3c0371ea2c9a

COPY --from=builder /build/bin/vlmcsd /bin/vlmcsd

EXPOSE 1688/tcp

# -L <address>[:<port>] listen on IP address <address> with optional <port>
# -e                    log to stdout
# -D                    run in foreground

CMD [ "vlmcsd", "-L", "0.0.0.0", "-e", "-D", "-d" ]
