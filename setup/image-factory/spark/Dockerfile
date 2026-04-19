FROM apache/spark:4.0.2

COPY /spark/jars/hadoop-aws-3.4.1.jar /opt/spark/jars/hadoop-aws-3.4.1.jar
COPY /spark/jars/bundle-2.42.35.jar /opt/spark/jars/bundle-2.42.35.jar

ENV SPARK_EXTRA_CLASSPATH=/opt/spark/extra-jars/*
COPY ./spark/extra-jars /opt/spark/extra-jars/