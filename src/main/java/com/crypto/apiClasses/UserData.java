package com.crypto.apiClasses;

public class UserData {
	
	String cryptoCurrency;
	double quantity;
	String requestedCurr;
	public String getCryptoCurrency() {
		return cryptoCurrency;
	}
	public void setCryptoCurrency(String cryptoCurrency) {
		this.cryptoCurrency = cryptoCurrency;
	}
	public double getQuantity() {
		return quantity;
	}
	public void setQuantity(double quantity) {
		this.quantity = quantity;
	}
	public String getRequestedCurr() {
		return requestedCurr;
	}
	public void setRequestedCurr(String requestedCurr) {
		this.requestedCurr = requestedCurr;
	}
	

}
