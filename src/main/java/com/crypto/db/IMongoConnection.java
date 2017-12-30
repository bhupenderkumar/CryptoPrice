package com.crypto.db;

public interface IMongoConnection {

	
	String username="";
	String password="";
	String url ="localhost";
	int port=27017;
	String coinMarketUrl="https://min-api.cryptocompare.com/data/price";
	
	public boolean testConnection();
}
