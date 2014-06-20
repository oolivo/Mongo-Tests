
javac -cp mongo.jar UpdateLoad.java



#TODO make host and # of documents input variables 
java -cp mongo.jar:. UpdateLoad "<Insert IP>.amazonaws.com:27017" 10 10000
