package com.accasw.ristoranteApp.exception;

public class UnauthorizedApiException extends RuntimeException {

	public UnauthorizedApiException(String message) {
		super(message);
	}
}