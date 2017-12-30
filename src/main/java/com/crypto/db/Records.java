package com.crypto.db;

import com.mongodb.BasicDBObject;

public class Records extends BasicDBObject {

	private String name;

	public void setName(String name) {
		this.put("name", name);
	}

	public String getName() {

		return (String) this.get("name");
	}

	public Integer getId() {
		return (Integer) this.get("_id");
	}

	public void setId(Integer id) {
		this.put("_id", id);
	}

}
