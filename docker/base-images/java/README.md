# Java Base Image

This repository provides a Dockerfile for building a lightweight and secure Java base image using Amazon Corretto JDK on Amazon Linux 2023 Minimal.

## Key Features

- **Lightweight Base**: Built on **Amazon Linux 2023 Minimal** for enhanced performance and security.
- **Java Runtime**: Includes **Amazon Corretto JDK**, suitable for both Java development and runtime environments.
- **Non-Root User**: Configures a non-root user (`rvapp`) to ensure secure application execution.
- **Optimized Directory**: Sets the working directory to `/opt/app` for streamlined application deployment.

## Usage Instructions

### Building the Image

To build the Docker image, execute the following command. Ensure you refer to the official Corretto release pages for available versions:

- [Amazon Corretto 24](https://github.com/corretto/corretto-24/releases)
- [Amazon Corretto 21](https://github.com/corretto/corretto-21/releases)
- [Amazon Corretto 17](https://github.com/corretto/corretto-17/releases)
- [Amazon Corretto 11](https://github.com/corretto/corretto-11/releases)

```bash
export CORRETTO_VERSION=24.0.1.9.1
docker buildx build --platform linux/amd64 --progress=plain -t rv-amz-2023-java:$CORRETTO_VERSION --build-arg CORRETTO_VERSION=$CORRETTO_VERSION .
```

### Running the Image

To run the Docker image, use the following command:

```bash
docker run --rm --platform linux/amd64 -it rv-amz-2023-java:$CORRETTO_VERSION
```

## Customization

- **Amazon Corretto Version:** Modify the `ARG CORRETTO_VERSION` to install a different Amazon Corretto version. You can find available versions at [Amazon Corretto Downloads](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html).
- **Application Code:** Copy your Java application code into the `/opt/app` directory.

## Example Usage

```Dockerfile
# Use the Java base image
FROM dockerhubdevopsrv/java-base:latest

COPY . .
RUN javac Main.java

# Expose the application port
EXPOSE 8080

# Change ownership to the non-root user
RUN chown -R rvapp:rvapp /opt/app

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["java", "Main"]
```

---

### Author: Raghu Vamsi

#### 🔗 Connect with Me
[![LinkedIn](https://img.shields.io/badge/-LinkedIn-blue?style=flat&logo=LinkedIn&logoColor=white&link=https://www.linkedin.com/in/devops-rv/)](https://www.linkedin.com/in/devops-rv/)  
[![Medium](https://img.shields.io/badge/-Medium-000000?style=flat&labelColor=000000&logo=Medium&link=https://medium.com/@DevOps-Rv)](https://medium.com/@DevOps-Rv)