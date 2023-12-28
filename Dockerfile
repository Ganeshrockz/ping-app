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
    apt-get install -y ca-certificates curl tcpdump gnupg libcap openssl su-exec bind-tools iputils iptables gcompat libc6-compat libstdc++
    
COPY . /bin/

# Expose the port on which the HTTP server will listen
EXPOSE 9090

# Command to run the Go application
ENTRYPOINT ["/bin/sh", "-c", "/bin/bin/$TARGETOS/$TARGETARCH/ping-app"]
