# Use the latest Go base image
FROM dockerhubdevopsrv/go-base:latest

# Set the working directory
WORKDIR /opt/app

# Copy the application code
COPY . .

# Build the application
RUN go build -o app .

# Change ownership to the non-root user
RUN chown -R rvapp:rvapp /opt/app

# Expose the application port
EXPOSE 8080

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["./app"]
