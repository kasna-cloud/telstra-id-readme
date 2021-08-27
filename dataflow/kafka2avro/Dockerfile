FROM gcr.io/cloud-builders/javac:8
ADD target/scala-2.12/kafka2avro-assembly-0.1.0-SNAPSHOT.jar /artifact/kafka2avro-assembly-0.1.0-SNAPSHOT.jar
ENTRYPOINT ["java", "-jar", "/artifact/kafka2avro-assembly-0.1.0-SNAPSHOT.jar"]