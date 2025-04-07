FROM public.ecr.aws/amazonlinux/amazonlinux:2023 AS gcloud-installer
RUN dnf -y install wget which python tar && \
    curl -sSL https://sdk.cloud.google.com > install.sh && \
    bash install.sh --disable-prompts --install-dir=/opt

FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal
LABEL maintainer="Raghu Vamsi"
ARG COMMAND_LINE_TOOLS_VERSION=8512546
ARG JAVA_VERSION=21
ARG BUNDLE_TOOL_VERSION=1.18.1

# Install necessary packages
RUN set -eux; \
    dnf -y update && \
    dnf -y install \
        glibc-langpack-en \
        glibc-common \
        wget \
        unzip \
        tar \
        java-${JAVA_VERSION}-amazon-corretto-devel \
        ruby ruby-devel \
        npm \
        gcc \
        make \
        which \
        git && \
    dnf clean all

COPY --from=gcloud-installer /opt/google-cloud-sdk /opt/google-cloud-sdk

# Environment variables
ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    ANDROID_HOME=/opt/android/sdk \
    CMD_TOOLS_DIR=/opt/android/sdk/cmdline-tools/latest \
    JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-amazon-corretto \
    GEM_HOME=/usr/local/bundle \
    GC_SDK_HOME=/opt/google-cloud-sdk

ENV PATH="$CMD_TOOLS_DIR/bin:$ANDROID_HOME/platform-tools:$JAVA_HOME/bin:$GEM_HOME/bin:$GC_SDK_HOME/bin:$PATH"

# Setup Android SDK & Components
RUN set -eux; \
        mkdir -p $CMD_TOOLS_DIR && \
        wget -q https://dl.google.com/android/repository/commandlinetools-linux-${COMMAND_LINE_TOOLS_VERSION}_latest.zip -O /tmp/cmdtools.zip && \
        unzip /tmp/cmdtools.zip -d $CMD_TOOLS_DIR && \
        mv $CMD_TOOLS_DIR/cmdline-tools/* $CMD_TOOLS_DIR/ && \
        \
        rm -rf \
            /tmp/cmdtools.zip \
            $CMD_TOOLS_DIR/cmdline-tools && \
        \
        yes | sdkmanager --update && \
        yes | sdkmanager --licenses && \
        yes | sdkmanager \
            "platform-tools" \
            "build-tools;35.0.0" \
            "platforms;android-35" \
            "sources;android-35" \
            "emulator"

# Setup Bundle Tool , Firebase CLI, Appcenter CLI, Fastlane & Bundler
RUN wget -q https://github.com/google/bundletool/releases/download/${BUNDLE_TOOL_VERSION}/bundletool-all-${BUNDLE_TOOL_VERSION}.jar -O /opt/bundletool.jar && \
    chmod +x /opt/bundletool.jar && \
    echo '#!/bin/sh' > /usr/local/bin/bundletool && \
    echo "exec java -jar /opt/bundletool.jar \"\$@\"" >> /usr/local/bin/bundletool && \
    chmod +x /usr/local/bin/bundletool && \
    \
    curl -sL https://firebase.tools | bash && \
    \
    npm install --location=global appcenter-cli --unsafe-perm && \
    npm cache clean --force && \
    \
    gem install bundler fastlane -N && \
    \
    rm -rf \
        /tmp/* \
        /var/cache/* \
        /root/.cache \
        /root/.npm \
        /root/.gem

# Verify installations
RUN java --version && \
    sdkmanager --version && \
    sdkmanager --list && \
    gcloud --version && \
    firebase --version && \
    fastlane --version && \
    bundler --version && \
    ruby --version && \
    git --version && \
    npm --version && \
    appcenter --version && \
    bundletool version

CMD ["/bin/bash"]
