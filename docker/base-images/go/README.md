# Go Base Image for Amazon Linux 2023

This Dockerfile builds a base image for Go applications, specifically targeting Amazon Linux 2023. It sets up a clean environment with Go for building and running Go applications.

## Features

- **Base Image:** Uses the latest Amazon Linux 2023 minimal image for a lightweight and secure foundation.
- **Go Installation:** Installs the specified Go version (default 1.21.x).
- **User Setup:** Creates a dedicated system user (`rvapp`) with a home directory (`/opt/app`) for application files.
- **Working Directory:** Sets the working directory to `/opt/app` for convenience.

## Usage

1. **Build the Image:**

   ```bash
   docker build -t go-base:latest .
   ```

2. **Run a Container:**

   ```bash
   docker run -it go-base /bin/bash
   ```

## Customization

- **Go Version:** Modify the `ARG GO_VERSION` to install a different Go version. You can find available versions at [Go Downloads](https://go.dev/dl/).
- **Application Code:** Copy your Go application code into the `/opt/app` directory.

## Example Usage

```Dockerfile
# Use the Go base image
FROM dockerhubdevopsrv/go-base:latest

COPY . .
RUN go build -o app .

# Expose the application port
EXPOSE 8080

# Change ownership to the non-root user
RUN chown -R rvapp:rvapp /opt/app

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["./app"]
```

---
### Author: Raghu Vamsi

#### 🔗 Links
[![Linkedin](https://img.shields.io/badge/-LinkedIn-blue?style=flat&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/devops-rv/)](https://www.linkedin.com/in/devops-rv/)
[![Medium](https://img.shields.io/badge/-Medium-000000?style=flat&labelColor=000000&logo=Medium&link=https://medium.com/@DevOps-Rv)](https://medium.com/@DevOps-Rv)
