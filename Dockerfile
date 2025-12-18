FROM alpine:3.23.2@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62 AS builder

WORKDIR /build

RUN apk add --no-cache build-base

COPY . ./

ARG VLMCSD_VERSION=${DOCKER_TAG}
RUN make vlmcsd

FROM alpine:3.23.2@sha256:865b95f46d98cf867a156fe4a135ad3fe50d2056aa3f25ed31662dff6da4eb62

COPY --from=builder /build/bin/vlmcsd /bin/vlmcsd

EXPOSE 1688/tcp

# -L <address>[:<port>] listen on IP address <address> with optional <port>
# -e                    log to stdout
# -D                    run in foreground

CMD [ "vlmcsd", "-L", "0.0.0.0", "-e", "-D", "-d" ]
