# Start by building the application.
FROM golang:1.19-alpine as build

WORKDIR /usr/src/traefik-forward-auth
COPY . .

RUN apk add --no-cache git gcc

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -installsuffix nocgo -o ./traefik-forward-auth ./cmd

# Now copy it into our base image.
FROM alpine
COPY --from=build /usr/src/traefik-forward-auth/traefik-forward-auth /usr/bin/traefik-forward-auth

ENTRYPOINT [ "/usr/bin/traefik-forward-auth" ]
CMD []

LABEL org.opencontainers.image.title traefik-forward-auth
LABEL org.opencontainers.image.description "Forward authentication service for the Traefik reverse proxy"
LABEL org.opencontainers.image.licenses MIT
