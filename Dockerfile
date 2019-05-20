FROM abiosoft/caddy:builder as builder

ENV PLUGINS cache,jwt
ENV VERSION 1.0.0

RUN mkdir -p /plugins

RUN printf "package main\nimport _ \"github.com/cmulk/loginsrv-planningcenter/caddy\"" > \
	/plugins/login-planningcenter.go


RUN sh /usr/bin/builder.sh


FROM alpine

RUN apk --no-cache add ca-certificates

COPY --from=builder /install/caddy /usr/bin/caddy

ENTRYPOINT ["caddy"]
CMD ["--conf","/etc/Caddyfile","--log","stdout"]
