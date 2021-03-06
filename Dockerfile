FROM arm64v8/python:3.5-alpine3.10

COPY ./entrypoint.sh /tmp/entrypoint.sh

LABEL org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.docker.dockerfile=".docker/Dockerfile.alpine" \
    org.label-schema.license="GNU" \
    org.label-schema.name="miflora-mqtt" \
    org.label-schema.version=${BUILD_VERSION} \
    org.label-schema.description="Xiaomi Mi Flora Plant Sensor MQTT Client/Daemon" \
    org.label-schema.url="https://github.com/ThomDietrich/miflora-mqtt-daemon" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/ThomDietrich/miflora-mqtt-daemon" \
    maintainer="Raymond M Mouthaan <raymondmmouthaan@gmail.com>"

RUN set -ex \
    && apk add --no-cache --virtual .build-deps \
       git \
    && apk add --no-cache \
        bluez \
        bluez-deprecated \
        tzdata \
    && git clone https://github.com/ThomDietrich/miflora-mqtt-daemon.git /tmp/miflora-mqtt-daemon \
    && mkdir -p /opt/miflora-mqtt-daemon \
    && cp /tmp/entrypoint.sh /opt/miflora-mqtt-daemon/entrypoint.sh \
    && cp /tmp/miflora-mqtt-daemon/miflora-mqtt-daemon.py /opt/miflora-mqtt-daemon/miflora-mqtt-daemon.py \
    && cp /tmp/miflora-mqtt-daemon/config.ini.dist /opt/miflora-mqtt-daemon/config.ini.dist \
    && cp /tmp/miflora-mqtt-daemon/AUTHORS /opt/miflora-mqtt-daemon/AUTHORS \
    && cp /tmp/miflora-mqtt-daemon/LICENSE /opt/miflora-mqtt-daemon/LICENSE \
    && pip install miflora==0.6 paho-mqtt==1.5.0 sdnotify==0.3.2 colorama==0.4.3 Unidecode==1.1.1 \
    && adduser -D -u 1000 miflora \
    && chgrp -Rf root /opt/miflora-mqtt-daemon \
    && chmod -Rf g+w /opt/miflora-mqtt-daemon \
    && chown -Rf miflora /opt/miflora-mqtt-daemon \
    && chmod +x /opt/miflora-mqtt-daemon/entrypoint.sh \
    && mkdir /config \
    && chown miflora /config \
    && rm -rf /tmp/* \
    && apk del .build-deps \
    && rm -rf /var/cache/apk/*

WORKDIR /opt/miflora-mqtt-daemon

USER miflora

ENTRYPOINT ["/opt/miflora-mqtt-daemon/entrypoint.sh"]

USER miflora

VOLUME ["/config"]
