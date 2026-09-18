FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6 AS builder

WORKDIR /build

RUN apk add --no-cache build-base

COPY . ./

ARG VLMCSD_VERSION=${DOCKER_TAG}
RUN make vlmcsd

FROM alpine:3.24.2@sha256:294b683cb724975bec92580e1e685676bd4b50bda910ddb8c51d4cabeaec77e6

COPY --from=builder /build/bin/vlmcsd /bin/vlmcsd

EXPOSE 1688/tcp

# -L <address>[:<port>] listen on IP address <address> with optional <port>
# -e                    log to stdout
# -D                    run in foreground

CMD [ "vlmcsd", "-L", "0.0.0.0", "-e", "-D", "-d" ]
