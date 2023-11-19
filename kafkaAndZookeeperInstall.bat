@echo off
rem ************************************************************
rem Installs Kafka (and Zookeeper) as services and runs them
rem ************************************************************

set NSSM_VER=2.24

set TMP_ROOT=c:\tmp
set OPT_ROOT=D:\Tools
set KAFKA_ROOT=%OPT_ROOT%\kafka
set NSSM_ROOT=D:\Tools\nssm-2.24-101-g897c7ad\

mkdir %OPT_ROOT%
mkdir %TMP_ROOT%

rem stop and from zookeeper and kafka services
sc stop kafka
sc stop zookeeper
timeout 5
sc delete kafka
sc delete zookeeper
timeout 2

rem remove the old kafka install if there
rmdir /q /s %KAFKA_ROOT%

rem remove the old zookeeper and kafka config if there
pushd %TMP_ROOT%
rmdir /q /s kafka-logs
rmdir /q /s zookeeper
popd

rem install kafka and zookeeper to %OPT_ROOT%
7z x -y kafka_*.tgz
7z x -y -o%OPT_ROOT% kafka_*.tar
move /Y %OPT_ROOT%\kafka* %KAFKA_ROOT%
echo delete.topic.enable = true >> %KAFKA_ROOT%/config/server.properties

rem install kafka and zookeeper as services and start them
rmdir /s /q nssm-%NSSM_VER%
7z x -y nssm-%NSSM_VER%.zip
pushd %NSSM_ROOT%\win64
nssm install zookeeper %KAFKA_ROOT%\bin\windows\zookeeper-server-start.bat ..\..\config\zookeeper.properties
nssm install kafka %KAFKA_ROOT%\bin\windows\kafka-server-start.bat %KAFKA_ROOT%\config\server.properties
nssm set kafka DependOnService zookeeper

sc start zookeeper
timeout 5
sc start kafka
popd