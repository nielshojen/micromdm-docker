FROM alpine:3.3

ENV MICROMDM_VERSION=1.3.0

COPY run.sh /run.sh

RUN apk --no-cache add curl
RUN curl -L https://github.com/micromdm/micromdm/releases/download/v${MICROMDM_VERSION}/micromdm_v${MICROMDM_VERSION}.zip -o /micromdm.zip
RUN unzip /micromdm.zip
RUN rm /micromdm.zip
RUN mv /build/linux/micromdm /
RUN rm -r /build
RUN chmod a+x /micromdm
RUN apk del curl
RUN mkdir /config /certs /repo
RUN chmod a+x /run.sh

EXPOSE 80 443 8080

VOLUME ["/config","/certs","/repo"]

CMD ["/run.sh"]
