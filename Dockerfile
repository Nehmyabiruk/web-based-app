FROM dart:stable

# Install Flutter manually
RUN git clone https://github.com/flutter/flutter.git /flutter \
  && export PATH="/flutter/bin:$PATH" \
  && flutter doctor

ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:$PATH"

# Continue with your setup...
WORKDIR /app
COPY build/web .

RUN dart pub global activate dhttpd

EXPOSE 8080

CMD ["dhttpd", "--path", ".", "--host", "0.0.0.0", "--port", "8080"]
