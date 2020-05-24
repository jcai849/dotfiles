export PDFVIEWER_texdoc=zathura
export PATH=${PATH}:~/bin
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export HADOOP_HOME=/shared/hadoop
export HADOOP_CONF_DIR=${HADOOP_HOME}/etc/hadoop
export HADOOP_LOG_DIR=${HADOOP_HOME}/logs
export PATH=${PATH}:${HADOOP_HOME}/sbin:${HADOOP_HOME}/bin
eval `ssh-agent -s` > /dev/null
export SPARK_HOME=/shared/spark
export PATH=$PATH:${SPARK_HOME}/sbin:${SPARK_HOME}/bin
