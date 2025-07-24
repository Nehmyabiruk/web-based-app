# Use Flutter SDK image (with web support)
FROM ghcr.io/cirruslabs/flutter:3.22.1

# Set working directory inside the container
WORKDIR /app

# Copy all your files into the container
COPY . .

# Install dependencies
RUN flutter pub get

# Build your Flutter web project
RUN flutter build web

# Install lightweight static file server
RUN dart pub global activate dhttpd

# Expose the default port
EXPOSE 8080

# Start server to serve built web files
CMD ["dhttpd", "--path", "build/web", "--host", "0.0.0.0", "--port", "8080"]
