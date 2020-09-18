FROM lwieske/java-8:jdk-8u171

ADD ./farm /opt/corda/farm

WORKDIR /opt/corda/farm

VOLUME [ "/opt/corda/farm" ]

EXPOSE 8080

CMD [ "./start.sh" ]