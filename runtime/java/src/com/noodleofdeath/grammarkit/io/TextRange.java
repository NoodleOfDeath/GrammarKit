package com.noodleofdeath.pastaparser.io;

public interface TextRange {
	public abstract int start();

	public abstract int end();

	public default int length() {
		return (start() >= 0) && (end() >= 0) ? end() - start() : 0;
	}
}
