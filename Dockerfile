FROM abiosoft/caddy:builder as builder

ENV PLUGINS login,jwt
ENV VERSION 1.0.1
ENV ENABLE_TELEMETRY false

# Use go.mod replace to import patched login plugin with planning center support
RUN mkdir -p /caddy && \
    cd /caddy && \
    go mod init caddy && \
    echo "replace github.com/tarent/loginsrv => github.com/cmulk/loginsrv-planningcenter v1.3.1-pc" >> go.mod && \
    cd /go


RUN sh /usr/bin/builder.sh


FROM alpine

RUN apk --no-cache add ca-certificates

COPY --from=builder /install/caddy /usr/bin/caddy

ENTRYPOINT ["caddy"]
CMD ["--conf","/etc/Caddyfile","--log","stdout"]
