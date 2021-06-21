FROM openjdk:8

RUN mkdir /usr/petclinicapp
COPY targettemp/*.jar /usr/petclinicapp
WORKDIR /usr/petclinicapp

ARG app_port
EXPOSE ${app_port} 

RUN mv ./* spring-petclinic-latest.jar
ENTRYPOINT ["java","-jar","spring-petclinic-latest.jar", "--server.port=${app_port}"]
