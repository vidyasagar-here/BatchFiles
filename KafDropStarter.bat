@echo off

set KAFDROP_ROOT=D:\Tools\kafdrop-4.0.1
start java -jar %KAFDROP_ROOT%\kafdrop.jar -kafka.brokerConnect=localhost:9092