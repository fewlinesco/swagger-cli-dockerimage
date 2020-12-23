ARG NODE_VERSION
FROM $NODE_VERSION

ENV SWAGGER_CLI_VERSION 4.0.4

RUN npm install -g @apidevtools/swagger-cli@${SWAGGER_CLI_VERSION}

CMD ["swagger-cli", "-h"]
