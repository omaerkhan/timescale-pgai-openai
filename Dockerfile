FROM timescale/timescaledb-ha:pg17

USER root

RUN cat /docker-entrypoint.sh

RUN usermod -u 1000 postgres && groupmod -g 1000 postgres

RUN echo '#!/bin/bash' > /wrapper.sh && \
    echo 'set -e' >> /wrapper.sh && \
    echo 'mkdir -p /home/postgres/pgdata/data' >> /wrapper.sh && \
    echo 'chown -R postgres:postgres /home/postgres' >> /wrapper.sh && \
    echo 'chmod -R 755 /home/postgres' >> /wrapper.sh && \
    echo 'chmod 700 /home/postgres/pgdata/data' >> /wrapper.sh && \
    echo 'exec gosu postgres /docker-entrypoint.sh "$@"' >> /wrapper.sh && \
    chmod +x /wrapper.sh

ARG OPENAI_API_KEY
ARG POSTGRES_PASSWORD
ENV OPENAI_API_KEY=${OPENAI_API_KEY} \
    POSTGRES_PASSWORD=${POSTGRES_PASSWORD}

EXPOSE 5432 8008 8081

ENTRYPOINT ["/wrapper.sh"]
CMD ["postgres"]

