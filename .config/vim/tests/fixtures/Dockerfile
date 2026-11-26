FROM alpine:3.22
# Syntax sample only; this file is not built by the checks.
ARG APP_NAME=drupal
ENV APP_NAME=${APP_NAME}
WORKDIR /app
COPY . /app
CMD ["sh", "-c", "printf '%s\\n' \"$APP_NAME\""]
