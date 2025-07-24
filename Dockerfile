# Use Flutter SDK with Dart >= 3.5.4 (this one has Dart 3.5.4 inside)
FROM ghcr.io/cirruslabs/flutter:3.22.1

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Enable Flutter web
RUN flutter config --enable-web

# Get packages
RUN flutter pub get

# Build the web version
RUN flutter build web

# Install simple HTTP server
RUN dart pub global activate dhttpd

# Expose port
EXPOSE 8080

# Start server for built site
CMD ["dhttpd", "--path", "build/web", "--host", "0.0.0.0", "--port", "8080"]
