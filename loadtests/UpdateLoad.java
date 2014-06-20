import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicLong;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;
import com.mongodb.WriteConcern;
import com.mongodb.MongoClientOptions.Builder;
import com.mongodb.WriteResult;
import java.lang.*;

//@Author Oz
public class UpdateLoad {
    
    private static final int THREADS = 1;
    // private static final int DOCUMENTS = 4000000;
    private static int DOCUMENTS = 5000;
    private static final AtomicLong total = new AtomicLong();
    private static final AtomicLong errors = new AtomicLong();
    private static final AtomicLong exceptions = new AtomicLong();

    /**
     * @param args
     * @throws Exception 
     */
    public static void main(String[] args) throws Exception {
        String server = "127.0.0.1:27017";
        if(args.length > 0) {
            server = args[0];
        }
        int threads = THREADS;
        if(args.length > 1) {
            threads = Integer.parseInt(args[1]);
        }

	if( args.length > 2)
		DOCUMENTS = Integer.parseInt(args[2]);
	

       
	//Set connection pool and socket timeout
        Builder optionsBuilder = new MongoClientOptions.Builder();
        optionsBuilder.connectionsPerHost(1000).autoConnectRetry(true);
        optionsBuilder.socketTimeout(5000);

	//If using Auth
	MongoCredential credential = MongoCredential.createMongoCRCredential("oz", "admin", "mongo".toCharArray());


	//TODO decide If you are using Auth
	
	
	/*Create mongoclient Object With Auth using credentials above
        */
	//MongoClient client = new MongoClient( getServers(server), Arrays.asList(credential), optionsBuilder.build());

	/*
	 *Create mongoclient Object without Auth
	 * */
	MongoClient client = new MongoClient( getServers(server), optionsBuilder.build());
	
	//TODO decide if you want non-default writeConcern	
	//Set custom write concern
	client.setWriteConcern(new WriteConcern());
        
	//get DB and collection objects	
	DB db = client.getDB("test");
        DBCollection collection = db.getCollection("test");
        
	long prevTotal = total.get();
        long start = System.currentTimeMillis();
	//launch thread pool        
        ExecutorService executor = Executors.newFixedThreadPool(threads);
        for(int i=0; i<threads; i++) {
            executor.submit(new Worker(collection));
        }
        try {
            executor.shutdown();
            while(!executor.awaitTermination(1, TimeUnit.SECONDS)) {
                long newTotal = total.get();
                System.out.println("" + (new Date()) + " TPS: " + (newTotal - prevTotal));
                prevTotal = newTotal;
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("Done: " + Thread.currentThread().getName() + ", total " + total.get() + ", errors " + errors.get() + ", exceptions " + exceptions.get() );
        System.out.println("Avg TPS: " + (total.get() * 1000 / (System.currentTimeMillis() - start)));
    }


    private static List<ServerAddress> getServers(String server) throws Exception {
	String[] pairs = server.split(",");
	List<ServerAddress> result = new ArrayList<ServerAddress>(pairs.length);   
	for (String pair : pairs) {
		String[] hostPort = pair.split(":");
		if (hostPort.length < 2) {
			throw new Exception("Incorrect mongo server " + pair);
		}
		try {
			int port = Integer.parseInt(hostPort[1]);
			result.add(new ServerAddress(hostPort[0], port));
		} catch (Exception e) {
			throw new Exception("Incorrect mongo server " + pair, e);
		}
	}
	return result;
    }



    
    private static class Worker implements Runnable {
        
        private final DBCollection collection;

        public Worker(DBCollection collection) {
            this.collection = collection;
        }

        public void run() {
            // Try to create as many events as possible
            System.out.println("Started: " + Thread.currentThread().getName());
            

	    WriteResult res;
	    for(int i=0; i<DOCUMENTS; i++) {
                try {
                    BasicDBObject o = new BasicDBObject(); 
		    //create new value
		    o.append("$set", new BasicDBObject().append("val", Math.ceil(Math.random()*1000000)));
		    //create update query 
		    BasicDBObject query = new BasicDBObject().append("val", Math.ceil(Math.random()*1000000));
		    
		    //update data
		    res = collection.update(query, o);
		    
		    total.incrementAndGet();
		    if(!res.getLastError().ok()) 
			    errors.incrementAndGet();
                    
                } catch(Exception e) {
                    	exceptions.incrementAndGet();
                    	System.err.println("Exception: " + e.getMessage() + "\n" + stackTraceToString(e));
                }
            }
        }
        
        public String stackTraceToString(Throwable e) {
            String retValue = null;
            StringWriter sw = null;
            PrintWriter pw = null;
            try {
             sw = new StringWriter();
             pw = new PrintWriter(sw);
             e.printStackTrace(pw);
             retValue = sw.toString();
            } finally {
             try {
               if(pw != null)  pw.close();
               if(sw != null)  sw.close();
             } catch (IOException ignore) {}
            }
            return retValue;
            }
    }

}
