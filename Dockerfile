# Use an official Ubuntu base image
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget curl bash tar python3 python3-pip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Default command
CMD [ "bash" ]

