# Start from the code-server Debian base image
FROM codercom/code-server:4.9.0

# Switch to root user for administrative tasks
USER root

# Install required packages with elevated privileges
RUN apt-get update && \
    apt-get install -y \
    sudo \
    ffmpeg \
    wget \
    curl \
    unzip \
    mc \
    gnupg2 \
    ca-certificates \
    lsb-release && \
    apt-get clean

# Install Node.js (v18), npm, and yarn
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    apt-get install -y yarn

# Install rclone (support for remote filesystem)
RUN curl https://rclone.org/install.sh | bash

# Ensure the .local directory exists and set ownership
RUN mkdir -p /home/coder/.local && chown -R coder:coder /home/coder/.local

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Set environment variable for port
ENV PORT=8080

# Use custom entrypoint script
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
