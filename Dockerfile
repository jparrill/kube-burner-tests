# Simple single-stage Dockerfile for stress testing
FROM quay.io/fedora/fedora:latest

# Install stress testing and networking tools (without nginx)
RUN dnf update -y && \
    dnf install -y \
        stress-ng \
        stress \
        curl \
        wget \
        procps-ng \
        findutils \
        iproute \
        iputils \
        netcat \
        bind-utils && \
    dnf clean all && \
    rm -rf /var/cache/dnf

# Create non-root user for OpenShift compatibility
RUN useradd -u 1001 -g 0 -m stressuser && \
    chmod g+rwx /home/stressuser

# Verify all tools are working
RUN stress-ng --version && \
    stress --version && \
    curl --version && \
    nc -h && \
    ping -V

# Set working directory
WORKDIR /home/stressuser

# Set security context to run as non-root
USER 1001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD stress-ng --version || exit 1

# Default entry point
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["stress-ng --help"]

# Metadata
LABEL maintainer="kube-burner-stress-team" \
      description="Comprehensive stress testing tools for Kubernetes" \
      version="1.0" \
      tools="stress-ng,stress,curl,wget,netcat,ping" \
      base-image="fedora" \
      openshift-compatible="true"
