#!/bin/sh

#cleanup from previous runs
killall mongod mongos || true
sleep 1
rm -rf /data/db/*
mkdir /data/db || true
mkdir /data/configdb1 || true
mkdir /data/configdb2 || true
mkdir /data/configdb3 || true
mkdir /data/sh1 || true
mkdir /data/sh2 || true
mkdir /data/sh3 || true
mkdir /data/sh4 || true

rm -rf /data/configdb1/*
rm -rf /data/configdb2/*
rm -rf /data/configdb3/*
rm -rf /data/sh1/*
rm -rf /data/sh2/*
rm -rf /data/sh4/*
rm -rf /data/sh4/*



#echo "adfajfskfdjldfjdsfjas" > /data/key
#chmod 600 /data/key
sleep 1

#set up config servers
#mongod  --configsvr --port 28019 --nojournal --fork --dbpath /data/configdb1 --logpath /data/configdb1.log
#mongod  --configsvr --port 28020 --nojournal --fork --dbpath /data/configdb2 --logpath /data/configdb2.log
../mongod  --configsvr --port 28021 --nojournal --fork --dbpath /data/configdb3 --logpath /data/configdb3.log

#launch shards
../mongod --shardsvr --nojournal --fork --dbpath /data/sh1 --logpath /data/db.log1 --port 27017
../mongod --shardsvr --nojournal --fork --dbpath /data/sh2 --logpath /data/db.log2 --port 27018
../mongod --shardsvr --nojournal --fork --dbpath /data/sh3 --logpath /data/db.log3 --port 27019
../mongod --shardsvr --nojournal --fork --dbpath /data/sh4 --logpath /data/db.log4 --port 27020


sleep 1
#launch mongos
#mongos --configdb localhost:28019,localhost:28020,localhost:28021 --fork --logpath /data/mongos.log --port 29017
../mongos --configdb localhost:28021 --fork --logpath /data/mongos.log --port 29017

sleep 1

#add shards
../mongo  --port 29017 --eval 'sh.addShard("localhost:27017")'
sleep 2
../mongo  --port 29017 --eval 'sh.addShard("localhost:27018")'
sleep 2
../mongo  --port 29017 --eval 'sh.addShard("localhost:27019")'
sleep 2
../mongo  --port 29017 --eval 'sh.addShard("localhost:27020")'

sleep 1
#set up collections

../mongo  --port 29017 --eval 'db.adminCommand( { enablesharding:"sharded" } );'
sleep 1
../mongo  --port 29017 --eval 'db.adminCommand( { shardcollection:"sharded.sharded", key:{ _id: 1 } } );'
sleep 1


../mongo  --port 29017 --eval 'db.adminCommand( { enablesharding:"hashed" } );'
sleep 1
../mongo  --port 29017 --eval 'db.adminCommand( { shardcollection:"hashed.hashed", key:{ _id: "hashed" } } );'
sleep

#presplit collection

../mongo  --port 29017 --eval 'sh.splitAt("sharded.sharded", {_id: 250});'
sleep 1
../mongo  --port 29017 --eval 'sh.splitAt("sharded.sharded", {_id: 500});'
sleep 1 
../mongo  --port 29017 --eval 'sh.splitAt("sharded.sharded", {_id: 750});'
sleep 1




