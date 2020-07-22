**Setting up Apache Spark and Livy on Docker Swarm**
In [Part1](https://medium.com/@ameennagiwale/setting-up-apache-spark-livy-and-hadoop-cluster-using-docker-swarm-part-1-2-432a99eed2b8), we have created a swarm and deployed Hadoop YARN service. In the same docker, swarm environment will deploy Apache spark and livy services so Spark jobs can run on already deployed Hadoop cluster.

**Livy Server Configuration**
**Livy.conf** contains the server configuration. The Livy distribution ships with a default configuration file template listing available configuration keys and their default values.

Add below-mentioned properties to Livy.conf :

**# How long a finished session state should be kept in LivyServer for query**.
livy.server.session.state-retain.sec = 600s
**# What spark master Livy sessions should use**.
livy.spark.master = yarn
**# What spark deploy mode Livy sessions should use**.
livy.spark.deployMode = client

As Livy launches Spark jobs asynchronously to keep track of spark job’s progress we need to poll Livy server for the job status through the REST api so that we need session state to be maintained for a specific duration.

**livy.server.session.state-retain.sec ≥ Time taken to complete Spark job**

Though my spark job is taking 5 min to finish I have kept live.server.session.state-retain.sec to 10 mins
Commands to execute

- **Pull docker**

Pull docker ameen4827/locale-spark image
_**# docker pull ameen4827/locale-spark:0.6**_

**

- Bring up Apache Spark Node

**
Execute below mentioned commands on slave01 to bring up Apache Spark nodes

**_docker service create \
--name spark-livy \
--hostname spark-livy \
--constraint node.hostname==slave01 \
--network hadoop-net \
--replicas 1 \
--endpoint-mode dnsrr \
--mount type=bind,src=/data/hadoop/config,dst=/config/hadoop \
--mount type=bind,src=/data/hadoop/hdfs,dst=/tmp/hadoop-root \
--mount type=bind,src=/data/hadoop/logs,dst=/usr/local/hadoop/logs \
ameen4827/locale-spark:0.6_**

You can modify and copy **_hdfs-site.xml, core-site.xml, yarn-site.xml, slaves_** in the Spark config directory. In a Spark cluster running on YARN, these configuration files are set cluster-wide.

With this, we can run Spark jobs on a Hadoop YARN cluster, which we have set up in Part 1

Sample config files for your reference are available here

- **Check Services in Docker Swarm**

Start Apache Livy Service

Login to the master node (slave01) using below mentioned command

**_# docker exec -it spark-livy.1.iy2t2imuke3cklgwbnze03kbb bash_**

**Check status of Livy service**
**_# $LIVY_HOME/bin/livy-server status
# $LIVY_HOME/bin/livy-server start_**

**

- Validate Installation

**
By default Livy runs on port 8998,hit this url in the browser **_http://livy-server:8998/ui_** to validate the installation
Image for post
Apache livy

References
Docker Image Github: https://github.com/ammnlab/docker
