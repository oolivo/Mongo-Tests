#!/bin/bash

mongod --dbpath /data/sharded/db0 --port 29017 --logpath /logs/sharded/db0.log --fork  --shardsvr
mongod --dbpath /data/sharded/db1 --port 29018 --logpath /logs/sharded/db1.log --fork  --shardsvr
mongod --dbpath /data/sharded/db2 --port 29019 --logpath /logs/sharded/db2.log --fork  --shardsvr
mongod --dbpath /data/sharded/db3 --port 29020 --logpath /logs/sharded/db3.log --fork  --shardsvr
mongod --dbpath /data/sharded/db4 --port 29021 --logpath /logs/sharded/db4.log --fork  --shardsvr
mongod --dbpath /data/sharded/db5 --port 29022 --logpath /logs/sharded/db5.log --fork  --shardsvr
mongod --dbpath /data/sharded/db6 --port 29023 --logpath /logs/sharded/db6.log --fork  --shardsvr
mongod --dbpath /data/sharded/db7 --port 29024 --logpath /logs/sharded/db7.log --fork  --shardsvr
mongod --configsvr --dbpath /data/sharded/configsvr0 --port 29025 --logpath /logs/sharded/configsvr0.log --fork 
mongod --configsvr --dbpath /data/sharded/configsvr1 --port 29026 --logpath /logs/sharded/configsvr1.log --fork 
mongod --configsvr --dbpath /data/sharded/configsvr2 --port 29027 --logpath /logs/sharded/configsvr2.log --fork 


sleep 10 #this is arbitrary 
mongos --configdb localhost:29025,localhost:29026,localhost:29027 --port 29028 --logpath /logs/sharded/mongos0.log --fork 
