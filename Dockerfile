FROM bitnami/kafka:2.8.0-debian-10-r68
USER root
RUN install_packages gettext

ADD ./mm2.template /opt/mirrormaker/mm2.template
ADD ./run.sh /opt/mirrormaker/run.sh
RUN chmod +x /opt/mirrormaker/run.sh

RUN mkdir -p /var/run/mirrormaker
RUN chown 1234 /var/run/mirrormaker

ENV TOPICS .*
ENV DESTINATION "source-cluster:9092"
ENV SOURCE "localhost:9092"
ENV GROUP_ID mmgroupidX
ENV CLIENT_ID mmclientidX
ENV SYNC_GROUP_OFFSET_ENABLED false
ENV KAFKA_HEAP_OPTS "-Xms1024m -Xmx1024m"
ENV NAME_SOURCE A
ENV NAME_DESTINATION B
ENV SCHEDULED_REBALANCE_MAX_DELAY_MS 300000
ENV EMIT_CHECKPOINTS_INTERVAL_SECONDS 60
ENV AUTO_OFFSET_RESET earliest


USER 1234
CMD /opt/mirrormaker/run.sh
