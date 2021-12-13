FROM java:8
WORKDIR /
ADD target/spring-petclinic-2.5.0-SNAPSHOT.jar  spring-petclinic-2.5.0-SNAPSHOT.jar
EXPOSE 8080
CMD java -jar -Dmanagement.security.enabled=false  spring-petclinic-2.5.0-SNAPSHOT.jar
