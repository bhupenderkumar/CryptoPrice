package com.crypto.db;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;

public class MongoConnection implements IMongoConnection {

	public boolean testConnection() {
		// TODO Auto-generated method stub
		MongoClient mongoClient = new MongoClient();
		DB db = mongoClient.getDB("crypto");
		DBCollection school = db.getCollection("college");
		System.out.println("Collection mycol created successfully");
		return true;
	}

	public static void main(String[] args) {
		String coiTecko = storeInDB("XRP","INR");
		MongoClient mongoClient = new MongoClient(url,port);
		DB db = mongoClient.getDB("crypto");
		System.out.println("Connect to database successfully");
		Records t = new Records();
		t.setId(10011);
		t.setName(coiTecko);
		DBCollection collection = null;
		collection = db.getCollection("test");
		collection.save(t);
		System.err.println(collection.findOne(10011));
	}

	public static String storeInDB(String fsym,String tsyms) {
//		String fsym ="XRP";
//		String tsyms ="BTC,USD,INR";
		try {
			URL url = new URL(coinMarketUrl+"?fsym="+fsym+"&tsyms="+tsyms);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			StringBuilder builder = new StringBuilder();
			while ((output = br.readLine()) != null) {
				builder.append(output);
			}
			conn.disconnect();
			return builder.toString();
		} catch (MalformedURLException e) {

			e.printStackTrace();

		} catch (IOException e) {

			e.printStackTrace();

		}
		return "";
	}

}
