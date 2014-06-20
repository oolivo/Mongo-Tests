#!/bin/bash

#file for one time use to create directories needed to run servers. Make sure you set permissions to be correct. Or run the whole thing as root if thats preferable
#create shard data dir
mkdir -p /data/sharded/db0
mkdir -p /data/sharded/db1
mkdir -p /data/sharded/db2
mkdir -p /data/sharded/db3
mkdir -p /data/sharded/db4
mkdir -p /data/sharded/db5
mkdir -p /data/sharded/db6
mkdir -p /data/sharded/db7

#create shard config data dir
mkdir -p /data/sharded/configsvr0
mkdir -p /data/sharded/configsvr1
mkdir -p /data/sharded/configsvr2

#create dir for logs
mkdir -p /logs/sharded
