//add shards
db.adminCommand( {"addshard" : "localhost:29017", "name" : "db0" });
db.adminCommand( {"addshard" : "localhost:29018", "name" : "db1"});
db.adminCommand( {"addshard" : "localhost:29019", "name" : "db2"});
db.adminCommand( {"addshard" : "localhost:29020", "name" : "db3"});
db.adminCommand( {"addshard" : "localhost:29021", "name" : "db4"});
db.adminCommand( {"addshard" : "localhost:29022", "name" : "db5"});
db.adminCommand( {"addshard" : "localhost:29023", "name" : "db6"});
db.adminCommand( {"addshard" : "localhost:29024", "name" : "db7"});

//enable sharding in collection
db.adminCommand( {"enablesharding" : "test"} );
db.adminCommand( {"shardcollection" : "test.locations", "key" : { "region" : 1, "val" : 1}}); //Shardkey is region which will be one of 7 continents or misc and val which is a randomly generated value for some data distro across chunks.

//Create tag ranges
sh.addTagRange( "test.locations",  { region : "Africa" }, { region : "Antartica"}, "Africa" );
sh.addTagRange( "test.locations",  { region : "Antartica" }, { region : "Asia"}, "Antartica" );
sh.addTagRange( "test.locations",  { region : "Asia" }, { region : "Australia"}, "Asia" );
sh.addTagRange( "test.locations",  { region : "Australia" }, { region : "Europe"}, "Australia" );
sh.addTagRange( "test.locations",  { region : "Europe" }, { region : "Misc"}, "Europe" );
sh.addTagRange( "test.locations",  { region : "Misc" }, { region : "North America"}, "Misc" );
sh.addTagRange( "test.locations",  { region : "North America" }, { region : "South America"}, "North America" );
sh.addTagRange( "test.locations",  { region : "South America" }, { region : MaxKey }, "South America" );//Probaby defensive programming, all the leftover data should go to the only non tagged shard left anyway.

//Attach range to particular shards

sh.addShardTag( "db0", "Africa" );
sh.addShardTag( "db1", "Antartica" );
sh.addShardTag( "db2", "Asia" );
sh.addShardTag( "db3", "Australia" );
sh.addShardTag( "db4", "Europe" );
sh.addShardTag( "db5", "Misc" );
sh.addShardTag( "db6", "North America" );
sh.addShardTag( "db7", "South America" );


//Pre-split tag ranges for edge case
sh.splitAt( "test.locations", { region : "Africa", val : MinKey})
sh.splitAt( "test.locations", { region : "Antartica", val : MinKey })
sh.splitAt( "test.locations", { region : "Asia", val : MinKey })
sh.splitAt( "test.locations", { region : "Australia", val : MinKey})
sh.splitAt( "test.locations", { region : "Europe", val : MinKey})
sh.splitAt( "test.locations", { region : "Misc", val : MinKey })
sh.splitAt( "test.locations", { region : "North America", val : MinKey })
sh.splitAt( "test.locations", { region : "South America", val : MinKey })






