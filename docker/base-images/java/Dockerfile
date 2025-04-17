# Use Amazon Linux 2023 Minimal as the base
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal

# Set environment variables for JDK version and installation path
ARG CORRETTO_VERSION=24.0.1.9.1
ENV JAVA_HOME=/usr/lib/jvm/java

# Install required packages
RUN set -eux; \
        dnf install -y \
            curl \
            tar \
            gzip \
            ca-certificates \
            findutils \
            glibc \
            zlib; \
        dnf clean all


RUN set -eux; \
        curl -L -o corretto.tar.gz https://corretto.aws/downloads/resources/${CORRETTO_VERSION}/amazon-corretto-${CORRETTO_VERSION}-linux-x64.tar.gz; \
        mkdir -p ${JAVA_HOME}; \
        tar -xzf corretto.tar.gz --strip-components=1 -C ${JAVA_HOME}; \
        rm -f corretto.tar.gz

ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN java --version

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