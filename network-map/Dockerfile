FROM lwieske/java-8:jdk-8u171

ADD ./network-map /opt/corda/network-map

WORKDIR /opt/corda/network-map

VOLUME [ "/opt/corda/network-map" ]

EXPOSE 22 3330 20000

CMD [ "./start.sh" ]