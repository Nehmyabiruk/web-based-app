FROM cirrusci/flutter:3.19.6

WORKDIR /app
COPY . .

RUN flutter pub get
RUN flutter build web

EXPOSE 8080

CMD ["flutter", "pub", "global", "run", "dhttpd", "--path", "build/web", "--host", "0.0.0.0", "--port", "8080"]
