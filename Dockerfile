FROM alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4 AS builder

WORKDIR /build

RUN apk add --no-cache build-base

COPY . ./

ARG VLMCSD_VERSION=${DOCKER_TAG}
RUN make vlmcsd

FROM alpine:3.24.0@sha256:a2d49ea686c2adfe3c992e47dc3b5e7fa6e6b5055609400dc2acaeb241c829f4

COPY --from=builder /build/bin/vlmcsd /bin/vlmcsd

EXPOSE 1688/tcp

# -L <address>[:<port>] listen on IP address <address> with optional <port>
# -e                    log to stdout
# -D                    run in foreground

CMD [ "vlmcsd", "-L", "0.0.0.0", "-e", "-D", "-d" ]
