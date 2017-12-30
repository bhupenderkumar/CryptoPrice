package com.crypto.config;

import org.springframework.data.mongodb.repository.MongoRepository;

import com.crypto.apiClasses.CoinMarketCap;

public interface UserRepository extends MongoRepository<CoinMarketCap, String> {

	
	//
}


