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
ENV GROUP_ID mmX

USER 1234
CMD /opt/mirrormaker/run.sh
