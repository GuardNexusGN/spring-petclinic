FROM openjdk:8
COPY targettemp/*.jar /usr/src/myapp
WORKDIR /usr/src/myapp

ARG app_port
EXPOSE ${app_port} 

RUN mv ./* spring-petclinic-latest.jar
CMD [ "java", "spring-petclinic-latest", "--server.port=${app_port}" ]
