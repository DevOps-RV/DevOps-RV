# Use Amazon Linux 2023 minimal as the base image
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal

# Set arguments for Node.js version
ARG NODE_VERSION=18

# Install required dependencies
RUN yum update -y && \
    yum install -y gcc gcc-c++ make curl-minimal && \
    yum clean all

# Install Node.js
RUN curl -fsSL https://rpm.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
    yum install -y nodejs && \
    yum clean all

# Create a non-root user and set up the working directory
RUN useradd -m -d /opt/app rvapp && \
    mkdir -p /opt/app && \
    chown -R rvapp:rvapp /opt/app
WORKDIR /opt/app

# Switch to the non-root user
USER rvapp
