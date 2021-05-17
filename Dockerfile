FROM ubuntu as compiler

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && apt-get install -y -qq --no-install-recommends tzdata && apt-get install -y -qq maven openjdk-11-jdk git
RUN git clone https://github.com/esig/dss-demonstrations.git

VOLUME /dss-demonstrations
WORKDIR /dss-demonstrations
ARG DSSPATH=/dss-demo-webapp/target

RUN mvn verify && cp $DSSPATH/$(ls -1 $DSSPATH| grep war) $DSSPATH/dss-demo-webapp.war

FROM tomcat:9-jdk11
EXPOSE 8081/tcp
EXPOSE 8080/tcp

VOLUME /dss-demonstrations
WORKDIR /dss-demonstrations
ARG DSSPATH=/dss-demo-webapp/target

COPY --from=compiler $DSSPATH/dss-demo-webapp.war /usr/local/tomcat/webapps/

#RUN /opt/jboss/wildfly/bin/add-user.sh admin Password1! --silent
#CMD /opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement=0.0.0.0
#STOPSIGNAL /opt/jboss/wildfly/bin/standalone.sh stop
#HEALTHCHECK /opt/jboss/wildfly/bin/standalone.sh status