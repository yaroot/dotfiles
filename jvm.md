
## java home

```
JAVA_HOME=/opt/java7 PATH=/opt/java7/bin:/opt/java7/jre/bin:$PATH sbt
```

## proxy

```
_JAVA_OPTIONS="-Dhttp.proxyServer=127.0.0.1 -Dhttp.proxyPort=7051" sbt
```

## GC log

```
'
-Xloggc:gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps
-XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=30 -XX:GCLogFileSize=10m
'
```

## CMS gc

```
'
-Xmx1g -Xms1g
-XX:+UseConcMarkSweepGC -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=80
-XX:NewRatio=1 -XX:SurvivorRatio=3 -Xmn512m
'
```
