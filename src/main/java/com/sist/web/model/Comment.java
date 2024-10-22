package com.sist.web.model;

import java.io.Serializable;

public class Comment implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long ccsSeq;
	private long bbsSeq;
	private String userId;
	private String ccsName;
	private String ccsContent;
	private String regDate;
	
	public Comment() {
		ccsSeq = 0;
		bbsSeq = 0;
		userId ="";
		ccsName = "";
		ccsContent = "";
		regDate = "";
	}

	public long getCcsSeq() {
		return ccsSeq;
	}

	public void setCcsSeq(long ccsSeq) {
		this.ccsSeq = ccsSeq;
	}

	public long getBbsSeq() {
		return bbsSeq;
	}

	public void setBbsSeq(long bbsSeq) {
		this.bbsSeq = bbsSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getCcsName() {
		return ccsName;
	}

	public void setCcsName(String ccsName) {
		this.ccsName = ccsName;
	}

	public String getCcsContent() {
		return ccsContent;
	}

	public void setCcsContent(String ccsContent) {
		this.ccsContent = ccsContent;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
}
