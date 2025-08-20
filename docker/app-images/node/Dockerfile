# Use the latest Node.js base image
FROM dockerhubdevopsrv/node-base:latest

# Set the working directory
WORKDIR /opt/app

# Copy the application code
COPY . .

# Install dependencies
RUN npm install

# Expose the application port
EXPOSE 8080

# Change ownership to the non-root user
RUN chown -R rvapp:rvapp /opt/app

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["node", "app.js"]
