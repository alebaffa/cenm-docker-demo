FROM lwieske/java-8:jdk-8u171

ADD ./node01 /opt/corda/node01

WORKDIR /opt/corda/node01

VOLUME [ "/opt/corda/node01" ]

EXPOSE 61100 61101

CMD [ "./start.sh" ]