
javac -cp mongo.jar ReadLoad.java



#TODO make host and # of documents input variables 
java -cp mongo.jar:. ReadLoad "<InsertIP>.compute-1.amazonaws.com:27017" 10 10000
