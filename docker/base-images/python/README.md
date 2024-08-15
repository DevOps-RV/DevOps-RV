# Python Base Image for Amazon Linux 2023

This Dockerfile builds a base image for Python applications, specifically targeting Amazon Linux 2023. It sets up a clean environment with essential tools like GCC, OpenSSL, and others. It then installs the specified Python version (defaulting to 3.12.4) and configures it for optimal use.

## Features

- **Base Image:** Uses the latest Amazon Linux 2023 minimal image for a lightweight and secure foundation.
- **Python Installation:** Installs the specified Python version (default 3.12.4) with optimizations enabled.
- **User Setup:** Creates a dedicated system user (`rvapp`) with a home directory (`/opt/app`) for application files.
- **Environment Variables:** Sets common Python environment variables for better performance.
- **Pip Configuration:** Includes a custom `pip.conf` file for managing Python packages.
- **Rust Installation:** Installs Rust and Cargo for potential use in the application.
- **Working Directory:** Sets the working directory to `/opt/app` for convenience.

## Usage

1. **Build the Image:**

   ```bash
   docker build -t python-base:3.14.0a0 --build-arg PYTHON_VERSION=3.14.0a0 .
   ```

2. **Run a Container:**

   ```bash
   docker run -it python-base /bin/bash
   ```

## Customization

- **Python Version:** Modify the `ARG PYTHON_VERSION` to install a different Python version. You can find available versions at [Python's FTP site](https://www.python.org/ftp/python/).
- **Requirements:** Add your Python package requirements to a `requirements.txt` file and copy it into the image.
- **Application Code:** Copy your application code into the `/opt/app` directory.

## Example Usage

```Dockerfile
# Use the latest Amazon Linux 2023 as the base image
FROM dockerhubdevopsrv/python-base:latest

COPY . .
RUN pip install --upgrade pip && \
    pip install -r ./src/requirements.txt -t ./src

# Expose the application port
EXPOSE 8080

# Change ownership to the non-root user
RUN chown -R rvapp:rvapp /opt/app

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["python", "./src/app.py"]
```

---
[![Linkedin](https://img.shields.io/badge/-LinkedIn-blue?style=flat&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/devops-rv/)](https://www.linkedin.com/in/devops-rv/)
[![Medium](https://img.shields.io/badge/-Medium-000000?style=flat&labelColor=000000&logo=Medium&link=https://medium.com/@DevOps-Rv)](https://medium.com/@DevOps-Rv)