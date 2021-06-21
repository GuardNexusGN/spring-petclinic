FROM openjdk:8

RUN mkdir /usr/petclinicapp
COPY targettemp/*.jar /usr/petclinicapp
WORKDIR /usr/petclinicapp

ARG app_port
EXPOSE ${app_port} 

RUN mv ./* spring-petclinic-latest.jar
CMD [ "java", "spring-petclinic-latest", "--server.port=${app_port}" ]
