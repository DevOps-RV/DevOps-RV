# Use the latest Next.js base image
FROM dockerhubdevopsrv/next-base:latest

# Set the working directory
WORKDIR /opt/app

# Copy the application code into the working directory
COPY . .

# Install dependencies and build the application
RUN npm install && npm run build

# Expose the application port
EXPOSE 8080

# Change ownership to the non-root user
RUN chown -R rvapp:rvapp /opt/app

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["npm", "start"]
