FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659 AS builder

WORKDIR /build

RUN apk add --no-cache build-base

COPY . ./

ARG VLMCSD_VERSION=${DOCKER_TAG}
RUN make vlmcsd

FROM alpine:3.23.3@sha256:25109184c71bdad752c8312a8623239686a9a2071e8825f20acb8f2198c3f659

COPY --from=builder /build/bin/vlmcsd /bin/vlmcsd

EXPOSE 1688/tcp

# -L <address>[:<port>] listen on IP address <address> with optional <port>
# -e                    log to stdout
# -D                    run in foreground

CMD [ "vlmcsd", "-L", "0.0.0.0", "-e", "-D", "-d" ]
