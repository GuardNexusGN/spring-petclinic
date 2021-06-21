FROM openjdk:8

RUN mkdir /usr/petclinicapp
COPY targettemp/*.jar /usr/petclinicapp
WORKDIR /usr/petclinicapp

ARG APPD_PORT
EXPOSE $APPD_PORT

RUN mv ./* spring-petclinic-latest.jar
ENTRYPOINT ["java","-jar","spring-petclinic-latest.jar", "--server.port=${APPD_PORT}"]
