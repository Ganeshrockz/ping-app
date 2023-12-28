FROM ubuntu:latest

ARG BIN_NAME=ping-app
# TARGETARCH and TARGETOS are set automatically when --platform is provided.
ARG TARGETOS TARGETARCH
# Export BIN_NAME for the CMD below, it can't see ARGs directly.
ENV BIN_NAME=$BIN_NAME
ENV TARGETOS=$TARGETOS
ENV TARGETARCH=$TARGETARCH

# Set up certificates, base tools, and software.
RUN apt-get update && \
    apt-get install -y curl tcpdump dnsutils iptables

COPY . /bin/

# Expose the port on which the HTTP server will listen
EXPOSE 9090

# Command to run the Go application
ENTRYPOINT ["/bin/sh", "-c", "/bin/$TARGETOS/$TARGETARCH/ping-app"]
