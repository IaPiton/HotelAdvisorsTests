ARG JDK=20
FROM quay.io/wildfly/wildfly:latest-jdk${JDK}

# Download MySQL JDBC Connector
#ADD --chown=jboss:jboss --chmod=666 https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar /tmp/mysql-connector-j-8.3.0.jar

RUN /bin/sh -c '$JBOSS_HOME/bin/standalone.sh &' && \
    wget -P /tmp https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.3.0/mysql-connector-j-8.3.0.jar && \
    sleep 8 && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command="module add --name=com.mysql --resources=/tmp/mysql-connector-j-8.3.0.jar  --dependencies=javax.api,javax.transaction.api" && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command="/subsystem=datasources/jdbc-driver=mysql:add(driver-name=mysql,driver-module-name=com.mysql)" && \
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command='data-source add --jndi-name=java:/hotel --name=MySQLPool --connection-url=jdbc:mysql://localhost:3306/hotel --driver-name=mysql --user-name=root --password=hotel' &&\
    $JBOSS_HOME/bin/jboss-cli.sh --connect --command=":shutdown" && \
    rm -r /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current/* && \
    rm /tmp/mysql-connector-j-8.3.0.jar

# Add war to the deployments folder
ADD build/libs/*.war /opt/jboss/wildfly/standalone/deployments/