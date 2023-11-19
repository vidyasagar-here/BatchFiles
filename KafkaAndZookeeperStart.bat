@echo off
rem ************************************************************
rem Installs Kafka (and Zookeeper) as services and runs them
rem ************************************************************

set NSSM_VER=2.24

set TMP_ROOT=c:\tmp
set OPT_ROOT=D:\Tools
set KAFKA_ROOT=%OPT_ROOT%\kafka
set NSSM_ROOT=D:\Tools\nssm-2.24-101-g897c7ad\
set KAFDROP_ROOT=D:\Tools\BatchFiles

pushd %NSSM_ROOT%\win64
nssm install Zookeeper %KAFKA_ROOT%\bin\windows\zookeeper-server-start.bat ..\..\config\zookeeper.properties
nssm install Kafka %KAFKA_ROOT%\bin\windows\kafka-server-start.bat %KAFKA_ROOT%\config\server.properties
nssm install KafDrop %KAFDROP_ROOT%\KafDropStarter.bat
nssm set KafDrop DependOnService Kafka DependOnService Zookeeper

sc start zookeeper
timeout 10
sc start kafka
timeout 5
sc start DependOnService
popd