FROM lwieske/java-8:jdk-8u171

ADD ./notary /opt/corda/notary

WORKDIR /opt/corda/notary

VOLUME [ "/opt/corda/notary" ]
    
EXPOSE 60100 60101 60102 60103 12001

CMD [ "./start.sh" ]