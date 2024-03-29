package com.anders.dp.行为模式.责任链;

public abstract class Handler {
	protected Handler nextHandler;

	protected String name;

	public abstract void handleRequest(String request);

	public Handler getNextHandler() {
		return nextHandler;
	}

	public void setNextHandler(Handler nextHandler) {
		this.nextHandler = nextHandler;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Handler() {
	}

	public Handler(Handler handler) {
		this.nextHandler = handler;
	}
}
