#DockerFile 
#CDH-SparkGW-CDSW-Hail Engine
#Author: rswenson@cloudera.com
#v1.0

#Obtain CDSW base Engine
FROM docker.repository.cloudera.com/cdsw/engine:8

#Update base OS 
RUN apt-get update

#Working Dir
WORKDIR /usr/local

#Obtain LZ4 Library Headers, as CDSW base only provides LZ4
RUN apt-get install -y liblz4-tool && apt-get install -y liblz4-dev

#Utilities
RUN apt-get install -y wget && apt-get -y install git

#Obtain Hail Gradle and Sparl Parcel Dependencies, Update as required for versioning
RUN wget -r https://services.gradle.org/distributions/gradle-4.10.2-bin.zip && unzip services.gradle.org/distributions/gradle-4.10.2-bin.zip
RUN wget -r http://archive.cloudera.com/spark2/parcels/latest/SPARK2-2.4.0.cloudera2-1.cdh5.13.3.p0.1041012-xenial.parcel && tar xvf archive.cloudera.com/spark2/parcels/latest/SPARK2-2.4.0.cloudera2-1.cdh5.13.3.p0.1041012-xenial.parcel

#Obtain latest Hail sources 
WORKDIR /usr/local
RUN git clone https://github.com/hail-is/hail.git
RUN ls -al

#Build Hail for Tertiary
RUN export SPARK_HOME=/usr/local/archive.cloudera.com/spark2/parcels/latest/SPARK2-2.4.0.cloudera2-1.cdh5.13.3.p0.1041012-xenial.parcel
RUN export PATH=$PATH:/usr/local/services.gradle.org/distributions/gradle-4.10.2/bin
RUN ls -al
WORKDIR /usr/local/hail/hail
RUN make install-on-cluster HAIL_COMPILE_NATIVES=1 SPARK_VERSION=2.4.0 PY4J_VERSION=0.10.7

#Update R version
#WORKDIR /usr/local
#RUN wget https://raw.githubusercontent.com/rjwswenson/mpaga/master/updateR.sh
#RUN chmod 700 updateR.sh
#RUN ./updateR.sh

#Prepare BioC and Bio3d libs for transcriptome, proteome, metagenome, epigenome, and molecular dyanmics 
#WORKDIR /usr/local
#RUN wget https://raw.githubusercontent.com/rjwswenson/mpaga/master/addBioC.r
#RUN chmod 700 addBioC.r
#RUN /usr/local/bin/R -f /usr/local/addBioC.r

