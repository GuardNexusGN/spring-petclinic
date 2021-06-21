FROM openjdk:8

RUN mkdir /usr/src/app
COPY targettemp/*.jar /usr/src/app
WORKDIR /usr/src/app

ARG app_port
EXPOSE ${app_port} 

RUN mv ./* spring-petclinic-latest.jar
CMD [ "java", "spring-petclinic-latest", "--server.port=${app_port}" ]
