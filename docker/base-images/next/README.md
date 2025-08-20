# Next.js Base Image for Amazon Linux 2023

This Dockerfile builds a base image for Next.js applications, specifically targeting Amazon Linux 2023. It sets up a clean environment with Node.js for building and running Next.js applications.

## Features

- **Base Image:** Uses the latest Amazon Linux 2023 minimal image for a lightweight and secure foundation.
- **Node.js Installation:** Installs the specified Node.js version (default 18.x).
- **User Setup:** Creates a dedicated system user (`rvapp`) with a home directory (`/opt/app`) for application files.
- **Working Directory:** Sets the working directory to `/opt/app` for convenience.

## Usage

1. **Build the Image:**

   ```bash
   docker build -t next-base:latest .
   ```

2. **Run a Container:**

   ```bash
   docker run -it next-base /bin/bash
   ```

## Customization

- **Node.js Version:** Modify the `ARG NODE_VERSION` to install a different Node.js version. You can find available versions at [Node.js Downloads](https://nodejs.org/en/download/).
- **Application Code:** Copy your Next.js application code into the `/opt/app` directory.

## Example Usage

```Dockerfile
# Use the Next.js base image
FROM dockerhubdevopsrv/next-base:latest

COPY . .
RUN npm install && npm run build

# Expose the application port
EXPOSE 8080

# Change ownership to the non-root user
RUN chown -R rvapp:rvapp /opt/app

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["npm", "start"]
```

---
### Author: Raghu Vamsi

#### 🔗 Links
[![Linkedin](https://img.shields.io/badge/-LinkedIn-blue?style=flat&logo=Linkedin&logoColor=white&link=https://www.linkedin.com/in/devops-rv/)](https://www.linkedin.com/in/devops-rv/)
[![Medium](https://img.shields.io/badge/-Medium-000000?style=flat&labelColor=000000&logo=Medium&link=https://medium.com/@DevOps-Rv)](https://medium.com/@DevOps-Rv)
