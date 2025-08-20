# Use the latest Angular base image
FROM dockerhubdevopsrv/angular-base:latest

# Set the working directory
WORKDIR /opt/app

# Copy the application code
COPY . .

# Install dependencies and build the application
RUN npm install && npm run build

# Expose the application port
EXPOSE 8080

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["npm", "start"]
