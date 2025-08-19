# Use the latest Amazon Linux 2023 as the base image
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal AS base

# Define the default Python version as a variable
ARG PYTHON_VERSION=3.12.4

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Install required packages and clean up
RUN set -eux; \
        dnf -y update; \
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
            shadow-utils \
            rust \
            cargo; \
        dnf clean all

# Install Python
RUN set -eux; \
        mkdir -p /usr/src/python; \
        curl -fLo /usr/src/python.tgz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tgz"; \
        \
        tar --extract \
            --directory /usr/src/python \
            --strip-components=1 \
            --file /usr/src/python.tgz; \
        \
        cd /usr/src/python; \
            ./configure \
                --enable-optimizations \
                --with-ensurepip=install; \
            make altinstall; \
        \
        rm -rf \
            /usr/src/python.tgz \
            /usr/src/python;

# make some useful symlinks that are expected to exist
RUN set -eux; \
        ln -s /usr/local/bin/python${PYTHON_VERSION%.*} /usr/bin/python3; \
        ln -s /usr/local/bin/pip${PYTHON_VERSION%.*} /usr/bin/pip3; \
        ln -s /usr/local/bin/python${PYTHON_VERSION%.*} /usr/bin/python; \
        ln -s /usr/local/bin/pip${PYTHON_VERSION%.*} /usr/bin/pip; \
        \
        python --version; \
        pip --version

# Copy pip configuration
RUN pwd; ls -ltr 
# COPY pip.conf /etc/pip.conf

# Create a system group and user with minimal permissions
RUN set -eux; \
        groupadd --system --gid 1010 rvapp; \
        useradd --system \
            --uid 1010 \
            --gid rvapp \
            --home /opt/app \
            --shell /bin/bash \
            --no-log-init \
            --comment "rv application user" rvapp; \
        mkdir -p /opt/app; \
        chown rvapp:rvapp -R /opt/app; \
        chmod 755 /opt/app

# Set the working directory
WORKDIR /opt/app

CMD ["/bin/bash"]