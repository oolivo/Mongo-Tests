
javac -cp mongo.jar WriteLoad.java



#TODO make host and # of documents input variables 
java -cp mongo.jar:. WriteLoad "<insert IP address>.compute-1.amazonaws.com:27017" 10 10000
