#!/usr/bin/env bash
set -e

if [ -z "$1" ];then
    version="druid-0.10.0"
fi

if [ -z "$2" ];then
    versionz="zookeeper-3.4.6"
fi

# Downloading druid
if [ ! -f ${version}-bin.tar.gz ];then
    echo "Downloading druid"
    curl -O http://static.druid.io/artifacts/releases/${version}-bin.tar.gz
fi

# Downloading Zookeeper
if [ ! -f ${versionz}.tar.gz ];then
    echo "Downloading Zookeeper"
    curl -O http://apache.mirror.anlx.net/zookeeper/${versionz}/${versionz}.tar.gz
fi

# Install Druid
if [ -d ${version} ];then
    rm -r ${version}
fi
tar -xzf ${version}-bin.tar.gz
cd ${version}

# Install and start up Zookeeper
cp ../${versionz}.tar.gz ./
if [ -d ${versionz} ];then
    rm -r ${versionz}
fi
tar -xzf ${versionz}.tar.gz
cd ${versionz}
cp conf/zoo_sample.cfg conf/zoo.cfg
sudo ./bin/zkServer.sh start

# Start up Druid services
cd ..
bin/init
java `cat conf-quickstart/druid/historical/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/historical:lib/*" io.druid.cli.Main server historical &
java `cat conf-quickstart/druid/broker/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/broker:lib/*" io.druid.cli.Main server broker &
java `cat conf-quickstart/druid/coordinator/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/coordinator:lib/*" io.druid.cli.Main server coordinator &
java `cat conf-quickstart/druid/overlord/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/overlord:lib/*" io.druid.cli.Main server overlord &
java `cat conf-quickstart/druid/middleManager/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/middleManager:lib/*" io.druid.cli.Main server middleManager &
