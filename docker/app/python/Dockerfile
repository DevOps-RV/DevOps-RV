# Use the latest Amazon Linux 2023 as the base image
FROM dockerhubdevopsrv/python-base:latest

# Copy the application code
COPY . .

# Install dependencies
RUN set -eux; \
        pip install --upgrade pip; \
        pip install -r ./src/requirements.txt

# Expose the application port
EXPOSE 8080

# Change ownership to the non-root user
RUN chown -R rvapp:rvapp /opt/app

# Switch to the non-root user
USER rvapp

# Run the application
CMD ["python", "./src/app.py"]