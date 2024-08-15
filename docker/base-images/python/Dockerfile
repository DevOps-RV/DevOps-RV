# Use the latest Amazon Linux 2023 as the base image
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal AS base

# Define the default Python version as a variable
ARG PYTHON_VERSION=3.12.4

# Install required packages and clean up
RUN dnf -y update && \
    dnf -y install \
    gcc \
    ca-certificates \
    openssl \
    openssl-devel \
    bzip2-devel \
    libffi-devel \
    zlib-devel \
    make \
    tar \
    gzip \
    jq \
    shadow-utils && \
    dnf clean all

# Install Python
RUN PYTHON_BASE_VERSION=$(echo ${PYTHON_VERSION} | sed -E 's/(^[0-9]+\.[0-9]+\.[0-9]+).*/\1/') && \
    PYTHON_SHORT_VERSION=$(echo ${PYTHON_BASE_VERSION} | sed 's/\.[0-9]*$//') && \
    echo "PYTHON_BASE_VERSION=${PYTHON_BASE_VERSION}" && \
    echo "PYTHON_SHORT_VERSION=${PYTHON_SHORT_VERSION}" && \
    cd /usr/src && \
    curl -Lo Python-${PYTHON_VERSION}.tgz https://www.python.org/ftp/python/${PYTHON_BASE_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar xzf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make altinstall

# Setup Python
RUN PYTHON_BASE_VERSION=$(echo ${PYTHON_VERSION} | sed -E 's/(^[0-9]+\.[0-9]+\.[0-9]+).*/\1/') && \
    PYTHON_SHORT_VERSION=$(echo ${PYTHON_BASE_VERSION} | sed 's/\.[0-9]*$//') && \
    rm -rf /usr/src/Python-${PYTHON_VERSION}.tgz /usr/src/Python-${PYTHON_VERSION} && \
    [ -L /usr/bin/python3 ] && rm /usr/bin/python3 || true && \
    [ -L /usr/bin/pip3 ] && rm /usr/bin/pip3 || true && \
    [ -L /usr/bin/python ] && rm /usr/bin/python || true && \
    [ -L /usr/bin/pip ] && rm /usr/bin/pip || true && \
    ln -s /usr/local/bin/python${PYTHON_SHORT_VERSION} /usr/bin/python3 && \
    ln -s /usr/local/bin/pip${PYTHON_SHORT_VERSION} /usr/bin/pip3 && \
    ln -s /usr/local/bin/python${PYTHON_SHORT_VERSION} /usr/bin/python && \
    ln -s /usr/local/bin/pip${PYTHON_SHORT_VERSION} /usr/bin/pip && \
    python --version && \
    pip --version

# Create a system user and set up the application directory
RUN groupadd --system rvapp && \
    useradd --system --gid rvapp --home /opt/app --shell /bin/bash --comment "rv application user" --uid 1010 rvapp && \
    mkdir -p /opt/app && \
    chown 1010:1010 -R /opt/app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Copy pip configuration
COPY pip.conf /etc/pip.conf

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    echo 'source "/root/.cargo/env' >> /etc/profile.d/cargo.sh

# Set the working directory
WORKDIR /opt/app

# Set the default command
CMD ["/bin/bash"]