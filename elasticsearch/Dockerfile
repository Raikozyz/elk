ARG ELK_VERSION

# https://github.com/elastic/elasticsearch-docker
FROM docker.elastic.co/elasticsearch/elasticsearch:${ELK_VERSION}

# Add your elasticsearch plugins setup here
# Example: RUN elasticsearch-plugin install analysis-icu

# Hacked version
ARG ELK_VERSION
COPY --chown=elasticsearch:root x-pack-core-${ELK_VERSION}.jar /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-${ELK_VERSION}.jar
