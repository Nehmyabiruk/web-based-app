# Use Flutter SDK image
FROM ghcr.io/flutter/flutter:stable

# Set working directory
WORKDIR /app

# Copy your web build output
COPY build/web .

# Install a simple Dart HTTP server
RUN dart pub global activate dhttpd

# Expose port 8080
EXPOSE 8080

# Run the server
CMD ["dhttpd", "--path", ".", "--host", "0.0.0.0", "--port", "8080"]
