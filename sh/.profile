fortune
PDFVIEWER_texdoc=zathura
PATH=${PATH}:~/bin
JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
HADOOP_HOME=/shared/hadoop
HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
HADOOP_LOG_DIR=${HADOOP_HOME}/logs
PATH=${PATH}:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin
eval `ssh-agent -s` > /dev/null
SPARK_HOME=/shared/spark
PATH=$PATH:${SPARK_HOME}/sbin:${SPARK_HOME}/bin
