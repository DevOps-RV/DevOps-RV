# Use Amazon Linux 2023 minimal as the base image
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal

# Set arguments for Go version
ARG GO_VERSION=1.21.0

# Install required dependencies
RUN yum update -y && \
    yum install -y gcc gcc-c++ make wget-minimal tar && \
    yum clean all

# Download and install Go
RUN wget https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \
    rm go${GO_VERSION}.linux-amd64.tar.gz

# Set Go environment variables
ENV PATH="/usr/local/go/bin:$PATH"

# Create a non-root user and set up the working directory
RUN useradd -m -d /opt/app rvapp && \
    mkdir -p /opt/app && \
    chown -R rvapp:rvapp /opt/app
WORKDIR /opt/app

# Switch to the non-root user
USER rvapp
