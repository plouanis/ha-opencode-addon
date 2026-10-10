ARG BUILD_FROM
FROM ${BUILD_FROM}
RUN npm install -g opencode-ai@latest
COPY run.sh /run.sh
RUN chmod a+x /run.sh
ENTRYPOINT ["/bin/sh", "/run.sh"]